import React, { useEffect, useState } from "react";
import Head from "next/head";
import Link from "next/link";
import { useRouter } from "next/router";
import { authedFetch, useAuthGuard } from "../lib/auth";
import Nav from "../components/Nav";

// Real response shapes from apps/api/src/routes/user-management.ts
interface UserRoleApi {
  roleId: string;
  roleName: string;
  outletId: string | null;
  outletName: string | null;
}

interface UserApi {
  id: string;
  email: string;
  firstName: string;
  lastName: string;
  phone: string | null;
  isActive: boolean;
  userRoles: UserRoleApi[];
}

interface RoleApi {
  id: string;
  name: string;
  description: string | null;
}

interface OutletApi {
  id: string;
  name: string;
}

interface PermissionApi {
  id: string;
  action: string;
  description: string | null;
}

// Reporting interfaces from apps/api/src/routes/reporting.ts
interface CustomerReportItem {
  customerId: string;
  name: string;
  phone: string;
  email: string;
  loyaltyPoints: number;
  totalSpendMinor: string;
  orderCount: number;
  averageOrderValueMinor: string;
  lastVisitAt: string;
  isActive: boolean;
}

interface ItemPerformanceReportItem {
  menuItemId: string;
  menuItemName: string;
  name: string;
  quantitySold: number;
  netSalesMinor: string;
}

interface StaffPerformanceReportItem {
  staffId: string;
  staffName: string;
  role?: string;
  orderCount: number;
  netSalesMinor: string;
  averageOrderValueMinor: string;
  cashTipMinor?: string;
  digitalTipMinor?: string;
  cashVarianceMinor?: string;
}

interface SalesSummaryReport {
  outletId: string;
  orderCount: number;
  netSalesMinor: string;
  averageOrderValueMinor: string;
}

interface PaymentBreakdownItem {
  method: string;
  count: number;
  amountMinor: string;
  percentage?: number;
}

interface TaxBreakdownItem {
  name: string;
  rate: number;
  taxableAmountMinor: string;
  taxCollectedMinor: string;
}

interface ChannelBreakdownItem {
  channel: string;
  orderCount: number;
  netSalesMinor: string;
}

