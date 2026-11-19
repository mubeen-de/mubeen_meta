import type { Response } from "express";
import { prisma } from "../prisma";
import type { AuthedRequest } from "../middleware/require-auth";

export interface ReportSummaryCard {
  label: string;
  value: string;
  tone?: "default" | "success" | "danger" | "info";
}

export interface ReportColumn {
  key: string;
  label: string;
  align?: "left" | "right" | "center";
  isCurrency?: boolean;
}

export interface SuiteReportResponse {
  reportKey: string;
  title: string;
  description: string;
  generatedAt: string;
  fromDate: string | null;
  toDate: string | null;
  scope: "all" | "outlet";
  summary: ReportSummaryCard[];
  columns: ReportColumn[];
  rows: Array<Record<string, string | number>>;
}

function fmtMoney(minor: number | bigint): string {
  return `₹${(Number(minor) / 100).toFixed(2)}`;
}

function fmtDateTime(d: Date): string {
  return new Date(d).toLocaleString("en-IN", {
    day: "2-digit",
    month: "short",
    year: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  });
}

function fmtDateOnly(d: Date): string {
  return new Date(d).toISOString().slice(0, 10);
}

function parseDateBounds(req: AuthedRequest): { fromDate: Date | null; toDate: Date | null } {
  if (req.query.allTime === "true") {
    return { fromDate: null, toDate: null };
  }
  const rawFrom = req.query.fromDate ?? req.query.startDate;
  const rawTo = req.query.toDate ?? req.query.endDate;
  if (typeof rawFrom === "string" && rawFrom && typeof rawTo === "string" && rawTo) {
    const start = new Date(rawFrom);
    if (rawFrom.length === 10) start.setHours(0, 0, 0, 0);
    const end = new Date(rawTo);
    if (rawTo.length === 10) end.setHours(23, 59, 59, 999);
    if (!isNaN(start.getTime()) && !isNaN(end.getTime())) {
      return { fromDate: start, toDate: end };
    }
  }
  // Default: last 30 days through end of today
  const now = new Date();
  const end = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 23, 59, 59, 999);
  const start = new Date(end.getTime() - 29 * 24 * 60 * 60 * 1000);
  start.setHours(0, 0, 0, 0);
  return { fromDate: start, toDate: end };
}

function getCustomerDisplayName(c?: { name: string | null; firstName: string | null; lastName: string | null } | null): string {
  if (!c) return "Walk-in Customer";
  if (c.name && c.name.trim()) return c.name.trim();
  const full = `${c.firstName || ""} ${c.lastName || ""}`.trim();
  return full || "Walk-in Customer";
}

function deriveLocality(
  order: {
    orderType: string;
    channel: string | null;
    diningTable?: { section: string; tableNumber: string } | null;
  },
  outlet?: { address: string | null; name: string } | null
): string {
  if (order.orderType === "DINE_IN") {
    return order.diningTable?.section ? `Dine-In · ${order.diningTable.section}` : "Dine-In · Main Hall";
  }
  if (order.channel && order.channel.trim() && order.channel !== "POS") {
    return `${order.orderType} · ${order.channel}`;
  }
  if (outlet?.address && outlet.address.trim()) {
    const parts = outlet.address.split(",").map((p) => p.trim()).filter(Boolean);
    const area = parts.length >= 2 ? parts[parts.length - 2] : parts[0];
    return `${order.orderType === "DELIVERY" ? "Delivery" : "Pickup"} · ${area}`;
  }
  return order.orderType === "DELIVERY" ? "Delivery · Local Zone" : "Pickup · Counter";
}

