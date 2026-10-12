import type { NextApiRequest, NextApiResponse } from "next";
import { pullUpdates } from "../../../lib/gitUpdateService";

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method !== "POST") {
    res.setHeader("Allow", ["POST"]);
    return res.status(405).json({ error: `Method ${req.method} not allowed` });
  }

  try {
    const { remote, branch, stash } = req.body || {};

    const result = await pullUpdates({
      remote: typeof remote === "string" ? remote : undefined,
      branch: typeof branch === "string" ? branch : undefined,
      stash: stash !== false,
    });

    return res.status(result.success ? 200 : 400).json(result);
  } catch (err: any) {
    console.error("Error executing git pull updates:", err);
    return res.status(500).json({
      success: false,
      error: err.message || "Failed to pull updates from GitHub",
    });
  }
}
