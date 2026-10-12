import type { NextApiRequest, NextApiResponse } from "next";
import { getGitStatus } from "../../../lib/gitUpdateService";

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method !== "GET") {
    res.setHeader("Allow", ["GET"]);
    return res.status(405).json({ error: `Method ${req.method} not allowed` });
  }

  try {
    const status = await getGitStatus();
    return res.status(200).json(status);
  } catch (err: any) {
    console.error("Error fetching git update status:", err);
    return res.status(500).json({ error: err.message || "Failed to fetch repository status" });
  }
}
