import { Router } from "express";
import { requireAuth, requirePermission, type AuthedRequest } from "../middleware/require-auth";
import {
  getGitStatus,
  checkForUpdates,
  pullUpdates,
  getRecentPullLogs,
  getPullLogContent,
} from "../services/gitUpdateService";
import { prisma } from "../prisma";

export const appUpdateRouter = Router();

// GET /admin/system/update/status - get current repo & build state
appUpdateRouter.get("/status", requireAuth, async (req: AuthedRequest, res: any) => {
  try {
    const status = await getGitStatus();
    return res.status(200).json(status);
  } catch (err: any) {
    console.error("Error in GET /admin/system/update/status:", err);
    return res.status(500).json({ error: err.message || "Failed to fetch repository status" });
  }
});

// POST /admin/system/update/check - check if updates exist on GitHub
appUpdateRouter.post("/check", requireAuth, async (req: AuthedRequest, res: any) => {
  try {
    const remote = req.body.remote || "origin";
    const branch = req.body.branch;
    const result = await checkForUpdates(remote, branch);
    return res.status(200).json(result);
  } catch (err: any) {
    console.error("Error in POST /admin/system/update/check:", err);
    return res.status(500).json({ error: err.message || "Failed to check for updates" });
  }
});

// POST /admin/system/update/pull - pull latest commits and upgrade app
appUpdateRouter.post("/pull", requireAuth, requirePermission("settings.manage"), async (req: AuthedRequest, res: any) => {
  try {
    const { remote, branch, stash } = req.body || {};
    const userId = req.auth?.userId || "unknown";
    const outletId = req.auth?.outletId;

    const result = await pullUpdates({
      remote: typeof remote === "string" ? remote : undefined,
      branch: typeof branch === "string" ? branch : undefined,
      stash: stash !== false,
    });

    // Record audit log entry if prisma auditLog exists
    try {
      if (outletId && prisma.auditLog) {
        await prisma.auditLog.create({
          data: {
            outletId,
            userId,
            action: "APP_UPGRADE_PULL",
            entityType: "SYSTEM",
            entityId: result.newCommit || "HEAD",
            afterState: {
              previousCommit: result.previousCommit,
              newCommit: result.newCommit,
              success: result.success,
              changedFilesCount: result.changedFiles.length,
              stashed: result.stashed,
              durationMs: result.durationMs,
            },
          },
        });
      }
    } catch {
      // non-critical
    }

    return res.status(result.success ? 200 : 400).json(result);
  } catch (err: any) {
    console.error("Error in POST /admin/system/update/pull:", err);
    return res.status(500).json({
      success: false,
      error: err.message || "Failed to pull updates from GitHub",
    });
  }
});

// GET /admin/system/update/logs - list logs
appUpdateRouter.get("/logs", requireAuth, async (req: AuthedRequest, res: any) => {
  try {
    const file = req.query.file as string | undefined;
    if (file) {
      const content = getPullLogContent(file);
      if (content === null) {
        return res.status(404).json({ error: "Log file not found" });
      }
      return res.status(200).json({ filename: file, content });
    }

    const logs = getRecentPullLogs();
    return res.status(200).json({ logs });
  } catch (err: any) {
    console.error("Error in GET /admin/system/update/logs:", err);
    return res.status(500).json({ error: err.message || "Failed to fetch update logs" });
  }
});