export async function handleSuiteReport(req: AuthedRequest, res: Response): Promise<void> {
  try {
    const reportKey = String(req.params.reportKey || "").trim();
    const outletId = req.auth!.outletId;
    const scope: "all" | "outlet" = req.query.scope === "outlet" ? "outlet" : "all";
    const { fromDate, toDate } = parseDateBounds(req);

    // Resolve accessible outlets within the current organization
    const currentOutlet = await prisma.outlet.findUnique({
      where: { id: outletId },
      select: { id: true, organizationId: true, name: true, code: true, address: true },
    });

    const outlets =
      scope === "all" && currentOutlet?.organizationId
        ? await prisma.outlet.findMany({
            where: { organizationId: currentOutlet.organizationId },
            select: { id: true, name: true, code: true, address: true },
          })
        : currentOutlet
        ? [currentOutlet]
        : [];

    const outletIds = outlets.length > 0 ? outlets.map((o) => o.id) : [outletId];
    const outletMap = new Map(outlets.map((o) => [o.id, o]));

    const orderWhere: any = {
      outletId: { in: outletIds },
    };
    if (fromDate && toDate) {
      orderWhere.createdAt = { gte: fromDate, lte: toDate };
    }

    const orders = await prisma.order.findMany({
      where: orderWhere,
      orderBy: { createdAt: "desc" },
      include: {
        diningTable: { select: { tableNumber: true, section: true } },
        orderItems: {
          include: {
            menuItem: {
              include: {
                category: { select: { id: true, name: true } },
              },
            },
          },
        },
      },
    });

    const orderIds = orders.map((o) => o.id);
    const customerIds = Array.from(new Set(orders.map((o) => o.customerId).filter((x): x is string => Boolean(x))));

    type CustomerSlim = {
      id: string;
      name: string | null;
      firstName: string | null;
      lastName: string | null;
      phone: string;
      email: string | null;
      loyaltyPoints: number;
    };

    const customers: CustomerSlim[] =
      customerIds.length > 0
        ? await prisma.customer.findMany({
            where: { id: { in: customerIds } },
            select: { id: true, name: true, firstName: true, lastName: true, phone: true, email: true, loyaltyPoints: true },
          })
        : [];
    const payments =
      orderIds.length > 0
        ? await prisma.payment.findMany({ where: { orderId: { in: orderIds } } })
        : [];
    const invoices =
      orderIds.length > 0
        ? await prisma.invoice.findMany({ where: { orderId: { in: orderIds } } })
        : [];

    const customerMap = new Map<string, CustomerSlim>(customers.map((c) => [c.id, c]));
    const invoiceByOrder = new Map(invoices.map((inv) => [inv.orderId, inv]));
    const paymentsByOrder = new Map<string, typeof payments>();
    for (const p of payments) {
      const list = paymentsByOrder.get(p.orderId) || [];
      list.push(p);
      paymentsByOrder.set(p.orderId, list);
    }

    const isCancelledStatus = (s: string) => s === "CANCELLED" || s === "VOIDED";
    const activeOrders = orders.filter((o) => !isCancelledStatus(o.status));

    const buildBase = (
      title: string,
      description: string,
      summary: ReportSummaryCard[],
      columns: ReportColumn[],
      rows: Array<Record<string, string | number>>
    ): SuiteReportResponse => ({
      reportKey,
      title,
      description,
      generatedAt: new Date().toISOString(),
      fromDate: fromDate ? fromDate.toISOString() : null,
      toDate: toDate ? toDate.toISOString() : null,
      scope,
      summary,
      columns,
      rows,
    });

    // 1. Category Wise Report: All Restaurants
    if (reportKey === "category-wise") {
      const agg = new Map<
        string,
        {
          restaurant: string;
          category: string;
          itemNames: Set<string>;
          orders: Set<string>;
          qty: number;
          grossMinor: number;
          taxMinor: number;
          netMinor: number;
        }
      >();

      let grandGross = 0;
      let grandTax = 0;
      let totalQty = 0;

      for (const o of activeOrders) {
        const restName = outletMap.get(o.outletId)?.name || "Main Outlet";
        const orderSub = Number(o.subtotal || 0n);
        const orderTax = Number(o.taxTotal || 0n);

        for (const it of o.orderItems) {
          if (it.isVoided) continue;
          const catName = it.menuItem?.category?.name || "Uncategorized";
          const key = `${o.outletId}::${catName}`;
          const itemSub = Number(it.subtotal || BigInt(it.quantity) * BigInt(it.unitPrice || 0n));
          const itemTax = orderSub > 0 ? Math.round((itemSub / orderSub) * orderTax) : Math.round(itemSub * 0.05);

          const entry = agg.get(key) || {
            restaurant: restName,
            category: catName,
            itemNames: new Set<string>(),
            orders: new Set<string>(),
            qty: 0,
            grossMinor: 0,
            taxMinor: 0,
            netMinor: 0,
          };
          entry.itemNames.add(it.menuItem?.name || it.menuItemId);
          entry.orders.add(o.id);
          entry.qty += Number(it.quantity || 0);
          entry.grossMinor += itemSub;
          entry.taxMinor += itemTax;
          entry.netMinor += itemSub + itemTax;
          agg.set(key, entry);

          grandGross += itemSub;
          grandTax += itemTax;
          totalQty += Number(it.quantity || 0);
        }
      }

      const sorted = Array.from(agg.values()).sort((a, b) => b.netMinor - a.netMinor);
      const totalNet = grandGross + grandTax;
      const rows = sorted.map((r) => ({
        restaurant: r.restaurant,
        category: r.category,
        distinctItems: r.itemNames.size,
        ordersCount: r.orders.size,
        qtySold: r.qty,
        grossSales: Number((r.grossMinor / 100).toFixed(2)),
        cgst: Number((r.taxMinor / 200).toFixed(2)),
        sgst: Number((r.taxMinor / 200).toFixed(2)),
        netSales: Number((r.netMinor / 100).toFixed(2)),
        sharePct: totalNet > 0 ? `${((r.netMinor / totalNet) * 100).toFixed(1)}%` : "0.0%",
      }));

      res.status(200).json(
        buildBase(
          "Category Wise Report: All Restaurants",
          "Total sales from each category in your restaurant",
          [
            { label: "Categories", value: String(rows.length), tone: "info" },
            { label: "Total Qty Sold", value: String(totalQty) },
            { label: "Gross Sales", value: fmtMoney(grandGross) },
            { label: "Total GST (5%)", value: fmtMoney(grandTax) },
            { label: "Net Sales", value: fmtMoney(totalNet), tone: "success" },
          ],
          [
            { key: "restaurant", label: "Restaurant" },
            { key: "category", label: "Category" },
            { key: "distinctItems", label: "Items", align: "right" },
            { key: "ordersCount", label: "Orders", align: "right" },
            { key: "qtySold", label: "Qty Sold", align: "right" },
            { key: "grossSales", label: "Gross Sales (₹)", align: "right", isCurrency: true },
            { key: "cgst", label: "CGST 2.5% (₹)", align: "right", isCurrency: true },
            { key: "sgst", label: "SGST 2.5% (₹)", align: "right", isCurrency: true },
            { key: "netSales", label: "Net Sales (₹)", align: "right", isCurrency: true },
            { key: "sharePct", label: "Share", align: "right" },
          ],
          rows
        )
      );
      return;
    }

    // 2. Orders Master Report: All Restaurants
    if (reportKey === "orders-master") {
      let totalSub = 0;
      let totalDisc = 0;
      let totalTax = 0;
      let totalGrand = 0;

      const rows = orders.map((o) => {
        const restName = outletMap.get(o.outletId)?.name || "Main Outlet";
        const cust = o.customerId ? customerMap.get(o.customerId) : null;
        const ordPays = paymentsByOrder.get(o.id) || [];
        const payMode = ordPays.length > 1 ? "SPLIT" : ordPays[0]?.method || "UNPAID";
        const invNo = invoiceByOrder.get(o.id)?.invoiceNumber || `INV-${o.orderNumber}`;
        const sub = Number(o.subtotal || 0n);
        const disc = Number(o.discountTotal || 0n);
        const tax = Number(o.taxTotal || 0n);
        const charges = Number(o.serviceChargeTotal || 0n) + Number(o.tipTotal || 0n);
        const grand = Number(o.grandTotal || 0n);

        if (!isCancelledStatus(o.status)) {
          totalSub += sub;
          totalDisc += disc;
          totalTax += tax;
          totalGrand += grand;
        }

        return {
          date: fmtDateTime(o.createdAt),
          restaurant: restName,
          invoiceNo: invNo,
          orderNumber: o.orderNumber,
          orderType: o.orderType,
          tableOrChannel: o.diningTable?.tableNumber ? `Table ${o.diningTable.tableNumber}` : o.channel || o.orderType,
          customerName: getCustomerDisplayName(cust),
          customerPhone: cust?.phone || "—",
          status: o.status,
          paymentMode: payMode,
          subtotal: Number((sub / 100).toFixed(2)),
          discount: Number((disc / 100).toFixed(2)),
          cgst: Number((tax / 200).toFixed(2)),
          sgst: Number((tax / 200).toFixed(2)),
          charges: Number((charges / 100).toFixed(2)),
          grandTotal: Number((grand / 100).toFixed(2)),
        };
      });

      res.status(200).json(
        buildBase(
          "Orders Master Report: All Restaurants",
          "All restaurants orders with customer information & charges incurred on each bill",
          [
            { label: "Total Orders", value: String(orders.length), tone: "info" },
            { label: "Active Subtotal", value: fmtMoney(totalSub) },
            { label: "Total Discount", value: fmtMoney(totalDisc), tone: "danger" },
            { label: "Total GST", value: fmtMoney(totalTax) },
            { label: "Grand Total", value: fmtMoney(totalGrand), tone: "success" },
          ],
          [
            { key: "date", label: "Date & Time" },
            { key: "restaurant", label: "Restaurant" },
            { key: "invoiceNo", label: "Invoice #" },
            { key: "orderType", label: "Type" },
            { key: "tableOrChannel", label: "Table / Channel" },
            { key: "customerName", label: "Customer" },
            { key: "customerPhone", label: "Phone" },
            { key: "status", label: "Status", align: "center" },
            { key: "paymentMode", label: "Payment", align: "center" },
            { key: "subtotal", label: "Subtotal (₹)", align: "right", isCurrency: true },
            { key: "discount", label: "Discount (₹)", align: "right", isCurrency: true },
            { key: "cgst", label: "CGST (₹)", align: "right", isCurrency: true },
            { key: "sgst", label: "SGST (₹)", align: "right", isCurrency: true },
            { key: "charges", label: "Charges (₹)", align: "right", isCurrency: true },
            { key: "grandTotal", label: "Grand Total (₹)", align: "right", isCurrency: true },
          ],
          rows
        )
      );
      return;
    }

    // 3. Order Report: Item Wise All Restaurants
    if (reportKey === "order-item-wise") {
      const rows: Array<Record<string, string | number>> = [];
      let totalQty = 0;
      let totalSub = 0;
      let totalTax = 0;

      for (const o of activeOrders) {
        const restName = outletMap.get(o.outletId)?.name || "Main Outlet";
        const cust = o.customerId ? customerMap.get(o.customerId) : null;
        const ordSub = Number(o.subtotal || 0n);
        const ordTax = Number(o.taxTotal || 0n);
        const ordDisc = Number(o.discountTotal || 0n);

        for (const it of o.orderItems) {
          if (it.isVoided) continue;
          const unit = Number(it.unitPrice || 0n);
          const sub = Number(it.subtotal || BigInt(it.quantity) * BigInt(it.unitPrice || 0n));
          const share = ordSub > 0 ? sub / ordSub : 0;
          const tax = ordSub > 0 ? Math.round(share * ordTax) : Math.round(sub * 0.05);
          const disc = ordSub > 0 ? Math.round(share * ordDisc) : 0;
          const net = sub - disc + tax;

          totalQty += Number(it.quantity || 0);
          totalSub += sub;
          totalTax += tax;

          rows.push({
            date: fmtDateTime(o.createdAt),
            restaurant: restName,
            orderNumber: o.orderNumber,
            orderType: o.orderType,
            customerName: getCustomerDisplayName(cust),
            customerPhone: cust?.phone || "—",
            category: it.menuItem?.category?.name || "Uncategorized",
            itemName: it.menuItem?.name || "Menu Item",
            qty: Number(it.quantity || 0),
            unitPrice: Number((unit / 100).toFixed(2)),
            subtotal: Number((sub / 100).toFixed(2)),
            discount: Number((disc / 100).toFixed(2)),
            tax: Number((tax / 100).toFixed(2)),
            total: Number((net / 100).toFixed(2)),
            status: o.status,
          });
        }
      }

      res.status(200).json(
        buildBase(
          "Order Report: Item Wise All Restaurants",
          "All restaurants item wise orders with customer information & charges",
          [
            { label: "Line Items", value: String(rows.length), tone: "info" },
            { label: "Total Qty", value: String(totalQty) },
            { label: "Item Subtotal", value: fmtMoney(totalSub) },
            { label: "GST Collected", value: fmtMoney(totalTax) },
            { label: "Total Amount", value: fmtMoney(totalSub + totalTax), tone: "success" },
          ],
          [
            { key: "date", label: "Date & Time" },
            { key: "restaurant", label: "Restaurant" },
            { key: "orderNumber", label: "Order #" },
            { key: "orderType", label: "Type" },
            { key: "customerName", label: "Customer" },
            { key: "customerPhone", label: "Phone" },
            { key: "category", label: "Category" },
            { key: "itemName", label: "Item Name" },
            { key: "qty", label: "Qty", align: "right" },
            { key: "unitPrice", label: "Rate (₹)", align: "right", isCurrency: true },
            { key: "subtotal", label: "Subtotal (₹)", align: "right", isCurrency: true },
            { key: "discount", label: "Discount (₹)", align: "right", isCurrency: true },
            { key: "tax", label: "Tax (₹)", align: "right", isCurrency: true },
            { key: "total", label: "Total (₹)", align: "right", isCurrency: true },
            { key: "status", label: "Status", align: "center" },
          ],
          rows
        )
      );
      return;
    }

    // 4. Cancel Order Report: Item Wise All Restaurants
    if (reportKey === "cancel-order-item-wise") {
      const rows: Array<Record<string, string | number>> = [];
      let cancelledOrdersSet = new Set<string>();
      let totalCancelledQty = 0;
      let totalCancelledValue = 0;

      for (const o of orders) {
        const restName = outletMap.get(o.outletId)?.name || "Main Outlet";
        const cust = o.customerId ? customerMap.get(o.customerId) : null;
        const orderCancelled = isCancelledStatus(o.status);

        for (const it of o.orderItems) {
          if (!orderCancelled && !it.isVoided) continue;
          const unit = Number(it.unitPrice || 0n);
          const sub = Number(it.subtotal || BigInt(it.quantity) * BigInt(it.unitPrice || 0n));
          const tax = Math.round(sub * 0.05);
          const total = sub + tax;

          cancelledOrdersSet.add(o.id);
          totalCancelledQty += Number(it.quantity || 0);
          totalCancelledValue += total;

          rows.push({
            date: fmtDateTime(o.createdAt),
            restaurant: restName,
            orderNumber: o.orderNumber,
            orderType: o.orderType,
            customerName: getCustomerDisplayName(cust),
            customerPhone: cust?.phone || "—",
            category: it.menuItem?.category?.name || "Uncategorized",
            itemName: it.menuItem?.name || "Menu Item",
            qty: Number(it.quantity || 0),
            unitPrice: Number((unit / 100).toFixed(2)),
            cancelledAmount: Number((total / 100).toFixed(2)),
            cancelType: orderCancelled ? "Order Cancelled" : "Item Voided",
            reason: it.voidReason || (orderCancelled ? "Bill Cancelled" : "Cashier Void"),
            cancelledBy: it.voidedBy || "Cashier / Staff",
          });
        }
      }

      res.status(200).json(
        buildBase(
          "Cancel Order Report: Item Wise All Restaurants",
          "A summary of all your item wise orders with customer information and charges incurred on each cancelled bill",
          [
            { label: "Affected Bills", value: String(cancelledOrdersSet.size), tone: "info" },
            { label: "Cancelled Lines", value: String(rows.length) },
            { label: "Cancelled Qty", value: String(totalCancelledQty) },
            { label: "Cancelled Value", value: fmtMoney(totalCancelledValue), tone: "danger" },
          ],
          [
            { key: "date", label: "Date & Time" },
            { key: "restaurant", label: "Restaurant" },
            { key: "orderNumber", label: "Order #" },
            { key: "orderType", label: "Type" },
            { key: "customerName", label: "Customer" },
            { key: "customerPhone", label: "Phone" },
            { key: "itemName", label: "Item Name" },
            { key: "qty", label: "Qty", align: "right" },
            { key: "unitPrice", label: "Rate (₹)", align: "right", isCurrency: true },
            { key: "cancelledAmount", label: "Cancelled Amt (₹)", align: "right", isCurrency: true },
            { key: "cancelType", label: "Cancel Type", align: "center" },
            { key: "reason", label: "Reason" },
            { key: "cancelledBy", label: "Action By" },
          ],
          rows
        )
      );
      return;
    }

    // 5. Locality Wise Report: All Restaurants
    if (reportKey === "locality-wise") {
      const agg = new Map<
        string,
        {
          locality: string;
          restaurant: string;
          orderType: string;
          totalOrders: number;
          completedOrders: number;
          cancelledOrders: number;
          qty: number;
          subtotalMinor: number;
          taxMinor: number;
          totalMinor: number;
        }
      >();

      let grandOrders = 0;
      let grandSales = 0;

      for (const o of orders) {
        const outlet = outletMap.get(o.outletId);
        const restName = outlet?.name || "Main Outlet";
        const locality = deriveLocality(o, outlet);
        const key = `${o.outletId}::${locality}::${o.orderType}`;

        const entry = agg.get(key) || {
          locality,
          restaurant: restName,
          orderType: o.orderType,
          totalOrders: 0,
          completedOrders: 0,
          cancelledOrders: 0,
          qty: 0,
          subtotalMinor: 0,
          taxMinor: 0,
          totalMinor: 0,
        };

        entry.totalOrders += 1;
        grandOrders += 1;
        if (isCancelledStatus(o.status)) {
          entry.cancelledOrders += 1;
        } else {
          if (o.status === "COMPLETED") entry.completedOrders += 1;
          entry.qty += o.orderItems.filter((i) => !i.isVoided).reduce((s, i) => s + Number(i.quantity || 0), 0);
          entry.subtotalMinor += Number(o.subtotal || 0n);
          entry.taxMinor += Number(o.taxTotal || 0n);
          entry.totalMinor += Number(o.grandTotal || 0n);
          grandSales += Number(o.grandTotal || 0n);
        }

        agg.set(key, entry);
      }

      const sorted = Array.from(agg.values()).sort((a, b) => b.totalMinor - a.totalMinor);
      const rows = sorted.map((r) => {
        const activeCount = r.totalOrders - r.cancelledOrders;
        const aov = activeCount > 0 ? r.totalMinor / activeCount : 0;
        return {
          locality: r.locality,
          restaurant: r.restaurant,
          orderType: r.orderType,
          totalOrders: r.totalOrders,
          completedOrders: r.completedOrders,
          cancelledOrders: r.cancelledOrders,
          totalQty: r.qty,
          subtotal: Number((r.subtotalMinor / 100).toFixed(2)),
          tax: Number((r.taxMinor / 100).toFixed(2)),
          totalSales: Number((r.totalMinor / 100).toFixed(2)),
          aov: Number((aov / 100).toFixed(2)),
        };
      });

      res.status(200).json(
        buildBase(
          "Locality Wise Report: All Restaurants",
          "Total orders of all restaurants grouped by locality",
          [
            { label: "Localities / Zones", value: String(rows.length), tone: "info" },
            { label: "Total Orders", value: String(grandOrders) },
            { label: "Total Revenue", value: fmtMoney(grandSales), tone: "success" },
          ],
          [
            { key: "locality", label: "Locality / Zone" },
            { key: "restaurant", label: "Restaurant" },
            { key: "orderType", label: "Order Type" },
            { key: "totalOrders", label: "Total Orders", align: "right" },
            { key: "completedOrders", label: "Completed", align: "right" },
            { key: "cancelledOrders", label: "Cancelled", align: "right" },
            { key: "totalQty", label: "Total Qty", align: "right" },
            { key: "subtotal", label: "Subtotal (₹)", align: "right", isCurrency: true },
            { key: "tax", label: "GST (₹)", align: "right", isCurrency: true },
            { key: "totalSales", label: "Total Sales (₹)", align: "right", isCurrency: true },
            { key: "aov", label: "Avg Bill (₹)", align: "right", isCurrency: true },
          ],
          rows
        )
      );
      return;
    }

    // 6. Item Report: Invoice Details
    if (reportKey === "item-invoice-details") {
      const rows: Array<Record<string, string | number>> = [];
      let totalQty = 0;
      let totalTaxable = 0;
      let totalTax = 0;

      for (const o of activeOrders) {
        const inv = invoiceByOrder.get(o.id);
        const invNo = inv?.invoiceNumber || `INV-${o.orderNumber}`;
        const restName = outletMap.get(o.outletId)?.name || "Main Outlet";
        const ordSub = Number(o.subtotal || 0n);
        const ordTax = Number(o.taxTotal || 0n);

        for (const it of o.orderItems) {
          if (it.isVoided) continue;
          const unit = Number(it.unitPrice || 0n);
          const sub = Number(it.subtotal || BigInt(it.quantity) * BigInt(it.unitPrice || 0n));
          const tax = ordSub > 0 ? Math.round((sub / ordSub) * ordTax) : Math.round(sub * 0.05);
          totalQty += Number(it.quantity || 0);
          totalTaxable += sub;
          totalTax += tax;

          rows.push({
            date: fmtDateTime(o.createdAt),
            invoiceNo: invNo,
            restaurant: restName,
            group: it.menuItem?.category?.name || "General",
            itemName: it.menuItem?.name || "Menu Item",
            qty: Number(it.quantity || 0),
            unitPrice: Number((unit / 100).toFixed(2)),
            taxableAmt: Number((sub / 100).toFixed(2)),
            cgst: Number((tax / 200).toFixed(2)),
            sgst: Number((tax / 200).toFixed(2)),
            lineTotal: Number(((sub + tax) / 100).toFixed(2)),
          });
        }
      }

      res.status(200).json(
        buildBase(
          "Item Report: Invoice Details",
          "Total items sold under each group in your restaurant",
          [
            { label: "Invoice Lines", value: String(rows.length), tone: "info" },
            { label: "Total Items Sold", value: String(totalQty) },
            { label: "Taxable Value", value: fmtMoney(totalTaxable) },
            { label: "GST (CGST+SGST)", value: fmtMoney(totalTax) },
            { label: "Invoiced Total", value: fmtMoney(totalTaxable + totalTax), tone: "success" },
          ],
          [
            { key: "date", label: "Invoice Date" },
            { key: "invoiceNo", label: "Invoice #" },
            { key: "restaurant", label: "Restaurant" },
            { key: "group", label: "Category Group" },
            { key: "itemName", label: "Item Name" },
            { key: "qty", label: "Qty", align: "right" },
            { key: "unitPrice", label: "Unit Rate (₹)", align: "right", isCurrency: true },
            { key: "taxableAmt", label: "Taxable (₹)", align: "right", isCurrency: true },
            { key: "cgst", label: "CGST 2.5% (₹)", align: "right", isCurrency: true },
            { key: "sgst", label: "SGST 2.5% (₹)", align: "right", isCurrency: true },
            { key: "lineTotal", label: "Line Total (₹)", align: "right", isCurrency: true },
          ],
          rows
        )
      );
      return;
    }

    // 7. Item Wise Report: All Restaurants
    if (reportKey === "item-wise") {
      const agg = new Map<
        string,
        {
          itemName: string;
          category: string;
          isVeg: boolean;
          orders: Set<string>;
          qty: number;
          grossMinor: number;
          taxMinor: number;
        }
      >();

      let grandGross = 0;
      let grandTax = 0;
      let totalQty = 0;

      for (const o of activeOrders) {
        const ordSub = Number(o.subtotal || 0n);
        const ordTax = Number(o.taxTotal || 0n);
        for (const it of o.orderItems) {
          if (it.isVoided) continue;
          const itemName = it.menuItem?.name || `Item (${it.menuItemId.slice(0, 6)})`;
          const catName = it.menuItem?.category?.name || "Uncategorized";
          const key = itemName.toLowerCase();
          const sub = Number(it.subtotal || BigInt(it.quantity) * BigInt(it.unitPrice || 0n));
          const tax = ordSub > 0 ? Math.round((sub / ordSub) * ordTax) : Math.round(sub * 0.05);

          const entry = agg.get(key) || {
            itemName,
            category: catName,
            isVeg: it.menuItem?.isVeg ?? true,
            orders: new Set<string>(),
            qty: 0,
            grossMinor: 0,
            taxMinor: 0,
          };
          entry.orders.add(o.id);
          entry.qty += Number(it.quantity || 0);
          entry.grossMinor += sub;
          entry.taxMinor += tax;
          agg.set(key, entry);

          grandGross += sub;
          grandTax += tax;
          totalQty += Number(it.quantity || 0);
        }
      }

      const sorted = Array.from(agg.values()).sort((a, b) => b.grossMinor - a.grossMinor);
      const totalNet = grandGross + grandTax;
      const rows = sorted.map((r) => ({
        itemName: r.itemName,
        category: r.category,
        dietary: r.isVeg ? "Veg" : "Non-Veg",
        ordersCount: r.orders.size,
        qtySold: r.qty,
        avgRate: Number((r.qty > 0 ? r.grossMinor / r.qty / 100 : 0).toFixed(2)),
        grossSales: Number((r.grossMinor / 100).toFixed(2)),
        gst: Number((r.taxMinor / 100).toFixed(2)),
        netTotal: Number(((r.grossMinor + r.taxMinor) / 100).toFixed(2)),
        sharePct: totalNet > 0 ? `${(((r.grossMinor + r.taxMinor) / totalNet) * 100).toFixed(1)}%` : "0.0%",
      }));

      res.status(200).json(
        buildBase(
          "Item Wise Report: All Restaurants",
          "Total sales from each item in your restaurant",
          [
            { label: "Unique Items Sold", value: String(rows.length), tone: "info" },
            { label: "Total Qty Sold", value: String(totalQty) },
            { label: "Gross Sales", value: fmtMoney(grandGross) },
            { label: "Total GST", value: fmtMoney(grandTax) },
            { label: "Net Revenue", value: fmtMoney(totalNet), tone: "success" },
          ],
          [
            { key: "itemName", label: "Item Name" },
            { key: "category", label: "Category" },
            { key: "dietary", label: "Diet", align: "center" },
            { key: "ordersCount", label: "Orders", align: "right" },
            { key: "qtySold", label: "Qty Sold", align: "right" },
            { key: "avgRate", label: "Avg Rate (₹)", align: "right", isCurrency: true },
            { key: "grossSales", label: "Gross Sales (₹)", align: "right", isCurrency: true },
            { key: "gst", label: "GST 5% (₹)", align: "right", isCurrency: true },
            { key: "netTotal", label: "Net Total (₹)", align: "right", isCurrency: true },
            { key: "sharePct", label: "Share", align: "right" },
          ],
          rows
        )
      );
      return;
    }

    // 8. Item Wise Report (Brand Wise): All Restaurants
    if (reportKey === "item-wise-brand") {
      const agg = new Map<
        string,
        {
          brand: string;
          outletCode: string;
          category: string;
          itemName: string;
          isVeg: boolean;
          qty: number;
          grossMinor: number;
          taxMinor: number;
        }
      >();

      let grandGross = 0;
      let grandTax = 0;
      let totalQty = 0;

      for (const o of activeOrders) {
        const outlet = outletMap.get(o.outletId);
        const brand = outlet?.name || "Main Brand";
        const outletCode = outlet?.code || "OUTLET-1";
        const ordSub = Number(o.subtotal || 0n);
        const ordTax = Number(o.taxTotal || 0n);

        for (const it of o.orderItems) {
          if (it.isVoided) continue;
          const itemName = it.menuItem?.name || `Item (${it.menuItemId.slice(0, 6)})`;
          const catName = it.menuItem?.category?.name || "Uncategorized";
          const key = `${o.outletId}::${it.menuItemId}`;
          const sub = Number(it.subtotal || BigInt(it.quantity) * BigInt(it.unitPrice || 0n));
          const tax = ordSub > 0 ? Math.round((sub / ordSub) * ordTax) : Math.round(sub * 0.05);

          const entry = agg.get(key) || {
            brand,
            outletCode,
            category: catName,
            itemName,
            isVeg: it.menuItem?.isVeg ?? true,
            qty: 0,
            grossMinor: 0,
            taxMinor: 0,
          };
          entry.qty += Number(it.quantity || 0);
          entry.grossMinor += sub;
          entry.taxMinor += tax;
          agg.set(key, entry);

          grandGross += sub;
          grandTax += tax;
          totalQty += Number(it.quantity || 0);
        }
      }

      const sorted = Array.from(agg.values()).sort((a, b) => b.grossMinor - a.grossMinor);
      const rows = sorted.map((r) => ({
        brand: r.brand,
        outletCode: r.outletCode,
        category: r.category,
        itemName: r.itemName,
        dietary: r.isVeg ? "Veg" : "Non-Veg",
        qtySold: r.qty,
        grossSales: Number((r.grossMinor / 100).toFixed(2)),
        gst: Number((r.taxMinor / 100).toFixed(2)),
        netTotal: Number(((r.grossMinor + r.taxMinor) / 100).toFixed(2)),
      }));

      res.status(200).json(
        buildBase(
          "Item Wise Report (Brand Wise): All Restaurants",
          "Total sales from each item grouped by restaurant brand and outlet",
          [
            { label: "Brands / Outlets", value: String(new Set(rows.map((r) => r.brand)).size), tone: "info" },
            { label: "Item Rows", value: String(rows.length) },
            { label: "Total Qty Sold", value: String(totalQty) },
            { label: "Net Sales", value: fmtMoney(grandGross + grandTax), tone: "success" },
          ],
          [
            { key: "brand", label: "Brand / Restaurant" },
            { key: "outletCode", label: "Outlet Code" },
            { key: "category", label: "Category" },
            { key: "itemName", label: "Item Name" },
            { key: "dietary", label: "Diet", align: "center" },
            { key: "qtySold", label: "Qty Sold", align: "right" },
            { key: "grossSales", label: "Gross Sales (₹)", align: "right", isCurrency: true },
            { key: "gst", label: "GST 5% (₹)", align: "right", isCurrency: true },
            { key: "netTotal", label: "Net Total (₹)", align: "right", isCurrency: true },
          ],
          rows
        )
      );
      return;
    }

    // 9. Customer Wise Sales Report
    if (reportKey === "customer-wise") {
      const agg = new Map<
        string,
        {
          customerName: string;
          phone: string;
          email: string;
          loyaltyPoints: number;
          ordersCount: number;
          totalSpendMinor: number;
          lastVisit: Date;
        }
      >();

      let totalSpend = 0;

      for (const o of activeOrders) {
        const cust = o.customerId ? customerMap.get(o.customerId) : null;
        const key = cust ? cust.id : "walk-in";
        const grand = Number(o.grandTotal || 0n);
        totalSpend += grand;

        const entry = agg.get(key) || {
          customerName: getCustomerDisplayName(cust),
          phone: cust?.phone || "—",
          email: cust?.email || "—",
          loyaltyPoints: cust?.loyaltyPoints || 0,
          ordersCount: 0,
          totalSpendMinor: 0,
          lastVisit: o.createdAt,
        };
        entry.ordersCount += 1;
        entry.totalSpendMinor += grand;
        if (o.createdAt > entry.lastVisit) entry.lastVisit = o.createdAt;
        agg.set(key, entry);
      }

      const sorted = Array.from(agg.values()).sort((a, b) => b.totalSpendMinor - a.totalSpendMinor);
      const rows = sorted.map((r) => ({
        customerName: r.customerName,
        phone: r.phone,
        email: r.email,
        ordersCount: r.ordersCount,
        avgOrder: Number((r.ordersCount > 0 ? r.totalSpendMinor / r.ordersCount / 100 : 0).toFixed(2)),
        totalSpend: Number((r.totalSpendMinor / 100).toFixed(2)),
        loyaltyPoints: r.loyaltyPoints,
        lastVisit: fmtDateTime(r.lastVisit),
      }));

      res.status(200).json(
        buildBase(
          "Customer Wise Sales Report",
          "Complete customer order frequency, total spend, and loyalty summary",
          [
            { label: "Customers", value: String(rows.length), tone: "info" },
            { label: "Total Orders", value: String(activeOrders.length) },
            { label: "Total Customer Spend", value: fmtMoney(totalSpend), tone: "success" },
          ],
          [
            { key: "customerName", label: "Customer Name" },
            { key: "phone", label: "Phone" },
            { key: "email", label: "Email" },
            { key: "ordersCount", label: "Orders", align: "right" },
            { key: "avgOrder", label: "Avg Spend (₹)", align: "right", isCurrency: true },
            { key: "totalSpend", label: "Total Spend (₹)", align: "right", isCurrency: true },
            { key: "loyaltyPoints", label: "Loyalty Pts", align: "right" },
            { key: "lastVisit", label: "Last Visit" },
          ],
          rows
        )
      );
      return;
    }

    // 10. Discount Wise Report
    if (reportKey === "discount-summary") {
      const discounted = activeOrders.filter((o) => Number(o.discountTotal || 0n) > 0);
      let totalDisc = 0;
      let totalSub = 0;

      const rows = discounted.map((o) => {
        const restName = outletMap.get(o.outletId)?.name || "Main Outlet";
        const cust = o.customerId ? customerMap.get(o.customerId) : null;
        const sub = Number(o.subtotal || 0n);
        const disc = Number(o.discountTotal || 0n);
        const grand = Number(o.grandTotal || 0n);
        totalDisc += disc;
        totalSub += sub;

        return {
          date: fmtDateTime(o.createdAt),
          restaurant: restName,
          orderNumber: o.orderNumber,
          orderType: o.orderType,
          customerName: getCustomerDisplayName(cust),
          subtotal: Number((sub / 100).toFixed(2)),
          discount: Number((disc / 100).toFixed(2)),
          discountPct: sub > 0 ? `${((disc / sub) * 100).toFixed(1)}%` : "0.0%",
          grandTotal: Number((grand / 100).toFixed(2)),
        };
      });

      res.status(200).json(
        buildBase(
          "Discount Wise Report: All Restaurants",
          "Summary of all discounted bills, discount totals, and impact on net sales",
          [
            { label: "Discounted Bills", value: String(rows.length), tone: "info" },
            { label: "Gross Subtotal", value: fmtMoney(totalSub) },
            { label: "Total Discount Given", value: fmtMoney(totalDisc), tone: "danger" },
            {
              label: "Avg Discount %",
              value: totalSub > 0 ? `${((totalDisc / totalSub) * 100).toFixed(1)}%` : "0.0%",
            },
          ],
          [
            { key: "date", label: "Date & Time" },
            { key: "restaurant", label: "Restaurant" },
            { key: "orderNumber", label: "Order #" },
            { key: "orderType", label: "Order Type" },
            { key: "customerName", label: "Customer" },
            { key: "subtotal", label: "Subtotal (₹)", align: "right", isCurrency: true },
            { key: "discount", label: "Discount (₹)", align: "right", isCurrency: true },
            { key: "discountPct", label: "Discount %", align: "right" },
            { key: "grandTotal", label: "Net Bill (₹)", align: "right", isCurrency: true },
          ],
          rows
        )
      );
      return;
    }

    // 11. Tax & GST Summary Report (CGST / SGST)
    if (reportKey === "tax-gst-summary") {
      const byDay = new Map<
        string,
        {
          day: string;
          restaurant: string;
          ordersCount: number;
          taxableMinor: number;
          taxMinor: number;
          grandMinor: number;
        }
      >();

      let totalTaxable = 0;
      let totalTax = 0;
      let totalGrand = 0;

      for (const o of activeOrders) {
        const day = fmtDateOnly(o.createdAt);
        const restName = outletMap.get(o.outletId)?.name || "Main Outlet";
        const key = `${day}::${o.outletId}`;
        const sub = Number(o.subtotal || 0n) - Number(o.discountTotal || 0n);
        const tax = Number(o.taxTotal || 0n);
        const grand = Number(o.grandTotal || 0n);

        const entry = byDay.get(key) || {
          day,
          restaurant: restName,
          ordersCount: 0,
          taxableMinor: 0,
          taxMinor: 0,
          grandMinor: 0,
        };
        entry.ordersCount += 1;
        entry.taxableMinor += sub;
        entry.taxMinor += tax;
        entry.grandMinor += grand;
        byDay.set(key, entry);

        totalTaxable += sub;
        totalTax += tax;
        totalGrand += grand;
      }

      const sorted = Array.from(byDay.values()).sort((a, b) => b.day.localeCompare(a.day));
      const rows = sorted.map((r) => ({
        day: r.day,
        restaurant: r.restaurant,
        ordersCount: r.ordersCount,
        taxableSales: Number((r.taxableMinor / 100).toFixed(2)),
        cgst: Number((r.taxMinor / 200).toFixed(2)),
        sgst: Number((r.taxMinor / 200).toFixed(2)),
        totalGst: Number((r.taxMinor / 100).toFixed(2)),
        grandTotal: Number((r.grandMinor / 100).toFixed(2)),
      }));

      res.status(200).json(
        buildBase(
          "Tax & GST Summary Report (CGST / SGST)",
          "Daily breakdown of taxable sales, CGST (2.5%), SGST (2.5%), and total GST collected",
          [
            { label: "Taxable Sales", value: fmtMoney(totalTaxable) },
            { label: "CGST (2.5%)", value: fmtMoney(Math.round(totalTax / 2)), tone: "info" },
            { label: "SGST (2.5%)", value: fmtMoney(Math.round(totalTax / 2)), tone: "info" },
            { label: "Total GST (5%)", value: fmtMoney(totalTax), tone: "success" },
            { label: "Total Billed", value: fmtMoney(totalGrand) },
          ],
          [
            { key: "day", label: "Date" },
            { key: "restaurant", label: "Restaurant" },
            { key: "ordersCount", label: "Bills", align: "right" },
            { key: "taxableSales", label: "Taxable Sales (₹)", align: "right", isCurrency: true },
            { key: "cgst", label: "CGST 2.5% (₹)", align: "right", isCurrency: true },
            { key: "sgst", label: "SGST 2.5% (₹)", align: "right", isCurrency: true },
            { key: "totalGst", label: "Total GST (₹)", align: "right", isCurrency: true },
            { key: "grandTotal", label: "Grand Total (₹)", align: "right", isCurrency: true },
          ],
          rows
        )
      );
      return;
    }

    // 12. Payment Mode & Settlement Report
    if (reportKey === "payment-mode-summary") {
      const agg = new Map<string, { method: string; restaurant: string; txCount: number; amountMinor: number }>();
      let grandCollected = 0;

      for (const p of payments) {
        if (p.status === "FAILED" || p.status === "REFUNDED") continue;
        const restName = outletMap.get(p.outletId)?.name || "Main Outlet";
        const method = p.method || "CASH";
        const key = `${p.outletId}::${method}`;
        const amt = Number(p.amount || 0n);

        const entry = agg.get(key) || { method, restaurant: restName, txCount: 0, amountMinor: 0 };
        entry.txCount += 1;
        entry.amountMinor += amt;
        agg.set(key, entry);
        grandCollected += amt;
      }

      const sorted = Array.from(agg.values()).sort((a, b) => b.amountMinor - a.amountMinor);
      const rows = sorted.map((r) => ({
        restaurant: r.restaurant,
        method: r.method,
        txCount: r.txCount,
        amount: Number((r.amountMinor / 100).toFixed(2)),
        sharePct: grandCollected > 0 ? `${((r.amountMinor / grandCollected) * 100).toFixed(1)}%` : "0.0%",
      }));

      res.status(200).json(
        buildBase(
          "Payment Mode & Settlement Report",
          "Collections split by Cash, Card, UPI/QR, Due, and Other payment methods",
          [
            { label: "Payment Modes", value: String(rows.length), tone: "info" },
            { label: "Total Transactions", value: String(rows.reduce((s, r) => s + Number(r.txCount), 0)) },
            { label: "Total Collected", value: fmtMoney(grandCollected), tone: "success" },
          ],
          [
            { key: "restaurant", label: "Restaurant" },
            { key: "method", label: "Payment Mode" },
            { key: "txCount", label: "Transactions", align: "right" },
            { key: "amount", label: "Amount Collected (₹)", align: "right", isCurrency: true },
            { key: "sharePct", label: "Share %", align: "right" },
          ],
          rows
        )
      );
      return;
    }

    res.status(404).json({ error: `Unknown report key: ${reportKey}` });
  } catch (err: any) {
    console.error("Error generating suite report:", err);
    res.status(500).json({ error: err.message || "Failed to generate report" });
  }
}
