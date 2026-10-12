import type { NextApiRequest, NextApiResponse } from "next";
import { getRecentPullLogs, getPullLogContent } from "../../../lib/gitUpdateService";

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method !== "GET") {
    res.setHeader("Allow", ["GET"]);
    return res.status(405).json({ error: `Method ${req.method} not allowed` });
  }

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
    console.error("Error reading pull logs:", err);
    return res.status(500).json({ error: err.message || "Failed to fetch logs" });
  }
}
