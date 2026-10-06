import { Router } from "express";
import { requireAuth, requirePermission, type AuthedRequest } from "../middleware/require-auth";
import { prisma } from "../prisma";
import { sendServerError } from "../errors";
import { PgSettingsRepository } from "../../../../services/settings/src/PgSettingsRepository";
import { getPool } from "../../../../services/shared/src/db/Pool";
import type { OutletBillingSettings, OutletPrintSettings } from "../../../../services/settings/src/types";

export const settingsRouter = Router();

// GET /settings/outlet-status & GET /settings/store-status
const handleGetOutletStatus = async (req: AuthedRequest, res: any) => {
  try {
    const outletId = req.auth!.outletId;
    const pool = getPool();
    const { rows } = await pool.query(
      `SELECT outlet_id, is_online, dine_in_active, delivery_active, takeaway_active, updated_at
       FROM outlet_status WHERE outlet_id = $1`,
      [outletId]
    );
    const row = rows[0];

    res.status(200).json({
      isOnline: row ? Boolean(row.is_online) : true,
      dineInActive: row ? Boolean(row.dine_in_active) : true,
      deliveryActive: row ? Boolean(row.delivery_active) : true,
      takeawayActive: row ? Boolean(row.takeaway_active) : true,
      updatedAt: row?.updated_at ? new Date(row.updated_at).toISOString() : null,
    });
  } catch (err) {
    sendServerError(res, err, "GET /settings/outlet-status");
  }
};

settingsRouter.get("/settings/outlet-status", requireAuth, handleGetOutletStatus);
settingsRouter.get("/settings/store-status", requireAuth, handleGetOutletStatus);

// POST & PATCH /settings/outlet-status & /settings/store-status
const handleUpdateOutletStatus = async (req: AuthedRequest, res: any) => {
  const isOnline = req.body.isOnline ?? req.body.isOpen ?? req.body.active;
  const dineInActive = req.body.dineInActive;
  const deliveryActive = req.body.deliveryActive;
  const takeawayActive = req.body.takeawayActive;

  try {
    const outletId = req.auth!.outletId;
    const userId = req.auth!.userId;
    const pool = getPool();

    // Fetch existing
    const { rows: existingRows } = await pool.query(
      `SELECT outlet_id, is_online, dine_in_active, delivery_active, takeaway_active FROM outlet_status WHERE outlet_id = $1`,
      [outletId]
    );
    const existing = existingRows[0];

    const nextIsOnline = typeof isOnline === "boolean" ? isOnline : (existing ? Boolean(existing.is_online) : true);
    const nextDineIn = typeof dineInActive === "boolean" ? dineInActive : (existing ? Boolean(existing.dine_in_active) : true);
    const nextDelivery = typeof deliveryActive === "boolean" ? deliveryActive : (existing ? Boolean(existing.delivery_active) : true);
    const nextTakeaway = typeof takeawayActive === "boolean" ? takeawayActive : (existing ? Boolean(existing.takeaway_active) : true);

    const { rows: updatedRows } = await pool.query(
      `INSERT INTO outlet_status (outlet_id, is_online, dine_in_active, delivery_active, takeaway_active, updated_at, updated_by)
       VALUES ($1, $2, $3, $4, $5, now(), $6)
       ON CONFLICT (outlet_id) DO UPDATE SET
         is_online = EXCLUDED.is_online,
         dine_in_active = EXCLUDED.dine_in_active,
         delivery_active = EXCLUDED.delivery_active,
         takeaway_active = EXCLUDED.takeaway_active,
         updated_at = now(),
         updated_by = EXCLUDED.updated_by
       RETURNING outlet_id, is_online, dine_in_active, delivery_active, takeaway_active, updated_at`,
      [outletId, nextIsOnline, nextDineIn, nextDelivery, nextTakeaway, userId]
    );
    const status = updatedRows[0];

    import("../websockets").then(({ broadcast }) => {
      broadcast(outletId, "outlet.store_status_updated", {
        outletId,
        isOnline: Boolean(status.is_online),
        dineInActive: Boolean(status.dine_in_active),
        deliveryActive: Boolean(status.delivery_active),
        takeawayActive: Boolean(status.takeaway_active),
      });
    }).catch(() => {});

    res.status(200).json({
      isOnline: Boolean(status.is_online),
      dineInActive: Boolean(status.dine_in_active),
      deliveryActive: Boolean(status.delivery_active),
      takeawayActive: Boolean(status.takeaway_active),
      updatedAt: status.updated_at ? new Date(status.updated_at).toISOString() : new Date().toISOString(),
    });
  } catch (err) {
    sendServerError(res, err, "PATCH /settings/outlet-status");
  }
};