export default function UserManagement() {
  // Allow all authenticated users; control mutations via canManageUsers
  const { me, loading: authLoading } = useAuthGuard();

  const canManageUsers = Boolean(
    me?.roles?.some((r) =>
      ["SUPER_ADMIN", "SUPERADMIN", "OWNER", "ADMIN", "OUTLET_MANAGER", "MANAGER"].includes(r.toUpperCase())
    ) || me?.permissions?.includes("users.manage")
  );

  const router = useRouter();

  // Tab State: "users" or "reports" (default to users)
  const [activeTab, setActiveTab] = useState<"users" | "reports">("users");

  useEffect(() => {
    if (router.query.tab === "reports") {
      setActiveTab("reports");
    } else if (router.query.tab === "users") {
      setActiveTab("users");
    }
  }, [router.query.tab]);

  // Users & Roles state
  const [users, setUsers] = useState<UserApi[]>([]);
  const [roles, setRoles] = useState<RoleApi[]>([]);
  const [outlets, setOutlets] = useState<OutletApi[]>([]);
  const [loading, setLoading] = useState(true);
  const [loadError, setLoadError] = useState<string | null>(null);
  const [actionError, setActionError] = useState<string | null>(null);
  const [actionNotice, setActionNotice] = useState<string | null>(null);

  // Role assignment state
  const [selectedRole, setSelectedRole] = useState<Record<string, string>>({});
  const [selectedOutlet, setSelectedOutlet] = useState<Record<string, string>>({});
  const [assigning, setAssigning] = useState<string | null>(null);
  const [revoking, setRevoking] = useState<string | null>(null);

  // Add/Edit User Modals
  const [showAddUserModal, setShowAddUserModal] = useState(false);
  const [newUserEmail, setNewUserEmail] = useState("");
  const [newUserPassword, setNewUserPassword] = useState("");
  const [newUserPin, setNewUserPin] = useState("");
  const [newUserFirstName, setNewUserFirstName] = useState("");
  const [newUserLastName, setNewUserLastName] = useState("");
  const [newUserPhone, setNewUserPhone] = useState("");
  const [newUserRoleId, setNewUserRoleId] = useState("");
  const [newUserOutletId, setNewUserOutletId] = useState("");
  const [createUserError, setCreateUserError] = useState<string | null>(null);
  const [creatingUser, setCreatingUser] = useState(false);

  const [showEditUserModal, setShowEditUserModal] = useState(false);
  const [editingUserId, setEditingUserId] = useState<string | null>(null);
  const [editUserEmail, setEditUserEmail] = useState("");
  const [editUserPassword, setEditUserPassword] = useState("");
  const [editUserPin, setEditUserPin] = useState("");
  const [editUserFirstName, setEditUserFirstName] = useState("");
  const [editUserLastName, setEditUserLastName] = useState("");
  const [editUserPhone, setEditUserPhone] = useState("");
  const [editUserIsActive, setEditUserIsActive] = useState(true);
  const [editUserError, setEditUserError] = useState<string | null>(null);
  const [editingUserSaving, setEditingUserSaving] = useState(false);
  const [deletingUserId, setDeletingUserId] = useState<string | null>(null);

  // Role Editor state
  const [permissions, setPermissions] = useState<PermissionApi[]>([]);
  const [showRoleEditor, setShowRoleEditor] = useState(false);
  const [editingRoleId, setEditingRoleId] = useState<string | null>(null);
  const [roleName, setRoleName] = useState("");
  const [roleDescription, setRoleDescription] = useState("");
  const [roleGrantedIds, setRoleGrantedIds] = useState<Set<string>>(new Set());
  const [roleSaving, setRoleSaving] = useState(false);
  const [roleError, setRoleError] = useState<string | null>(null);
  const [deletingRoleId, setDeletingRoleId] = useState<string | null>(null);

  // --- Reports & Analytics State ---
  const [reportDateRange, setReportDateRange] = useState<"today" | "7d" | "30d" | "all">("all");
  const [reportLoading, setReportLoading] = useState(false);
  const [reportError, setReportError] = useState<string | null>(null);

  const [customerReports, setCustomerReports] = useState<CustomerReportItem[]>([]);
  const [itemReports, setItemReports] = useState<ItemPerformanceReportItem[]>([]);
  const [staffReports, setStaffReports] = useState<StaffPerformanceReportItem[]>([]);
  const [salesSummary, setSalesSummary] = useState<SalesSummaryReport | null>(null);
  const [paymentReports, setPaymentReports] = useState<PaymentBreakdownItem[]>([]);
  const [taxReports, setTaxReports] = useState<TaxBreakdownItem[]>([]);
  const [channelReports, setChannelReports] = useState<ChannelBreakdownItem[]>([]);
  const [repeatRate, setRepeatRate] = useState<number>(0);

  // Search & Filter state for tables
  const [searchCustomer, setSearchCustomer] = useState("");
  const [searchItem, setSearchItem] = useState("");
  const [searchStaff, setSearchStaff] = useState("");

  // Detailed View Modal state
  const [viewModalData, setViewModalData] = useState<{
    title: string;
    subtitle?: string;
    details: { label: string; value: React.ReactNode }[];
  } | null>(null);

  // Helpers
  const formatInr = (minorAmountStr: string | number | undefined) => {
    if (!minorAmountStr) return "₹0.00";
    const minor = Number(minorAmountStr);
    if (isNaN(minor)) return "₹0.00";
    return `₹${(minor / 100).toLocaleString("en-IN", {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    })}`;
  };

  const formatDate = (isoStr?: string) => {
    if (!isoStr) return "—";
    try {
      return new Date(isoStr).toLocaleDateString("en-IN", {
        day: "2-digit",
        month: "short",
        year: "numeric",
        hour: "2-digit",
        minute: "2-digit",
      });
    } catch {
      return isoStr;
    }
  };

  // CSV Exporter helper
  const exportToCsv = (filename: string, headers: string[], rows: (string | number)[][]) => {
    const escapeCsv = (val: string | number) => {
      const str = String(val ?? "");
      if (str.includes(",") || str.includes('"') || str.includes("\n")) {
        return `"${str.replace(/"/g, '""')}"`;
      }
      return str;
    };

    const csvContent =
      "\uFEFF" +
      [headers.map(escapeCsv).join(","), ...rows.map((row) => row.map(escapeCsv).join(","))].join("\r\n");

    const blob = new Blob([csvContent], { type: "text/csv;charset=utf-8;" });
    const url = URL.createObjectURL(blob);
    const link = document.createElement("a");
    link.href = url;
    link.setAttribute("download", `${filename}_${new Date().toISOString().slice(0, 10)}.csv`);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    URL.revokeObjectURL(url);
  };

  // JSON Exporter helper
  const exportToJson = (filename: string, data: any) => {
    const jsonStr = JSON.stringify(data, null, 2);
    const blob = new Blob([jsonStr], { type: "application/json" });
    const url = URL.createObjectURL(blob);
    const link = document.createElement("a");
    link.href = url;
    link.setAttribute("download", `${filename}_${new Date().toISOString().slice(0, 10)}.json`);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    URL.revokeObjectURL(url);
  };

  // Master Export: Downloads consolidated master CSV
  const downloadMasterReport = () => {
    const headers = ["Category / Report", "Primary Identifier", "Key Metric 1", "Key Metric 2", "Key Metric 3", "Additional Details"];
    const rows: (string | number)[][] = [];

    // Summary
    rows.push(["Summary", "Outlet Overview", `Total Orders: ${salesSummary?.orderCount ?? 0}`, `Net Sales: ${formatInr(salesSummary?.netSalesMinor)}`, `AOV: ${formatInr(salesSummary?.averageOrderValueMinor)}`, `Customers: ${customerReports.length}`]);

    // Customers
    customerReports.forEach((c) => {
      rows.push(["Customer Sales", c.name, `Phone: ${c.phone}`, `Orders: ${c.orderCount}`, `Total Spend: ${formatInr(c.totalSpendMinor)}`, `AOV: ${formatInr(c.averageOrderValueMinor)} | Loyalty: ${c.loyaltyPoints}`]);
    });

    // Highly Sold Items
    itemReports.forEach((item, idx) => {
      rows.push(["Top Sold Item", `#${idx + 1} ${item.menuItemName || item.name}`, `Units Sold: ${item.quantitySold}`, `Revenue: ${formatInr(item.netSalesMinor)}`, `Avg Price: ${formatInr(item.quantitySold > 0 ? Number(item.netSalesMinor) / item.quantitySold : 0)}`, "Active Menu Item"]);
    });

    // Staff Performance
    staffReports.forEach((s) => {
      rows.push(["Staff Performance", s.staffName, `Orders: ${s.orderCount}`, `Sales: ${formatInr(s.netSalesMinor)}`, `AOV: ${formatInr(s.averageOrderValueMinor)}`, `Tips: ${formatInr((Number(s.cashTipMinor || 0) + Number(s.digitalTipMinor || 0)))}`]);
    });

    // Roles
    roles.forEach((r) => {
      const assignedCount = users.filter((u) => u.userRoles.some((ur) => ur.roleId === r.id)).length;
      rows.push(["Security Role", r.name, `Assigned Users: ${assignedCount}`, r.description || "System Role", "", ""]);
    });

    exportToCsv("KapMeta_Operations_Master_Report", headers, rows);
  };

  // Master JSON Export
  const downloadMasterJson = () => {
    const masterData = {
      exportedAt: new Date().toISOString(),
      salesSummary,
      customers: customerReports,
      highlySoldItems: itemReports,
      staffPerformance: staffReports,
      roles,
      users: users.map((u) => ({
        id: u.id,
        name: `${u.firstName} ${u.lastName}`,
        email: u.email,
        phone: u.phone,
        isActive: u.isActive,
        roles: u.userRoles.map((r) => r.roleName),
      })),
      paymentBreakdown: paymentReports,
      taxBreakdown: taxReports,
      channelBreakdown: channelReports,
    };
    exportToJson("KapMeta_Operations_Full_Data", masterData);
  };

  // Print Report
  const triggerPrint = () => {
    if (typeof window !== "undefined") {
      window.print();
    }
  };

  // Load Users, Roles, Outlets, Permissions
  const fetchData = () => {
    setLoading(true);
    setLoadError(null);
    Promise.all([
      authedFetch(`/users`).then((res) => {
        if (!res.ok) throw new Error("HTTP error " + res.status);
        return res.json() as Promise<UserApi[]>;
      }),
      authedFetch(`/roles`).then((res) => {
        if (!res.ok) throw new Error("HTTP error " + res.status);
        return res.json() as Promise<RoleApi[]>;
      }),
      authedFetch(`/permissions`).then((res) => {
        if (!res.ok) throw new Error("HTTP error " + res.status);
        return res.json() as Promise<PermissionApi[]>;
      }),
      authedFetch(`/outlets`).then((res) => {
        if (!res.ok) throw new Error("HTTP error " + res.status);
        return res.json() as Promise<OutletApi[]>;
      }),
    ])
      .then(([usersRes, rolesRes, permissionsRes, outletsRes]) => {
        setUsers(Array.isArray(usersRes) ? usersRes : []);
        setRoles(Array.isArray(rolesRes) ? rolesRes : []);
        setPermissions(Array.isArray(permissionsRes) ? permissionsRes : []);
        setOutlets(Array.isArray(outletsRes) ? outletsRes : []);
        setLoading(false);
      })
      .catch((err) => {
        setLoadError(err instanceof Error ? err.message : "Failed to load users");
        setLoading(false);
      });
  };

  // Load Reports Data
  const fetchReportsData = () => {
    setReportLoading(true);
    setReportError(null);

    let queryParams = "";
    const now = new Date();
    if (reportDateRange === "today") {
      const start = new Date(now.getFullYear(), now.getMonth(), now.getDate()).toISOString();
      const end = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 23, 59, 59, 999).toISOString();
      queryParams = `?fromDate=${start}&toDate=${end}`;
    } else if (reportDateRange === "7d") {
      const start = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString();
      queryParams = `?fromDate=${start}&toDate=${now.toISOString()}`;
    } else if (reportDateRange === "30d") {
      const start = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000).toISOString();
      queryParams = `?fromDate=${start}&toDate=${now.toISOString()}`;
    }

    Promise.all([
      authedFetch(`/reporting/customer-insights${queryParams}`).then((r) => r.ok ? r.json() : null),
      authedFetch(`/reporting/item-performance${queryParams}`).then((r) => r.ok ? r.json() : []),
      authedFetch(`/reporting/staff-performance${queryParams}`).then((r) => r.ok ? r.json() : null),
      authedFetch(`/reporting/sales-summary${queryParams}`).then((r) => r.ok ? r.json() : null),
      authedFetch(`/reporting/payment-breakdown${queryParams}`).then((r) => r.ok ? r.json() : null),
      authedFetch(`/reporting/tax-breakdown${queryParams}`).then((r) => r.ok ? r.json() : null),
      authedFetch(`/reporting/channel-breakdown${queryParams}`).then((r) => r.ok ? r.json() : null),
    ])
      .then(([custData, itemsData, staffData, summaryData, payData, taxData, chanData]) => {
        if (custData) {
          const list = custData.allCustomers || custData.topSpenders || [];
          setCustomerReports(list);
          setRepeatRate(custData.repeatCustomerRatePercent ?? 0);
        } else {
          setCustomerReports([]);
        }

        if (Array.isArray(itemsData)) {
          // Sort items by quantity sold descending
          const sortedItems = [...itemsData].sort((a, b) => (b.quantitySold || 0) - (a.quantitySold || 0));
          setItemReports(sortedItems);
        } else {
          setItemReports([]);
        }

        if (staffData && Array.isArray(staffData.staff)) {
          setStaffReports(staffData.staff);
        } else {
          setStaffReports([]);
        }

        if (summaryData) {
          setSalesSummary(summaryData);
        }

        if (payData && Array.isArray(payData.methods)) {
          setPaymentReports(payData.methods);
        }

        if (taxData && Array.isArray(taxData.components)) {
          setTaxReports(taxData.components);
        }

        if (chanData && Array.isArray(chanData.channels)) {
          setChannelReports(chanData.channels);
        }

        setReportLoading(false);
      })
      .catch((err) => {
        setReportError(err instanceof Error ? err.message : "Failed to load reports");
        setReportLoading(false);
      });
  };

  useEffect(() => {
    if (authLoading) return;
    fetchData();
    fetchReportsData();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [authLoading, reportDateRange]);

  // Handlers for User / Role Actions
  const handleCreateUser = async (e: React.FormEvent) => {
    e.preventDefault();
    setActionError(null);
    setCreateUserError(null);
    setCreatingUser(true);
    try {
      const res = await authedFetch(`/users`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          email: newUserEmail,
          password: newUserPassword,
          pin: newUserPin || null,
          firstName: newUserFirstName,
          lastName: newUserLastName,
          phone: newUserPhone || null,
          roleId: newUserRoleId || null,
          outletId: newUserOutletId || null,
        }),
      });
      if (!res.ok) {
        const body = await res.json().catch(() => ({}));
        throw new Error(body.error || "HTTP error " + res.status);
      }
      setShowAddUserModal(false);
      setNewUserEmail("");
      setNewUserPassword("");
      setNewUserPin("");
      setNewUserFirstName("");
      setNewUserLastName("");
      setNewUserPhone("");
      setNewUserRoleId("");
      setNewUserOutletId("");
      fetchData();
    } catch (err) {
      const msg = err instanceof Error ? err.message : "Failed to create user";
      setCreateUserError(msg);
      setActionError(msg);
    } finally {
      setCreatingUser(false);
    }
  };

  const handleUpdateUser = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!editingUserId) return;
    setActionError(null);
    setEditUserError(null);
    setEditingUserSaving(true);
    try {
      const payload: any = {
        email: editUserEmail,
        firstName: editUserFirstName,
        lastName: editUserLastName,
        phone: editUserPhone || null,
        isActive: editUserIsActive,
      };
      if (editUserPassword) payload.password = editUserPassword;
      if (editUserPin) payload.pin = editUserPin;

      const res = await authedFetch(`/users/${editingUserId}`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      });
      if (!res.ok) {
        const body = await res.json().catch(() => ({}));
        throw new Error(body.error || "HTTP error " + res.status);
      }
      setShowEditUserModal(false);
      setEditingUserId(null);
      fetchData();
    } catch (err) {
      const msg = err instanceof Error ? err.message : "Failed to update user";
      setEditUserError(msg);
      setActionError(msg);
    } finally {
      setEditingUserSaving(false);
    }
  };

  const handleDeleteUser = async (userId: string) => {
    if (!window.confirm("Are you sure you want to delete this staff account?")) return;
    setActionError(null);
    setActionNotice(null);
    setDeletingUserId(userId);
    try {
      const res = await authedFetch(`/users/${userId}`, {
        method: "DELETE",
      });
      if (!res.ok && res.status !== 204) {
        const body = await res.json().catch(() => ({}));
        throw new Error(body.error || "HTTP error " + res.status);
      }
      fetchData();
    } catch (err) {
      setActionError(err instanceof Error ? err.message : "Failed to delete user");
    } finally {
      setDeletingUserId(null);
    }
  };

  const assignRole = async (userId: string) => {
    const roleId = selectedRole[userId];
    if (!roleId) {
      setActionError("Pick a role before assigning.");
      return;
    }
    const outletId = selectedOutlet[userId] || null;

    setActionError(null);
    setAssigning(userId);
    try {
      const res = await authedFetch(`/users/${userId}/roles`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ roleId, outletId }),
      });
      if (!res.ok) {
        const body = await res.json().catch(() => ({}));
        throw new Error(body.error || "HTTP error " + body.error);
      }
      fetchData();
    } catch (err) {
      setActionError(err instanceof Error ? err.message : "Failed to assign role");
    } finally {
      setAssigning(null);
    }
  };

  const revokeRole = async (userId: string, roleId: string) => {
    setActionError(null);
    setRevoking(`${userId}:${roleId}`);
    try {
      const res = await authedFetch(`/users/${userId}/roles/${roleId}`, {
        method: "DELETE",
      });
      if (!res.ok && res.status !== 204) {
        const body = await res.json().catch(() => ({}));
        throw new Error(body.error || "HTTP error " + res.status);
      }
      fetchData();
    } catch (err) {
      setActionError(err instanceof Error ? err.message : "Failed to revoke role");
    } finally {
      setRevoking(null);
    }
  };

  const openCreateRole = () => {
    setEditingRoleId(null);
    setRoleName("");
    setRoleDescription("");
    setRoleGrantedIds(new Set());
    setRoleError(null);
    setShowRoleEditor(true);
  };

  const openEditRole = async (role: RoleApi) => {
    setEditingRoleId(role.id);
    setRoleName(role.name);
    setRoleDescription(role.description ?? "");
    setRoleError(null);
    setShowRoleEditor(true);
    try {
      const res = await authedFetch(`/roles/${role.id}/permissions`);
      if (!res.ok) throw new Error("HTTP error " + res.status);
      const body = (await res.json()) as { permissionIds: string[] };
      setRoleGrantedIds(new Set(body.permissionIds));
    } catch (err) {
      setRoleError(err instanceof Error ? err.message : "Failed to load role permissions");
      setRoleGrantedIds(new Set());
    }
  };

  const togglePermission = (permissionId: string) => {
    setRoleGrantedIds((prev) => {
      const next = new Set(prev);
      if (next.has(permissionId)) next.delete(permissionId);
      else next.add(permissionId);
      return next;
    });
  };

  const saveRole = async () => {
    if (!roleName.trim()) {
      setRoleError("Role name is required.");
      return;
    }
    setRoleSaving(true);
    setRoleError(null);
    try {
      let roleId = editingRoleId;
      if (roleId) {
        const res = await authedFetch(`/roles/${roleId}`, {
          method: "PATCH",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ name: roleName.trim(), description: roleDescription || null }),
        });
        if (!res.ok) {
          const body = await res.json().catch(() => ({}));
          throw new Error(body.error || "HTTP error " + res.status);
        }
      } else {
        const res = await authedFetch(`/roles`, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ name: roleName.trim(), description: roleDescription || null }),
        });
        if (!res.ok) {
          const body = await res.json().catch(() => ({}));
          throw new Error(body.error || "HTTP error " + res.status);
        }
        const created = (await res.json()) as RoleApi;
        roleId = created.id;
      }

      const permRes = await authedFetch(`/roles/${roleId}/permissions`, {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ permissionIds: Array.from(roleGrantedIds) }),
      });
      if (!permRes.ok) {
        const body = await permRes.json().catch(() => ({}));
        throw new Error(body.error || "Role saved but failed to update permissions");
      }

      setShowRoleEditor(false);
      fetchData();
    } catch (err) {
      setRoleError(err instanceof Error ? err.message : "Failed to save role");
    } finally {
      setRoleSaving(false);
    }
  };

  const deleteRole = async (roleId: string) => {
    if (!window.confirm("Are you sure you want to delete this role?")) return;
    setActionError(null);
    setDeletingRoleId(roleId);
    try {
      const res = await authedFetch(`/roles/${roleId}`, { method: "DELETE" });
      if (!res.ok && res.status !== 204) {
        const body = await res.json().catch(() => ({}));
        throw new Error(body.error || "HTTP error " + res.status);
      }
      fetchData();
    } catch (err) {
      setActionError(err instanceof Error ? err.message : "Failed to delete role");
    } finally {
      setDeletingRoleId(null);
    }
  };

  const initials = me?.name
    ? me.name
        .split(" ")
        .map((p) => p.charAt(0))
        .slice(0, 2)
        .join("")
        .toUpperCase()
    : "KM";

  // Filtered reports
  const filteredCustomers = customerReports.filter(
    (c) =>
      c.name.toLowerCase().includes(searchCustomer.toLowerCase()) ||
      c.phone.includes(searchCustomer) ||
      c.email.toLowerCase().includes(searchCustomer.toLowerCase())
  );

  const filteredItems = itemReports.filter(
    (i) =>
      (i.menuItemName || i.name || "").toLowerCase().includes(searchItem.toLowerCase())
  );

  const filteredStaff = staffReports.filter(
    (s) => (s.staffName || "").toLowerCase().includes(searchStaff.toLowerCase())
  );

  const topSellingDish = itemReports.length > 0 ? itemReports[0] : null;

  return (
    <div className="admin-app">
      <Head>
        <title>KapMeta POS - Roles, Users & Operations Reports</title>
        <meta
          name="description"
          content="Unified user role management and complete granular operational analytics for sales, customers, and menu performance."
        />
      </Head>

      <div style={{ display: "flex", flex: 1, minHeight: 0 }}>
        <Nav variant="sidebar" />
        <div style={{ flex: 1, display: "flex", flexDirection: "column", minWidth: 0, overflowY: "auto" }}>
          <header className="topbar">
            <div className="topbar-left">
              <div className="brand-badge">
                <span className="brand-icon">⚡</span>
                <span className="brand-name">KapMeta Enterprise Gateway</span>
              </div>
            </div>

            <div className="topbar-right">
              {!canManageUsers && (
                <div className="view-mode-tag">
                  👁️ Staff View &amp; Reporting Mode
                </div>
              )}
              <div className="user-profile-badge">
                <div className="avatar-circle">{initials}</div>
                <div className="user-info-text">
                  <span className="user-name">{me?.name ?? "Staff Member"}</span>
                  <span className="user-role">{me?.roles?.[0] ?? "Team"}</span>
                </div>
              </div>
            </div>
          </header>

          <main className="dashboard-body">
            {authLoading && (
              <div className="empty-state-card">
                <span className="empty-icon">⏳</span>
                <h3>Loading access profile...</h3>
              </div>
            )}

            {!authLoading && (
              <>
                {/* Header Greeting & Tab Switcher */}
                <section className="dashboard-greeting-row">
                  <div>
                    <span className="breadcrumb-line">Management &gt; User Management</span>
                    <h1 className="greeting-title">Staff &amp; User Accounts Management</h1>
                    <p className="greeting-subtitle">
                      Manage staff profiles, assign outlet roles, configure 4-digit PINs, and audit operational activity.
                    </p>
                  </div>

                  {/* Master Export & Actions */}
                  <div className="action-buttons-group">
                    <button className="export-action-btn primary" onClick={downloadMasterReport}>
                      📥 Master Report (CSV)
                    </button>
                    <button className="export-action-btn" onClick={downloadMasterJson}>
                      📦 Export JSON
                    </button>
                    <button className="export-action-btn" onClick={triggerPrint}>
                      🖨️ Print / PDF
                    </button>
                    <Link
                      href="/role-management"
                      className="export-action-btn"
                      style={{
                        textDecoration: "none",
                        display: "inline-flex",
                        alignItems: "center",
                        gap: "6px",
                        background: "#4f46e5",
                        borderColor: "#6366f1",
                        color: "#ffffff",
                      }}
                    >
                      🛡️ Role Management →
                    </Link>
                  </div>
                </section>

                {/* Primary Tab Navigation */}
                <div className="tabs-header-container">
                  <button
                    className={`tab-item-btn ${activeTab === "users" ? "active" : ""}`}
                    onClick={() => setActiveTab("users")}
                  >
                    🧑‍💼 Staff &amp; User Accounts
                    <span className="tab-pill">{users.length}</span>
                  </button>
                  <Link
                    href="/role-management"
                    className="tab-item-btn"
                    style={{ textDecoration: "none" }}
                  >
                    🛡️ RBAC Roles &amp; Permissions
                    <span className="tab-pill">{roles.length}</span>
                  </Link>
                  <button
                    className={`tab-item-btn ${activeTab === "reports" ? "active" : ""}`}
                    onClick={() => setActiveTab("reports")}
                  >
                    📊 Complete Operations Reports &amp; Analytics
                    <span className="tab-pill">Live</span>
                  </button>
                </div>

                {/* Notifications & Banners */}
                {actionError && (
                  <div className="empty-state-card error-card">
                    <span className="empty-icon">⚠️</span>
                    <p>{actionError}</p>
                  </div>
                )}
                {actionNotice && (
                  <div className="empty-state-card notice-card">
                    <span className="empty-icon">ℹ️</span>
                    <p>{actionNotice}</p>
                  </div>
                )}

                {/* ========================================================================= */}
                {/* TAB 1: COMPLETE OPERATIONS REPORTS & ANALYTICS                            */}
                {/* ========================================================================= */}
                {activeTab === "reports" && (
                  <div className="reports-section-wrapper">
                    {/* Filter & Date Presets Bar */}
                    <div className="report-controls-bar">
                      <div className="date-presets-group">
                        <span className="controls-label">Timeframe:</span>
                        <button
                          className={`preset-btn ${reportDateRange === "today" ? "active" : ""}`}
                          onClick={() => setReportDateRange("today")}
                        >
                          Today
                        </button>
                        <button
                          className={`preset-btn ${reportDateRange === "7d" ? "active" : ""}`}
                          onClick={() => setReportDateRange("7d")}
                        >
                          Last 7 Days
                        </button>
                        <button
                          className={`preset-btn ${reportDateRange === "30d" ? "active" : ""}`}
                          onClick={() => setReportDateRange("30d")}
                        >
                          This Month
                        </button>
                        <button
                          className={`preset-btn ${reportDateRange === "all" ? "active" : ""}`}
                          onClick={() => setReportDateRange("all")}
                        >
                          All Records
                        </button>
                      </div>

                      <div style={{ display: "flex", gap: "10px", alignItems: "center" }}>
                        <button
                          className="refresh-btn"
                          disabled={reportLoading}
                          onClick={fetchReportsData}
                        >
                          🔄 {reportLoading ? "Syncing..." : "Refresh Live Data"}
                        </button>
                      </div>
                    </div>

                    {/* Operational KPI Metric Strip */}
                    <div className="kpi-grid">
                      <div className="kpi-card">
                        <span className="kpi-icon">💰</span>
                        <div className="kpi-content">
                          <span className="kpi-label">Total Net Sales</span>
                          <span className="kpi-value">{formatInr(salesSummary?.netSalesMinor)}</span>
                          <span className="kpi-sub">{salesSummary?.orderCount ?? 0} confirmed orders</span>
                        </div>
                      </div>

                      <div className="kpi-card">
                        <span className="kpi-icon">👥</span>
                        <div className="kpi-content">
                          <span className="kpi-label">Registered Customers</span>
                          <span className="kpi-value">{customerReports.length}</span>
                          <span className="kpi-sub">Repeat Rate: {repeatRate.toFixed(1)}%</span>
                        </div>
                      </div>

                      <div className="kpi-card highlight">
                        <span className="kpi-icon">🔥</span>
                        <div className="kpi-content">
                          <span className="kpi-label">Highest Selling Dish</span>
                          <span className="kpi-value">
                            {topSellingDish ? topSellingDish.menuItemName || topSellingDish.name : "N/A"}
                          </span>
                          <span className="kpi-sub">
                            {topSellingDish ? `${topSellingDish.quantitySold} units sold (${formatInr(topSellingDish.netSalesMinor)})` : "No sales"}
                          </span>
                        </div>
                      </div>

                      <div className="kpi-card">
                        <span className="kpi-icon">📈</span>
                        <div className="kpi-content">
                          <span className="kpi-label">Average Order Value</span>
                          <span className="kpi-value">{formatInr(salesSummary?.averageOrderValueMinor)}</span>
                          <span className="kpi-sub">Across all sales channels</span>
                        </div>
                      </div>

                      <div className="kpi-card">
                        <span className="kpi-icon">🧑‍🍳</span>
                        <div className="kpi-content">
                          <span className="kpi-label">Active Staff Members</span>
                          <span className="kpi-value">{users.filter((u) => u.isActive).length}</span>
                          <span className="kpi-sub">{roles.length} security roles</span>
                        </div>
                      </div>
                    </div>

                    {/* ================================================================ */}
                    {/* REPORT 1: CUSTOMER SALES REPORT                                  */}
                    {/* ================================================================ */}
                    <section className="panel-card report-panel">
                      <div className="panel-header">
                        <div>
                          <div style={{ display: "flex", alignItems: "center", gap: "8px" }}>
                            <span className="panel-title-icon">👥</span>
                            <h3>Customer Sales &amp; Lifetime Value Report</h3>
                          </div>
                          <p className="panel-sub">
                            Itemized record of each customer, order frequency, total spend volume, and loyalty profile.
                          </p>
                        </div>
                        <div className="panel-actions">
                          <input
                            type="text"
                            placeholder="🔍 Filter customer / phone..."
                            className="search-input"
                            value={searchCustomer}
                            onChange={(e) => setSearchCustomer(e.target.value)}
                          />
                          <button
                            className="btn-download csv"
                            onClick={() =>
                              exportToCsv(
                                "Customer_Sales_Report",
                                ["Customer ID", "Customer Name", "Phone", "Email", "Total Orders", "Total Spend (INR)", "Average Order Value (INR)", "Loyalty Points", "Last Visit"],
                                customerReports.map((c) => [
                                  c.customerId,
                                  c.name,
                                  c.phone,
                                  c.email,
                                  c.orderCount,
                                  (Number(c.totalSpendMinor) / 100).toFixed(2),
                                  (Number(c.averageOrderValueMinor) / 100).toFixed(2),
                                  c.loyaltyPoints,
                                  formatDate(c.lastVisitAt),
                                ])
                              )
                            }
                          >
                            📥 Download CSV
                          </button>
                          <button
                            className="btn-download json"
                            onClick={() => exportToJson("Customer_Sales_Report", customerReports)}
                          >
                            📦 Download JSON
                          </button>
                        </div>
                      </div>

                      <div className="table-responsive">
                        <table className="clean-table">
                          <thead>
                            <tr>
                              <th>Customer Name</th>
                              <th>Contact Phone</th>
                              <th>Email</th>
                              <th>Orders</th>
                              <th>Total Spend</th>
                              <th>Avg Order Value</th>
                              <th>Loyalty Pts</th>
                              <th>Last Visit</th>
                              <th style={{ textAlign: "right" }}>View / Download</th>
                            </tr>
                          </thead>
                          <tbody>
                            {filteredCustomers.length === 0 ? (
                              <tr>
                                <td colSpan={9} style={{ textAlign: "center", padding: "24px", color: "var(--text-muted)" }}>
                                  No customer records match search query.
                                </td>
                              </tr>
                            ) : (
                              filteredCustomers.map((c) => (
                                <tr key={c.customerId}>
                                  <td>
                                    <strong>{c.name}</strong>
                                    {c.orderCount > 1 && <span className="repeat-badge">Repeat Customer</span>}
                                  </td>
                                  <td>{c.phone}</td>
                                  <td>{c.email}</td>
                                  <td><span className="counter-pill">{c.orderCount}</span></td>
                                  <td className="highlight-amount">{formatInr(c.totalSpendMinor)}</td>
                                  <td>{formatInr(c.averageOrderValueMinor)}</td>
                                  <td><span className="loyalty-pill">⭐ {c.loyaltyPoints}</span></td>
                                  <td>{formatDate(c.lastVisitAt)}</td>
                                  <td style={{ textAlign: "right" }}>
                                    <div style={{ display: "inline-flex", gap: "6px" }}>
                                      <button
                                        className="btn-table-action view"
                                        onClick={() =>
                                          setViewModalData({
                                            title: `Customer Dossier: ${c.name}`,
                                            subtitle: `Customer ID: ${c.customerId}`,
                                            details: [
                                              { label: "Full Name", value: c.name },
                                              { label: "Phone Number", value: c.phone },
                                              { label: "Email Address", value: c.email },
                                              { label: "Account Status", value: c.isActive ? "🟢 Active" : "🔴 Inactive" },
                                              { label: "Total Orders Completed", value: `${c.orderCount} orders` },
                                              { label: "Total Lifetime Spend", value: formatInr(c.totalSpendMinor) },
                                              { label: "Average Order Value (AOV)", value: formatInr(c.averageOrderValueMinor) },
                                              { label: "Loyalty Points Balance", value: `${c.loyaltyPoints} points` },
                                              { label: "Last Interaction / Visit", value: formatDate(c.lastVisitAt) },
                                            ],
                                          })
                                        }
                                      >
                                        👁️ View
                                      </button>
                                      <button
                                        className="btn-table-action dl"
                                        title="Download Customer Record (JSON)"
                                        onClick={() => exportToJson(`Customer_${c.name.replace(/\s+/g, "_")}`, c)}
                                      >
                                        📥
                                      </button>
                                    </div>
                                  </td>
                                </tr>
                              ))
                            )}
                          </tbody>
                        </table>
                      </div>
                    </section>

                    {/* ================================================================ */}
                    {/* REPORT 2: HIGHLY SOLD ITEMS (MENU ITEM PERFORMANCE)              */}
                    {/* ================================================================ */}
                    <section className="panel-card report-panel">
                      <div className="panel-header">
                        <div>
                          <div style={{ display: "flex", alignItems: "center", gap: "8px" }}>
                            <span className="panel-title-icon">🔥</span>
                            <h3>Highly Sold Items &amp; Menu Velocity Report</h3>
                          </div>
                          <p className="panel-sub">
                            Ranked menu performance by units sold, net sales contribution, and velocity ranking.
                          </p>
                        </div>
                        <div className="panel-actions">
                          <input
                            type="text"
                            placeholder="🔍 Filter dish name..."
                            className="search-input"
                            value={searchItem}
                            onChange={(e) => setSearchItem(e.target.value)}
                          />
                          <button
                            className="btn-download csv"
                            onClick={() =>
                              exportToCsv(
                                "Top_Selling_Items_Report",
                                ["Rank", "Item ID", "Item Name", "Quantity Sold", "Total Net Sales (INR)", "Average Price (INR)"],
                                itemReports.map((item, idx) => [
                                  idx + 1,
                                  item.menuItemId,
                                  item.menuItemName || item.name,
                                  item.quantitySold,
                                  (Number(item.netSalesMinor) / 100).toFixed(2),
                                  item.quantitySold > 0 ? (Number(item.netSalesMinor) / item.quantitySold / 100).toFixed(2) : "0.00",
                                ])
                              )
                            }
                          >
                            📥 Download CSV
                          </button>
                          <button
                            className="btn-download json"
                            onClick={() => exportToJson("Top_Selling_Items_Report", itemReports)}
                          >
                            📦 Download JSON
                          </button>
                        </div>
                      </div>

                      <div className="table-responsive">
                        <table className="clean-table">
                          <thead>
                            <tr>
                              <th style={{ width: "60px" }}>Rank</th>
                              <th>Menu Item / Dish</th>
                              <th>Units Sold</th>
                              <th>Total Net Sales</th>
                              <th>Average Unit Price</th>
                              <th>Sales Velocity</th>
                              <th style={{ textAlign: "right" }}>View / Download</th>
                            </tr>
                          </thead>
                          <tbody>
                            {filteredItems.length === 0 ? (
                              <tr>
                                <td colSpan={7} style={{ textAlign: "center", padding: "24px", color: "var(--text-muted)" }}>
                                  No menu sales recorded for the selected timeframe.
                                </td>
                              </tr>
                            ) : (
                              filteredItems.map((item, idx) => {
                                const avgPrice = item.quantitySold > 0 ? Number(item.netSalesMinor) / item.quantitySold : 0;
                                const isHot = idx < 3 && item.quantitySold > 10;
                                return (
                                  <tr key={item.menuItemId}>
                                    <td>
                                      <span className={`rank-badge ${idx === 0 ? "gold" : idx === 1 ? "silver" : idx === 2 ? "bronze" : ""}`}>
                                        #{idx + 1}
                                      </span>
                                    </td>
                                    <td>
                                      <strong>{item.menuItemName || item.name}</strong>
                                    </td>
                                    <td>
                                      <span className="counter-pill bold">{item.quantitySold} units</span>
                                    </td>
                                    <td className="highlight-amount">{formatInr(item.netSalesMinor)}</td>
                                    <td>{formatInr(avgPrice)}</td>
                                    <td>
                                      {isHot ? (
                                        <span className="velocity-tag hot">🔥 High Velocity</span>
                                      ) : (
                                        <span className="velocity-tag normal">⚡ Regular</span>
                                      )}
                                    </td>
                                    <td style={{ textAlign: "right" }}>
                                      <div style={{ display: "inline-flex", gap: "6px" }}>
                                        <button
                                          className="btn-table-action view"
                                          onClick={() =>
                                            setViewModalData({
                                              title: `Dish Analytics: ${item.menuItemName || item.name}`,
                                              subtitle: `Item ID: ${item.menuItemId}`,
                                              details: [
                                                { label: "Dish Name", value: item.menuItemName || item.name },
                                                { label: "Sales Rank", value: `#${idx + 1} in Outlet` },
                                                { label: "Total Units Sold", value: `${item.quantitySold} plates / portions` },
                                                { label: "Total Net Revenue Generated", value: formatInr(item.netSalesMinor) },
                                                { label: "Calculated Average Price", value: formatInr(avgPrice) },
                                                { label: "Contribution Classification", value: isHot ? "Core Star Item (High Demand)" : "Standard Item" },
                                              ],
                                            })
                                          }
                                        >
                                          👁️ View
                                        </button>
                                        <button
                                          className="btn-table-action dl"
                                          title="Download Dish Record"
                                          onClick={() => exportToJson(`Dish_${(item.menuItemName || item.name).replace(/\s+/g, "_")}`, item)}
                                        >
                                          📥
                                        </button>
                                      </div>
                                    </td>
                                  </tr>
                                );
                              })
                            )}
                          </tbody>
                        </table>
                      </div>
                    </section>

                    {/* ================================================================ */}
                    {/* REPORT 3: STAFF SALES & USER PERFORMANCE                         */}
                    {/* ================================================================ */}
                    <section className="panel-card report-panel">
                      <div className="panel-header">
                        <div>
                          <div style={{ display: "flex", alignItems: "center", gap: "8px" }}>
                            <span className="panel-title-icon">🧑‍🍳</span>
                            <h3>Staff &amp; User Sales Performance Report</h3>
                          </div>
                          <p className="panel-sub">
                            Waiters, cashiers, and managers performance breakdown: Orders taken, sales volume, tips, and variances.
                          </p>
                        </div>
                        <div className="panel-actions">
                          <input
                            type="text"
                            placeholder="🔍 Filter staff name..."
                            className="search-input"
                            value={searchStaff}
                            onChange={(e) => setSearchStaff(e.target.value)}
                          />
                          <button
                            className="btn-download csv"
                            onClick={() =>
                              exportToCsv(
                                "Staff_Performance_Report",
                                ["Staff ID", "Staff Name", "Orders Handled", "Net Sales (INR)", "Average Order Value (INR)", "Cash Tips (INR)", "Digital Tips (INR)", "Cash Variance (INR)"],
                                staffReports.map((s) => [
                                  s.staffId,
                                  s.staffName,
                                  s.orderCount,
                                  (Number(s.netSalesMinor) / 100).toFixed(2),
                                  (Number(s.averageOrderValueMinor) / 100).toFixed(2),
                                  s.cashTipMinor ? (Number(s.cashTipMinor) / 100).toFixed(2) : "0.00",
                                  s.digitalTipMinor ? (Number(s.digitalTipMinor) / 100).toFixed(2) : "0.00",
                                  s.cashVarianceMinor ? (Number(s.cashVarianceMinor) / 100).toFixed(2) : "0.00",
                                ])
                              )
                            }
                          >
                            📥 Download CSV
                          </button>
                          <button
                            className="btn-download json"
                            onClick={() => exportToJson("Staff_Performance_Report", staffReports)}
                          >
                            📦 Download JSON
                          </button>
                        </div>
                      </div>

                      <div className="table-responsive">
                        <table className="clean-table">
                          <thead>
                            <tr>
                              <th>Staff Member</th>
                              <th>Role</th>
                              <th>Orders Handled</th>
                              <th>Net Sales Generated</th>
                              <th>Avg Order Value</th>
                              <th>Tips Collected</th>
                              <th>Cash Variance</th>
                              <th style={{ textAlign: "right" }}>View / Download</th>
                            </tr>
                          </thead>
                          <tbody>
                            {filteredStaff.length === 0 ? (
                              <tr>
                                <td colSpan={8} style={{ textAlign: "center", padding: "24px", color: "var(--text-muted)" }}>
                                  No staff activity logged in this period.
                                </td>
                              </tr>
                            ) : (
                              filteredStaff.map((s) => {
                                const totalTip = Number(s.cashTipMinor || 0) + Number(s.digitalTipMinor || 0);
                                return (
                                  <tr key={s.staffId}>
                                    <td>
                                      <strong>{s.staffName}</strong>
                                    </td>
                                    <td>
                                      <span className="role-tag">{s.role || "Floor Staff"}</span>
                                    </td>
                                    <td><span className="counter-pill">{s.orderCount}</span></td>
                                    <td className="highlight-amount">{formatInr(s.netSalesMinor)}</td>
                                    <td>{formatInr(s.averageOrderValueMinor)}</td>
                                    <td>{formatInr(totalTip)}</td>
                                    <td>
                                      {s.cashVarianceMinor && Number(s.cashVarianceMinor) !== 0 ? (
                                        <span className="variance-tag warning">{formatInr(s.cashVarianceMinor)}</span>
                                      ) : (
                                        <span className="variance-tag zero">₹0.00</span>
                                      )}
                                    </td>
                                    <td style={{ textAlign: "right" }}>
                                      <div style={{ display: "inline-flex", gap: "6px" }}>
                                        <button
                                          className="btn-table-action view"
                                          onClick={() =>
                                            setViewModalData({
                                              title: `Staff Audit: ${s.staffName}`,
                                              subtitle: `Staff ID: ${s.staffId}`,
                                              details: [
                                                { label: "Staff Name", value: s.staffName },
                                                { label: "Designated Role", value: s.role || "Staff" },
                                                { label: "Total Orders Closed", value: `${s.orderCount} orders` },
                                                { label: "Gross Volume Collected", value: formatInr(s.netSalesMinor) },
                                                { label: "Average Order Value (AOV)", value: formatInr(s.averageOrderValueMinor) },
                                                { label: "Cash Tips Collected", value: formatInr(s.cashTipMinor) },
                                                { label: "Digital Tips Received", value: formatInr(s.digitalTipMinor) },
                                                { label: "Till Cash Variance", value: formatInr(s.cashVarianceMinor) },
                                              ],
                                            })
                                          }
                                        >
                                          👁️ View
                                        </button>
                                        <button
                                          className="btn-table-action dl"
                                          title="Download Staff Record"
                                          onClick={() => exportToJson(`Staff_${s.staffName.replace(/\s+/g, "_")}`, s)}
                                        >
                                          📥
                                        </button>
                                      </div>
                                    </td>
                                  </tr>
                                );
                              })
                            )}
                          </tbody>
                        </table>
                      </div>
                    </section>

                    {/* ================================================================ */}
                    {/* REPORT 4: PAYMENTS, TAXES & CHANNELS BREAKDOWN                    */}
                    {/* ================================================================ */}
                    <div className="split-grid-row">
                      {/* Payment Breakdown */}
                      <section className="panel-card report-panel half">
                        <div className="panel-header">
                          <div>
                            <h3>Payment Methods Breakdown</h3>
                            <p className="panel-sub">Volume by Cash, UPI, Card, and Aggregator</p>
                          </div>
                          <div className="panel-actions">
                            <button
                              className="btn-download csv"
                              onClick={() =>
                                exportToCsv(
                                  "Payment_Breakdown",
                                  ["Payment Method", "Transaction Count", "Amount (INR)"],
                                  paymentReports.map((p) => [p.method, p.count, (Number(p.amountMinor) / 100).toFixed(2)])
                                )
                              }
                            >
                              CSV
                            </button>
                          </div>
                        </div>

                        <div className="table-responsive">
                          <table className="clean-table">
                            <thead>
                              <tr>
                                <th>Method</th>
                                <th>Count</th>
                                <th>Total Collected</th>
                              </tr>
                            </thead>
                            <tbody>
                              {paymentReports.length === 0 ? (
                                <tr>
                                  <td colSpan={3} style={{ textAlign: "center", color: "var(--text-muted)" }}>
                                    No settled payment records.
                                  </td>
                                </tr>
                              ) : (
                                paymentReports.map((p) => (
                                  <tr key={p.method}>
                                    <td><strong>{p.method}</strong></td>
                                    <td><span className="counter-pill">{p.count}</span></td>
                                    <td className="highlight-amount">{formatInr(p.amountMinor)}</td>
                                  </tr>
                                ))
                              )}
                            </tbody>
                          </table>
                        </div>
                      </section>

                      {/* Tax Breakdown */}
                      <section className="panel-card report-panel half">
                        <div className="panel-header">
                          <div>
                            <h3>Tax &amp; Compliance Breakdown</h3>
                            <p className="panel-sub">CGST, SGST, and Service Charge audit</p>
                          </div>
                          <div className="panel-actions">
                            <button
                              className="btn-download csv"
                              onClick={() =>
                                exportToCsv(
                                  "Tax_Breakdown",
                                  ["Component", "Tax Rate (%)", "Taxable Amount (INR)", "Tax Collected (INR)"],
                                  taxReports.map((t) => [
                                    t.name,
                                    t.rate,
                                    (Number(t.taxableAmountMinor) / 100).toFixed(2),
                                    (Number(t.taxCollectedMinor) / 100).toFixed(2),
                                  ])
                                )
                              }
                            >
                              CSV
                            </button>
                          </div>
                        </div>

                        <div className="table-responsive">
                          <table className="clean-table">
                            <thead>
                              <tr>
                                <th>Tax Component</th>
                                <th>Rate</th>
                                <th>Taxable Amount</th>
                                <th>Tax Collected</th>
                              </tr>
                            </thead>
                            <tbody>
                              {taxReports.length === 0 ? (
                                <tr>
                                  <td colSpan={4} style={{ textAlign: "center", color: "var(--text-muted)" }}>
                                    No tax transactions recorded.
                                  </td>
                                </tr>
                              ) : (
                                taxReports.map((t) => (
                                  <tr key={t.name}>
                                    <td><strong>{t.name}</strong></td>
                                    <td>{t.rate}%</td>
                                    <td>{formatInr(t.taxableAmountMinor)}</td>
                                    <td className="highlight-amount">{formatInr(t.taxCollectedMinor)}</td>
                                  </tr>
                                ))
                              )}
                            </tbody>
                          </table>
                        </div>
                      </section>
                    </div>
                  </div>
                )}

                {/* ========================================================================= */}
                {/* TAB 2: STAFF ACCOUNTS & ROLE SECURITY MANAGEMENT                          */}
                {/* ========================================================================= */}
                {activeTab === "users" && (
                  <div className="users-section-wrapper">
                    {loading && (
                      <div className="empty-state-card">
                        <span className="empty-icon">⏳</span>
                        <h3>Loading users and security matrix...</h3>
                      </div>
                    )}

                    {!loading && loadError && (
                      <div className="empty-state-card error-card">
                        <span className="empty-icon">⚠️</span>
                        <h3>Could not load user accounts</h3>
                        <p>{loadError}</p>
                      </div>
                    )}

                    {!loading && !loadError && (
                      <>
                        {/* Users Table */}
                        <section className="panel-card invoices-table-card">
                          <div className="panel-header">
                            <div>
                              <h3>Staff Accounts Directory</h3>
                              <p className="panel-sub">Real database staff records with outlet and role assignments</p>
                              {!canManageUsers && (
                                <div
                                  style={{
                                    background: "rgba(59, 130, 246, 0.12)",
                                    border: "1px solid rgba(59, 130, 246, 0.3)",
                                    borderRadius: "6px",
                                    padding: "6px 12px",
                                    marginTop: "6px",
                                    fontSize: "0.82rem",
                                    color: "#93c5fd",
                                    display: "inline-flex",
                                    alignItems: "center",
                                    gap: "6px",
                                  }}
                                >
                                  <span>🔒</span>
                                  <span>
                                    <strong>Read-Only Mode:</strong> Adding staff requires Administrator privileges. Sign in as <strong>admin@hotelkapila.com</strong> to add or edit accounts.
                                  </span>
                                </div>
                              )}
                            </div>
                            <div className="panel-actions">
                              <button
                                className="btn-download csv"
                                onClick={() =>
                                  exportToCsv(
                                    "Staff_Accounts_Directory",
                                    ["User ID", "First Name", "Last Name", "Email", "Phone", "Status", "Assigned Roles"],
                                    users.map((u) => [
                                      u.id,
                                      u.firstName,
                                      u.lastName,
                                      u.email,
                                      u.phone || "",
                                      u.isActive ? "Active" : "Inactive",
                                      u.userRoles.map((r) => r.roleName).join("; "),
                                    ])
                                  )
                                }
                              >
                                📥 Download Users CSV
                              </button>
                              {canManageUsers ? (
                                <button
                                  className="add-user-btn"
                                  onClick={() => {
                                    setCreateUserError(null);
                                    setShowAddUserModal(true);
                                  }}
                                >
                                  + Add Staff Member
                                </button>
                              ) : (
                                <button
                                  className="add-user-btn"
                                  style={{
                                    background: "#334155",
                                    borderColor: "#475569",
                                    color: "#94a3b8",
                                    cursor: "pointer",
                                  }}
                                  title="Admin account required to add new staff"
                                  onClick={() => {
                                    alert(
                                      "Admin Access Required:\n\nAdding new staff members is restricted to Administrator accounts.\n\nPlease log out and sign in using the Admin account:\n• Email: admin@hotelkapila.com\n• Password: password123"
                                    );
                                  }}
                                >
                                  🔒 + Add Staff Member
                                </button>
                              )}
                            </div>
                          </div>

                          <div className="table-responsive">
                            <table className="clean-table">
                              <thead>
                                <tr>
                                  <th>User Name</th>
                                  <th>Email</th>
                                  <th>Phone</th>
                                  <th>Assigned Roles</th>
                                  {canManageUsers && <th>Assign Role</th>}
                                  {canManageUsers && <th>Outlet Scope</th>}
                                  {canManageUsers && <th>Assign</th>}
                                  <th style={{ textAlign: "right" }}>Actions</th>
                                </tr>
                              </thead>
                              <tbody>
                                {users.map((user) => (
                                  <tr key={user.id}>
                                    <td>
                                      <strong>{user.firstName} {user.lastName}</strong>
                                      {!user.isActive && <div className="inactive-tag">Inactive</div>}
                                    </td>
                                    <td>{user.email}</td>
                                    <td>{user.phone || "—"}</td>
                                    <td>
                                      {user.userRoles.length === 0 && <span className="no-roles">No roles assigned</span>}
                                      {user.userRoles.map((ur) => (
                                        <div key={ur.roleId} className="role-chip">
                                          <span>
                                            {ur.roleName}
                                            {ur.outletName ? ` @ ${ur.outletName}` : " (org-wide)"}
                                          </span>
                                          {canManageUsers && (
                                            <button
                                              className="revoke-btn"
                                              disabled={revoking === `${user.id}:${ur.roleId}`}
                                              onClick={() => revokeRole(user.id, ur.roleId)}
                                            >
                                              {revoking === `${user.id}:${ur.roleId}` ? "..." : "✕"}
                                            </button>
                                          )}
                                        </div>
                                      ))}
                                    </td>

                                    {canManageUsers && (
                                      <td>
                                        <select
                                          value={selectedRole[user.id] ?? ""}
                                          onChange={(e) =>
                                            setSelectedRole((prev) => ({ ...prev, [user.id]: e.target.value }))
                                          }
                                          className="role-select"
                                        >
                                          <option value="">Select role...</option>
                                          {roles.map((role) => (
                                            <option key={role.id} value={role.id}>
                                              {role.name}
                                            </option>
                                          ))}
                                        </select>
                                      </td>
                                    )}

                                    {canManageUsers && (
                                      <td>
                                        <select
                                          value={selectedOutlet[user.id] ?? ""}
                                          onChange={(e) =>
                                            setSelectedOutlet((prev) => ({ ...prev, [user.id]: e.target.value }))
                                          }
                                          className="outlet-input"
                                        >
                                          <option value="">Org-wide (All Outlets)</option>
                                          {outlets.map((outlet) => (
                                            <option key={outlet.id} value={outlet.id}>
                                              {outlet.name}
                                            </option>
                                          ))}
                                        </select>
                                      </td>
                                    )}

                                    {canManageUsers && (
                                      <td>
                                        <button
                                          className="assign-btn"
                                          disabled={assigning === user.id}
                                          onClick={() => assignRole(user.id)}
                                        >
                                          {assigning === user.id ? "..." : "Assign"}
                                        </button>
                                      </td>
                                    )}

                                    <td style={{ textAlign: "right" }}>
                                      <div style={{ display: "inline-flex", gap: "6px" }}>
                                        <button
                                          className="btn-table-action view"
                                          onClick={() =>
                                            setViewModalData({
                                              title: `User Profile: ${user.firstName} ${user.lastName}`,
                                              subtitle: `Account ID: ${user.id}`,
                                              details: [
                                                { label: "Full Name", value: `${user.firstName} ${user.lastName}` },
                                                { label: "Email Address", value: user.email },
                                                { label: "Contact Phone", value: user.phone || "—" },
                                                { label: "Account Status", value: user.isActive ? "🟢 Active Account" : "🔴 Deactivated" },
                                                {
                                                  label: "Assigned Roles",
                                                  value: user.userRoles.length > 0 ? (
                                                    <div style={{ display: "flex", flexWrap: "wrap", gap: "4px" }}>
                                                      {user.userRoles.map((r) => (
                                                        <span key={r.roleId} className="role-tag">
                                                          {r.roleName} {r.outletName ? `(${r.outletName})` : "(All Outlets)"}
                                                        </span>
                                                      ))}
                                                    </div>
                                                  ) : (
                                                    "No roles granted"
                                                  ),
                                                },
                                              ],
                                            })
                                          }
                                        >
                                          👁️ View
                                        </button>
                                        {canManageUsers && (
                                          <>
                                            <button
                                              className="edit-btn"
                                              onClick={() => {
                                                setEditingUserId(user.id);
                                                setEditUserEmail(user.email);
                                                setEditUserFirstName(user.firstName);
                                                setEditUserLastName(user.lastName);
                                                setEditUserPhone(user.phone || "");
                                                setEditUserIsActive(user.isActive);
                                                setEditUserPassword("");
                                                setEditUserPin("");
                                                setEditUserError(null);
                                                setShowEditUserModal(true);
                                              }}
                                            >
                                              ✏️ Edit
                                            </button>
                                            <button
                                              className="delete-btn"
                                              disabled={deletingUserId === user.id || user.id === me?.userId}
                                              onClick={() => handleDeleteUser(user.id)}
                                            >
                                              🗑️
                                            </button>
                                          </>
                                        )}
                                      </div>
                                    </td>
                                  </tr>
                                ))}
                              </tbody>
                            </table>
                          </div>
                        </section>

                        {/* Role Management Section Link & Quick Summary */}
                        <section
                          style={{
                            marginTop: "20px",
                            padding: "20px 24px",
                            background: "#1e293b",
                            borderRadius: "12px",
                            border: "1px solid #334155",
                            display: "flex",
                            justifyContent: "space-between",
                            alignItems: "center",
                            flexWrap: "wrap",
                            gap: "16px",
                          }}
                        >
                          <div>
                            <div style={{ display: "flex", alignItems: "center", gap: "8px", marginBottom: "4px" }}>
                              <span style={{ fontSize: "1.2rem" }}>🛡️</span>
                              <h3 style={{ margin: 0, fontSize: "1.05rem", fontWeight: 700, color: "#f8fafc" }}>
                                RBAC Roles &amp; Permissions Management
                              </h3>
                              <span className="counter-pill">{roles.length} Roles Defined</span>
                            </div>
                            <p style={{ margin: 0, color: "#94a3b8", fontSize: "0.82rem", maxWidth: "680px", lineHeight: "1.5" }}>
                              System roles and granular permission matrices are organized in the dedicated Role Management section. Create custom roles, toggle fine-grained permission flags, and audit assigned staff.
                            </p>
                          </div>
                          <div style={{ display: "flex", gap: "10px", alignItems: "center" }}>
                            {canManageUsers && (
                              <button
                                className="add-user-btn"
                                onClick={openCreateRole}
                                style={{ background: "#334155", border: "1px solid #475569" }}
                              >
                                + Quick Role
                              </button>
                            )}
                            <Link
                              href="/role-management"
                              style={{
                                background: "#4f46e5",
                                color: "#ffffff",
                                padding: "8px 18px",
                                borderRadius: "8px",
                                textDecoration: "none",
                                fontWeight: 700,
                                fontSize: "0.82rem",
                                display: "inline-flex",
                                alignItems: "center",
                                gap: "6px",
                              }}
                            >
                              Open Role Management Page →
                            </Link>
                          </div>
                        </section>
                      </>
                    )}
                  </div>
                )}

                {/* ========================================================================= */}
                {/* DETAIL VIEW MODAL (UNIVERSAL INSPECTOR)                                   */}
                {/* ========================================================================= */}
                {viewModalData && (
                  <div className="modal-overlay" onClick={() => setViewModalData(null)}>
                    <div className="modal-content view-modal" onClick={(e) => e.stopPropagation()}>
                      <div className="modal-header">
                        <div>
                          <h4>{viewModalData.title}</h4>
                          {viewModalData.subtitle && <span className="modal-subtitle">{viewModalData.subtitle}</span>}
                        </div>
                        <button className="close-modal-btn" onClick={() => setViewModalData(null)}>
                          ✕
                        </button>
                      </div>

                      <div className="view-modal-body">
                        <div className="details-grid">
                          {viewModalData.details.map((item, idx) => (
                            <div key={idx} className="detail-item">
                              <span className="detail-label">{item.label}</span>
                              <div className="detail-value">{item.value}</div>
                            </div>
                          ))}
                        </div>
                      </div>

                      <div className="modal-actions">
                        <button
                          className="btn-download json"
                          onClick={() => {
                            exportToJson(
                              `Record_${viewModalData.title.replace(/[^a-zA-Z0-9]/g, "_")}`,
                              viewModalData
                            );
                          }}
                        >
                          📥 Export Details (JSON)
                        </button>
                        <button className="cancel-modal-btn" onClick={() => setViewModalData(null)}>
                          Close
                        </button>
                      </div>
                    </div>
                  </div>
                )}

                {/* Create User Modal */}
                {showAddUserModal && (
                  <div className="modal-overlay">
                    <div className="modal-content">
                      <div className="modal-header">
                        <h4>Add New Staff Member</h4>
                        <button className="close-modal-btn" onClick={() => setShowAddUserModal(false)}>✕</button>
                      </div>
                      <form onSubmit={handleCreateUser} className="modal-form">
                        <div className="form-group">
                          <label>First Name *</label>
                          <input type="text" required value={newUserFirstName} onChange={(e) => setNewUserFirstName(e.target.value)} />
                        </div>
                        <div className="form-group">
                          <label>Last Name *</label>
                          <input type="text" required value={newUserLastName} onChange={(e) => setNewUserLastName(e.target.value)} />
                        </div>
                        <div className="form-group">
                          <label>Email Address *</label>
                          <input type="email" required value={newUserEmail} onChange={(e) => setNewUserEmail(e.target.value)} />
                        </div>
                        <div className="form-group">
                          <label>Password *</label>
                          <input type="password" required value={newUserPassword} onChange={(e) => setNewUserPassword(e.target.value)} />
                        </div>
                        <div className="form-group">
                          <label>POS Pin (4-digit, optional)</label>
                          <input type="text" maxLength={4} value={newUserPin} onChange={(e) => setNewUserPin(e.target.value)} />
                        </div>
                        <div className="form-group">
                          <label>Phone Number</label>
                          <input type="text" value={newUserPhone} onChange={(e) => setNewUserPhone(e.target.value)} />
                        </div>
                        <div className="form-group">
                          <label>Initial Role</label>
                          <select value={newUserRoleId} onChange={(e) => setNewUserRoleId(e.target.value)}>
                            <option value="">None</option>
                            {roles.map((r) => <option key={r.id} value={r.id}>{r.name}</option>)}
                          </select>
                        </div>
                        <div className="form-group">
                          <label>Outlet Scope</label>
                          <select value={newUserOutletId} onChange={(e) => setNewUserOutletId(e.target.value)}>
                            <option value="">Org-wide (All Outlets)</option>
                            {outlets.map((outlet) => (
                              <option key={outlet.id} value={outlet.id}>
                                {outlet.name}
                              </option>
                            ))}
                          </select>
                        </div>
                        {createUserError && (
                          <div className="error-banner">{createUserError}</div>
                        )}
                        <div className="modal-actions">
                          <button type="button" className="cancel-modal-btn" onClick={() => setShowAddUserModal(false)}>
                            Cancel
                          </button>
                          <button type="submit" className="submit-modal-btn" disabled={creatingUser}>
                            {creatingUser ? "Saving..." : "Create Account"}
                          </button>
                        </div>
                      </form>
                    </div>
                  </div>
                )}

                {/* Edit User Modal */}
                {showEditUserModal && (
                  <div className="modal-overlay">
                    <div className="modal-content">
                      <div className="modal-header">
                        <h4>Edit Staff Member</h4>
                        <button className="close-modal-btn" onClick={() => setShowEditUserModal(false)}>✕</button>
                      </div>
                      <form onSubmit={handleUpdateUser} className="modal-form">
                        <div className="form-group">
                          <label>First Name *</label>
                          <input type="text" required value={editUserFirstName} onChange={(e) => setEditUserFirstName(e.target.value)} />
                        </div>
                        <div className="form-group">
                          <label>Last Name *</label>
                          <input type="text" required value={editUserLastName} onChange={(e) => setEditUserLastName(e.target.value)} />
                        </div>
                        <div className="form-group">
                          <label>Email Address *</label>
                          <input type="email" required value={editUserEmail} onChange={(e) => setEditUserEmail(e.target.value)} />
                        </div>
                        <div className="form-group">
                          <label>Password (leave blank to keep current)</label>
                          <input type="password" value={editUserPassword} onChange={(e) => setEditUserPassword(e.target.value)} />
                        </div>
                        <div className="form-group">
                          <label>POS Pin (leave blank to keep current)</label>
                          <input type="text" maxLength={4} value={editUserPin} onChange={(e) => setEditUserPin(e.target.value)} />
                        </div>
                        <div className="form-group">
                          <label>Phone Number</label>
                          <input type="text" value={editUserPhone} onChange={(e) => setEditUserPhone(e.target.value)} />
                        </div>
                        <div className="form-group-checkbox">
                          <input type="checkbox" id="isActiveCheck" checked={editUserIsActive} onChange={(e) => setEditUserIsActive(e.target.checked)} />
                          <label htmlFor="isActiveCheck">Account Active</label>
                        </div>
                        {editUserError && (
                          <div className="error-banner">{editUserError}</div>
                        )}
                        <div className="modal-actions">
                          <button type="button" className="cancel-modal-btn" onClick={() => setShowEditUserModal(false)}>
                            Cancel
                          </button>
                          <button type="submit" className="submit-modal-btn" disabled={editingUserSaving}>
                            {editingUserSaving ? "Saving..." : "Save Changes"}
                          </button>
                        </div>
                      </form>
                    </div>
                  </div>
                )}

                {/* Role Editor Modal */}
                {showRoleEditor && (
                  <div className="modal-overlay">
                    <div className="modal-content modal-lg">
                      <div className="modal-header">
                        <h4>{editingRoleId ? "Edit Role & Permissions" : "Create New Role"}</h4>
                        <button className="close-modal-btn" onClick={() => setShowRoleEditor(false)}>✕</button>
                      </div>
                      <div className="modal-form">
                        <div className="form-group">
                          <label>Role Name *</label>
                          <input type="text" value={roleName} onChange={(e) => setRoleName(e.target.value)} placeholder="e.g. HEAD_WAITER" />
                        </div>
                        <div className="form-group">
                          <label>Description</label>
                          <input type="text" value={roleDescription} onChange={(e) => setRoleDescription(e.target.value)} placeholder="e.g. Floor Captain with discount rights" />
                        </div>
                        <div className="form-group">
                          <label>Granular Permissions ({roleGrantedIds.size} granted)</label>
                          <div className="permission-matrix">
                            {permissions.map((p) => {
                              const checked = roleGrantedIds.has(p.id);
                              return (
                                <label key={p.id} className="permission-row">
                                  <input type="checkbox" checked={checked} onChange={() => togglePermission(p.id)} />
                                  <div>
                                    <span className="permission-action">{p.action}</span>
                                    {p.description && <span className="permission-desc"> — {p.description}</span>}
                                  </div>
                                </label>
                              );
                            })}
                          </div>
                        </div>
                        {roleError && <div className="error-banner">{roleError}</div>}
                        <div className="modal-actions">
                          <button type="button" className="cancel-modal-btn" onClick={() => setShowRoleEditor(false)}>
                            Cancel
                          </button>
                          <button type="button" className="submit-modal-btn" disabled={roleSaving} onClick={saveRole}>
                            {roleSaving ? "Saving..." : "Save Role"}
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>
                )}
              </>
            )}
          </main>
        </div>
      </div>

      <style jsx>{`
        .admin-app {
          display: flex;
          flex-direction: column;
          height: 100vh;
          background: #0f172a;
          color: #f8fafc;
          font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
          overflow: hidden;
        }

        .topbar {
          display: flex;
          align-items: center;
          justify-content: space-between;
          padding: 12px 24px;
          background: #1e293b;
          border-bottom: 1px solid #334155;
          flex-shrink: 0;
        }

        .brand-badge {
          display: flex;
          align-items: center;
          gap: 10px;
        }

        .brand-icon {
          font-size: 1.25rem;
          color: #38bdf8;
        }

        .brand-name {
          font-size: 1.125rem;
          font-weight: 800;
          letter-spacing: -0.025em;
          color: #f1f5f9;
        }

        .topbar-right {
          display: flex;
          align-items: center;
          gap: 16px;
        }

        .view-mode-tag {
          font-size: 0.75rem;
          font-weight: 700;
          background: rgba(56, 189, 248, 0.12);
          border: 1px solid rgba(56, 189, 248, 0.3);
          color: #38bdf8;
          padding: 4px 10px;
          border-radius: 9999px;
        }

        .user-profile-badge {
          display: flex;
          align-items: center;
          gap: 10px;
        }

        .avatar-circle {
          width: 36px;
          height: 36px;
          border-radius: 50%;
          background: #3b82f6;
          color: #fff;
          display: flex;
          align-items: center;
          justify-content: center;
          font-weight: 700;
          font-size: 0.875rem;
        }

        .user-info-text {
          display: flex;
          flex-direction: column;
        }

        .user-name {
          font-size: 0.875rem;
          font-weight: 700;
          color: #f8fafc;
        }

        .user-role {
          font-size: 0.75rem;
          color: #94a3b8;
          text-transform: uppercase;
        }

        .dashboard-body {
          padding: 24px;
          flex: 1;
          display: flex;
          flex-direction: column;
          gap: 20px;
        }

        .dashboard-greeting-row {
          display: flex;
          align-items: flex-start;
          justify-content: space-between;
          flex-wrap: wrap;
          gap: 16px;
        }

        .breadcrumb-line {
          font-size: 0.75rem;
          font-weight: 700;
          text-transform: uppercase;
          letter-spacing: 0.05em;
          color: #38bdf8;
        }

        .greeting-title {
          font-size: 1.75rem;
          font-weight: 800;
          margin: 4px 0 6px 0;
          color: #f8fafc;
        }

        .greeting-subtitle {
          font-size: 0.9375rem;
          color: #94a3b8;
          max-width: 820px;
          margin: 0;
          line-height: 1.5;
        }

        .action-buttons-group {
          display: flex;
          gap: 10px;
          align-items: center;
        }

        .export-action-btn {
          padding: 8px 16px;
          font-size: 0.8125rem;
          font-weight: 700;
          border-radius: 8px;
          cursor: pointer;
          background: #334155;
          color: #f8fafc;
          border: 1px solid #475569;
          transition: all 0.15s ease;
        }

        .export-action-btn:hover {
          background: #475569;
        }

        .export-action-btn.primary {
          background: #2563eb;
          border-color: #3b82f6;
          color: #ffffff;
        }

        .export-action-btn.primary:hover {
          background: #1d4ed8;
        }

        /* Tabs Header */
        .tabs-header-container {
          display: flex;
          gap: 8px;
          border-bottom: 1px solid #334155;
          padding-bottom: 2px;
        }

        .tab-item-btn {
          display: flex;
          align-items: center;
          gap: 8px;
          padding: 10px 20px;
          font-size: 0.9375rem;
          font-weight: 700;
          border: none;
          background: transparent;
          color: #94a3b8;
          border-bottom: 3px solid transparent;
          cursor: pointer;
          transition: all 0.15s ease;
        }

        .tab-item-btn:hover {
          color: #f1f5f9;
        }

        .tab-item-btn.active {
          color: #38bdf8;
          border-bottom-color: #38bdf8;
        }

        .tab-pill {
          font-size: 0.6875rem;
          padding: 2px 6px;
          border-radius: 9999px;
          background: rgba(255, 255, 255, 0.1);
          color: #e2e8f0;
        }

        .tab-item-btn.active .tab-pill {
          background: rgba(56, 189, 248, 0.2);
          color: #38bdf8;
        }

        /* Report Controls Bar */
        .report-controls-bar {
          display: flex;
          align-items: center;
          justify-content: space-between;
          background: #1e293b;
          border: 1px solid #334155;
          padding: 10px 16px;
          border-radius: 10px;
          margin-bottom: 16px;
        }

        .date-presets-group {
          display: flex;
          align-items: center;
          gap: 8px;
        }

        .controls-label {
          font-size: 0.8125rem;
          font-weight: 700;
          color: #94a3b8;
          text-transform: uppercase;
        }

        .preset-btn {
          padding: 6px 12px;
          font-size: 0.8125rem;
          font-weight: 600;
          border-radius: 6px;
          border: 1px solid #475569;
          background: #0f172a;
          color: #cbd5e1;
          cursor: pointer;
          transition: all 0.15s;
        }

        .preset-btn.active {
          background: #38bdf8;
          color: #0f172a;
          border-color: #38bdf8;
          font-weight: 700;
        }

        .refresh-btn {
          padding: 6px 12px;
          font-size: 0.8125rem;
          font-weight: 700;
          border-radius: 6px;
          border: 1px solid #475569;
          background: #334155;
          color: #f1f5f9;
          cursor: pointer;
        }

        /* KPI Cards Grid */
        .kpi-grid {
          display: grid;
          grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
          gap: 16px;
          margin-bottom: 20px;
        }

        .kpi-card {
          background: #1e293b;
          border: 1px solid #334155;
          padding: 16px;
          border-radius: 12px;
          display: flex;
          align-items: center;
          gap: 14px;
        }

        .kpi-card.highlight {
          border-color: #f59e0b;
          background: linear-gradient(135deg, #1e293b 0%, rgba(245, 158, 11, 0.08) 100%);
        }

        .kpi-icon {
          font-size: 1.75rem;
          background: #0f172a;
          width: 48px;
          height: 48px;
          display: flex;
          align-items: center;
          justify-content: center;
          border-radius: 10px;
          border: 1px solid #334155;
        }

        .kpi-content {
          display: flex;
          flex-direction: column;
        }

        .kpi-label {
          font-size: 0.75rem;
          font-weight: 700;
          text-transform: uppercase;
          color: #94a3b8;
        }

        .kpi-value {
          font-size: 1.25rem;
          font-weight: 800;
          color: #f8fafc;
          margin: 2px 0;
        }

        .kpi-sub {
          font-size: 0.75rem;
          color: #64748b;
        }

        /* Panel Card Styles */
        .panel-card {
          background: #1e293b;
          border: 1px solid #334155;
          border-radius: 12px;
          padding: 20px;
          margin-bottom: 20px;
        }

        .panel-header {
          display: flex;
          align-items: center;
          justify-content: space-between;
          flex-wrap: wrap;
          gap: 12px;
          margin-bottom: 16px;
        }

        .panel-title-icon {
          font-size: 1.25rem;
        }

        .panel-header h3 {
          font-size: 1.125rem;
          font-weight: 800;
          color: #f8fafc;
          margin: 0;
        }

        .panel-sub {
          font-size: 0.8125rem;
          color: #94a3b8;
          margin: 2px 0 0 0;
        }

        .panel-actions {
          display: flex;
          align-items: center;
          gap: 8px;
        }

        .search-input {
          background: #0f172a;
          border: 1px solid #334155;
          padding: 6px 12px;
          border-radius: 6px;
          color: #f8fafc;
          font-size: 0.8125rem;
          min-width: 220px;
        }

        .search-input:focus {
          outline: none;
          border-color: #38bdf8;
        }

        .btn-download {
          padding: 6px 12px;
          font-size: 0.75rem;
          font-weight: 700;
          border-radius: 6px;
          cursor: pointer;
          border: 1px solid transparent;
          transition: all 0.15s;
        }

        .btn-download.csv {
          background: #047857;
          color: #ecfdf5;
          border-color: #059669;
        }

        .btn-download.csv:hover {
          background: #059669;
        }

        .btn-download.json {
          background: #4f46e5;
          color: #eef2ff;
          border-color: #6366f1;
        }

        .btn-download.json:hover {
          background: #6366f1;
        }

        /* Clean Table */
        .table-responsive {
          overflow-x: auto;
        }

        .clean-table {
          width: 100%;
          border-collapse: collapse;
          font-size: 0.875rem;
        }

        .clean-table th {
          text-align: left;
          padding: 10px 12px;
          background: #0f172a;
          color: #94a3b8;
          font-weight: 700;
          font-size: 0.75rem;
          text-transform: uppercase;
          border-bottom: 2px solid #334155;
        }

        .clean-table td {
          padding: 12px;
          border-bottom: 1px solid #334155;
          color: #cbd5e1;
        }

        .clean-table tr:hover td {
          background: rgba(255, 255, 255, 0.02);
        }

        .highlight-amount {
          font-weight: 800;
          color: #38bdf8;
        }

        .repeat-badge {
          display: inline-block;
          margin-left: 6px;
          font-size: 0.6875rem;
          font-weight: 700;
          background: rgba(16, 185, 129, 0.15);
          color: #34d399;
          border: 1px solid rgba(16, 185, 129, 0.3);
          padding: 2px 6px;
          border-radius: 4px;
        }

        .rank-badge {
          display: inline-block;
          font-weight: 800;
          font-size: 0.75rem;
          padding: 2px 6px;
          border-radius: 4px;
          background: #334155;
          color: #f1f5f9;
        }

        .rank-badge.gold {
          background: #eab308;
          color: #000;
        }

        .rank-badge.silver {
          background: #94a3b8;
          color: #000;
        }

        .rank-badge.bronze {
          background: #b45309;
          color: #fff;
        }

        .counter-pill {
          background: #0f172a;
          border: 1px solid #334155;
          padding: 2px 8px;
          border-radius: 9999px;
          font-size: 0.75rem;
          font-weight: 700;
        }

        .counter-pill.bold {
          background: rgba(56, 189, 248, 0.15);
          color: #38bdf8;
          border-color: rgba(56, 189, 248, 0.3);
        }

        .loyalty-pill {
          background: rgba(245, 158, 11, 0.15);
          color: #fbbf24;
          border: 1px solid rgba(245, 158, 11, 0.3);
          padding: 2px 8px;
          border-radius: 9999px;
          font-size: 0.75rem;
          font-weight: 700;
        }

        .velocity-tag {
          font-size: 0.6875rem;
          font-weight: 700;
          padding: 2px 8px;
          border-radius: 9999px;
        }

        .velocity-tag.hot {
          background: rgba(239, 68, 68, 0.15);
          color: #f87171;
          border: 1px solid rgba(239, 68, 68, 0.3);
        }

        .velocity-tag.normal {
          background: rgba(148, 163, 184, 0.15);
          color: #94a3b8;
          border: 1px solid rgba(148, 163, 184, 0.3);
        }

        .role-tag {
          background: #0f172a;
          border: 1px solid #334155;
          padding: 2px 6px;
          border-radius: 4px;
          font-size: 0.75rem;
          color: #cbd5e1;
        }

        .variance-tag.warning {
          color: #f87171;
          font-weight: 700;
        }

        .variance-tag.zero {
          color: #64748b;
        }

        /* Action Buttons */
        .btn-table-action {
          padding: 4px 8px;
          border-radius: 4px;
          font-size: 0.75rem;
          font-weight: 700;
          cursor: pointer;
          border: 1px solid #475569;
          background: #334155;
          color: #f8fafc;
          transition: all 0.15s;
        }

        .btn-table-action.view {
          background: rgba(56, 189, 248, 0.15);
          border-color: rgba(56, 189, 248, 0.4);
          color: #38bdf8;
        }

        .btn-table-action.view:hover {
          background: rgba(56, 189, 248, 0.3);
        }

        .btn-table-action.dl:hover {
          background: #475569;
        }

        /* Split Grid Row */
        .split-grid-row {
          display: grid;
          grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
          gap: 20px;
        }

        /* Users & Roles Specific Styles */
        .role-chip {
          display: inline-flex;
          align-items: center;
          gap: 6px;
          background: #0f172a;
          border: 1px solid #334155;
          padding: 2px 8px;
          border-radius: 4px;
          font-size: 0.75rem;
          margin: 2px 4px 2px 0;
        }

        .revoke-btn {
          border: none;
          background: transparent;
          color: #ef4444;
          cursor: pointer;
          font-weight: bold;
        }

        .role-select, .outlet-input {
          background: #0f172a;
          border: 1px solid #334155;
          color: #f8fafc;
          padding: 6px 10px;
          border-radius: 6px;
          font-size: 0.8125rem;
        }

        .assign-btn {
          background: #2563eb;
          color: #fff;
          border: none;
          padding: 6px 12px;
          border-radius: 6px;
          font-weight: 700;
          font-size: 0.75rem;
          cursor: pointer;
        }

        .edit-btn {
          background: #334155;
          color: #f8fafc;
          border: 1px solid #475569;
          padding: 4px 8px;
          border-radius: 4px;
          font-size: 0.75rem;
          cursor: pointer;
        }

        .delete-btn {
          background: rgba(239, 68, 68, 0.15);
          color: #f87171;
          border: 1px solid rgba(239, 68, 68, 0.4);
          padding: 4px 8px;
          border-radius: 4px;
          font-size: 0.75rem;
          cursor: pointer;
        }

        .add-user-btn {
          background: #2563eb;
          color: #fff;
          border: none;
          padding: 8px 16px;
          border-radius: 8px;
          font-weight: 700;
          font-size: 0.8125rem;
          cursor: pointer;
        }

        .inactive-tag {
          font-size: 0.6875rem;
          color: #f87171;
          font-weight: 700;
        }

        /* Modal Styles */
        .modal-overlay {
          position: fixed;
          top: 0;
          left: 0;
          right: 0;
          bottom: 0;
          background: rgba(0, 0, 0, 0.75);
          backdrop-filter: blur(4px);
          display: flex;
          align-items: center;
          justify-content: center;
          z-index: 1000;
          padding: 20px;
        }

        .modal-content {
          background: #1e293b;
          border: 1px solid #334155;
          border-radius: 14px;
          padding: 24px;
          width: 100%;
          max-width: 520px;
          max-height: 90vh;
          display: flex;
          flex-direction: column;
          box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.5);
        }

        .modal-content.modal-lg {
          max-width: 720px;
        }

        .modal-content.view-modal {
          max-width: 640px;
        }

        .modal-header {
          display: flex;
          align-items: flex-start;
          justify-content: space-between;
          margin-bottom: 16px;
          padding-bottom: 12px;
          border-bottom: 1px solid #334155;
        }

        .modal-header h4 {
          font-size: 1.25rem;
          font-weight: 800;
          color: #f8fafc;
          margin: 0;
        }

        .modal-subtitle {
          font-size: 0.75rem;
          color: #94a3b8;
          font-family: monospace;
        }

        .close-modal-btn {
          background: transparent;
          border: none;
          color: #94a3b8;
          font-size: 1.25rem;
          cursor: pointer;
        }

        .view-modal-body {
          overflow-y: auto;
          flex: 1;
          margin-bottom: 16px;
        }

        .details-grid {
          display: grid;
          grid-template-columns: 1fr;
          gap: 12px;
        }

        .detail-item {
          background: #0f172a;
          border: 1px solid #334155;
          border-radius: 8px;
          padding: 10px 14px;
          display: flex;
          flex-direction: column;
          gap: 4px;
        }

        .detail-label {
          font-size: 0.6875rem;
          font-weight: 700;
          text-transform: uppercase;
          letter-spacing: 0.05em;
          color: #38bdf8;
        }

        .detail-value {
          font-size: 0.9375rem;
          font-weight: 600;
          color: #f8fafc;
        }

        .modal-actions {
          display: flex;
          justify-content: flex-end;
          gap: 12px;
          padding-top: 14px;
          border-top: 1px solid #334155;
        }

        .cancel-modal-btn {
          background: #334155;
          border: 1px solid #475569;
          color: #f8fafc;
          padding: 8px 16px;
          border-radius: 6px;
          cursor: pointer;
          font-weight: 600;
        }

        .submit-modal-btn {
          background: #2563eb;
          color: #fff;
          border: none;
          padding: 8px 16px;
          border-radius: 6px;
          cursor: pointer;
          font-weight: 700;
        }

        .modal-form {
          display: flex;
          flex-direction: column;
          gap: 12px;
          overflow-y: auto;
        }

        .form-group {
          display: flex;
          flex-direction: column;
          gap: 4px;
        }

        .form-group label {
          font-size: 0.75rem;
          font-weight: 700;
          color: #94a3b8;
          text-transform: uppercase;
        }

        .form-group input, .form-group select {
          padding: 8px 12px;
          border: 1px solid #334155;
          border-radius: 6px;
          font-size: 0.875rem;
          background: #0f172a;
          color: #f8fafc;
        }

        .form-group-checkbox {
          display: flex;
          align-items: center;
          gap: 8px;
        }

        .permission-matrix {
          display: flex;
          flex-direction: column;
          gap: 4px;
          max-height: 260px;
          overflow-y: auto;
          background: #0f172a;
          border: 1px solid #334155;
          border-radius: 6px;
          padding: 8px;
        }

        .permission-row {
          display: flex;
          align-items: center;
          gap: 10px;
          padding: 6px;
          cursor: pointer;
          font-size: 0.8125rem;
        }

        .permission-row:hover {
          background: rgba(255, 255, 255, 0.05);
        }

        .permission-action {
          font-family: monospace;
          font-weight: 700;
          color: #38bdf8;
        }

        .permission-desc {
          color: #94a3b8;
          font-size: 0.75rem;
        }

        .error-banner {
          background: rgba(239, 68, 68, 0.15);
          border: 1px solid #ef4444;
          color: #f87171;
          padding: 8px 12px;
          border-radius: 6px;
          font-size: 0.8125rem;
        }

        .empty-state-card {
          background: #1e293b;
          border: 1px solid #334155;
          border-radius: 12px;
          padding: 32px;
          text-align: center;
          display: flex;
          flex-direction: column;
          align-items: center;
          gap: 12px;
        }

        .empty-icon {
          font-size: 2.5rem;
        }

        @media print {
          .topbar, .action-buttons-group, .tabs-header-container, .report-controls-bar, .panel-actions, .btn-table-action {
            display: none !important;
          }
          .admin-app {
            height: auto !important;
            background: #fff !important;
            color: #000 !important;
          }
          .panel-card {
            border: 1px solid #ccc !important;
            background: #fff !important;
            color: #000 !important;
            break-inside: avoid;
          }
          .clean-table th, .clean-table td {
            color: #000 !important;
            border-bottom: 1px solid #ddd !important;
          }
        }
      `}</style>
    </div>
  );
}
