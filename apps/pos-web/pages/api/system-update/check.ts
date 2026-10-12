import type { NextApiRequest, NextApiResponse } from "next";
import { checkForUpdates } from "../../../lib/gitUpdateService";

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method !== "POST" && req.method !== "GET") {
    res.setHeader("Allow", ["POST", "GET"]);
    return res.status(405).json({ error: `Method ${req.method} not allowed` });
  }

  try {
    const remote = (req.body?.remote || req.query.remote || "origin") as string;
    const branch = (req.body?.branch || req.query.branch) as string | undefined;

    const result = await checkForUpdates(remote, branch);
    return res.status(200).json(result);
  } catch (err: any) {
    console.error("Error checking git updates:", err);
    return res.status(500).json({ error: err.message || "Failed to check for updates" });
  }
}