settingsRouter.post("/settings/outlet-status", requireAuth, handleUpdateOutletStatus);
settingsRouter.patch("/settings/outlet-status", requireAuth, handleUpdateOutletStatus);
settingsRouter.post("/settings/store-status", requireAuth, handleUpdateOutletStatus);
settingsRouter.patch("/settings/store-status", requireAuth, handleUpdateOutletStatus);

// ---- Print & billing settings CRUD (TSK-008c) ----
// Backed by the real Postgres-backed PgSettingsRepository (outlet_billing_settings
// / outlet_print_settings). Always scoped by req.auth!.outletId from the JWT —
// never a client-supplied outlet id.
const settingsRepo = new PgSettingsRepository(getPool());

settingsRouter.get("/settings/print", requireAuth, requirePermission("settings.manage"), async (req: AuthedRequest, res: any) => {
  try {
    const outletId = req.auth!.outletId;
    const settings = await settingsRepo.getPrintSettings(outletId);
    res.status(200).json(settings);
  } catch (err) {
    sendServerError(res, err, "GET /settings/print");
  }
});

settingsRouter.put("/settings/print", requireAuth, requirePermission("settings.manage"), async (req: AuthedRequest, res: any) => {
  try {
    const outletId = req.auth!.outletId;
    const { outlet_id, updated_at, ...patch } = (req.body ?? {}) as Partial<OutletPrintSettings>;
    const current = await settingsRepo.getPrintSettings(outletId);
    const updated: OutletPrintSettings = {
      ...current,
      ...patch,
      outlet_id: outletId,
      updated_at: new Date().toISOString(),
    };
    const saved = await settingsRepo.savePrintSettings(updated);
    res.status(200).json(saved);
  } catch (err) {
    sendServerError(res, err, "PUT /settings/print");
  }
});

settingsRouter.get("/settings/billing", requireAuth, requirePermission("settings.manage"), async (req: AuthedRequest, res: any) => {
  try {
    const outletId = req.auth!.outletId;
    const settings = await settingsRepo.getBillingSettings(outletId);
    res.status(200).json(settings);
  } catch (err) {
    sendServerError(res, err, "GET /settings/billing");
  }
});

settingsRouter.put("/settings/billing", requireAuth, requirePermission("settings.manage"), async (req: AuthedRequest, res: any) => {
  try {
    const outletId = req.auth!.outletId;
    const { outlet_id, updated_at, ...patch } = (req.body ?? {}) as Partial<OutletBillingSettings>;
    const current = await settingsRepo.getBillingSettings(outletId);
    const updated: OutletBillingSettings = {
      ...current,
      ...patch,
      outlet_id: outletId,
      updated_at: new Date().toISOString(),
    };
    const saved = await settingsRepo.saveBillingSettings(updated);
    res.status(200).json(saved);
  } catch (err) {
    sendServerError(res, err, "PUT /settings/billing");
  }
});

// GET /settings/company — combined outlet + organization profile for the
// caller's outlet. Resolved from req.auth.outletId only; a client can never
// select a different outlet/organization via this endpoint.
settingsRouter.get("/settings/company", requireAuth, requirePermission("settings.manage"), async (req: AuthedRequest, res: any) => {
  try {
    const outletId = req.auth!.outletId;
    const outlet = await prisma.outlet.findUnique({ where: { id: outletId } });
    if (!outlet) {
      res.status(404).json({ code: "OUTLET_NOT_FOUND", error: "outlet not found" });
      return;
    }
    const organization = await prisma.organization.findUnique({
      where: { id: (outlet as any).organizationId },
    });

    res.status(200).json({
      name: (outlet as any).name ?? null,
      address: (outlet as any).address ?? null,
      phone: (outlet as any).phone ?? null,
      email: (outlet as any).email ?? null,
      logoUrl: (outlet as any).logoUrl ?? null,
      fssaiNumber: (outlet as any).fssaiNumber ?? null,
      upiVpa: (outlet as any).upiVpa ?? null,
      organizationName: (organization as any)?.name ?? null,
      taxNumber: (organization as any)?.taxNumber ?? null,
    });
  } catch (err) {
    sendServerError(res, err, "GET /settings/company");
  }
});

// PATCH /settings/company — updates any subset of outlet/organization profile
// fields for the caller's outlet, in a single transaction. Never trusts a
// client-supplied outletId/organizationId — always derived from req.auth.
settingsRouter.patch("/settings/company", requireAuth, requirePermission("settings.manage"), async (req: AuthedRequest, res: any) => {
  try {
    const outletId = req.auth!.outletId;
    const userId = req.auth!.userId;
    const body = (req.body ?? {}) as Record<string, unknown>;

    const outlet = await prisma.outlet.findUnique({ where: { id: outletId } });
    if (!outlet) {
      res.status(404).json({ code: "OUTLET_NOT_FOUND", error: "outlet not found" });
      return;
    }
    const organizationId = (outlet as any).organizationId as string;

    const outletFields = ["name", "address", "phone", "email", "logoUrl", "fssaiNumber", "upiVpa"] as const;
    const orgFields = ["taxNumber"] as const;
    // "name" is ambiguous between outlet and organization; organizationName
    // targets the org row explicitly.
    const outletData: Record<string, unknown> = {};
    for (const key of outletFields) {
      if (Object.prototype.hasOwnProperty.call(body, key)) {
        outletData[key] = body[key];
      }
    }
    const orgData: Record<string, unknown> = {};
    for (const key of orgFields) {
      if (Object.prototype.hasOwnProperty.call(body, key)) {
        orgData[key] = body[key];
      }
    }
    if (Object.prototype.hasOwnProperty.call(body, "organizationName")) {
      orgData.name = body.organizationName;
    }

    if (Object.keys(outletData).length > 0) {
      outletData.updatedAt = new Date();
      outletData.updatedBy = userId;
    }
    if (Object.keys(orgData).length > 0) {
      orgData.updatedAt = new Date();
      orgData.updatedBy = userId;
    }

    const [updatedOutlet, updatedOrg] = await prisma.$transaction([
      prisma.outlet.update({ where: { id: outletId }, data: outletData }),
      prisma.organization.update({ where: { id: organizationId }, data: orgData }),
    ]);

    res.status(200).json({
      name: (updatedOutlet as any).name ?? null,
      address: (updatedOutlet as any).address ?? null,
      phone: (updatedOutlet as any).phone ?? null,
      email: (updatedOutlet as any).email ?? null,
      logoUrl: (updatedOutlet as any).logoUrl ?? null,
      fssaiNumber: (updatedOutlet as any).fssaiNumber ?? null,
      upiVpa: (updatedOutlet as any).upiVpa ?? null,
      organizationName: (updatedOrg as any)?.name ?? null,
      taxNumber: (updatedOrg as any)?.taxNumber ?? null,
    });
  } catch (err) {
    sendServerError(res, err, "PATCH /settings/company");
  }
});
