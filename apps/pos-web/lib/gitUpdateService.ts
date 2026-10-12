import * as path from "path";
import * as fs from "fs";
import { execFile } from "child_process";

export interface GitCommitItem {
  hash: string;
  shortHash: string;
  message: string;
  author: string;
  date: string;
}

export interface GitStatusInfo {
  repoRoot: string;
  branch: string;
  commitHash: string;
  commitShortHash: string;
  commitMessage: string;
  commitAuthor: string;
  commitDate: string;
  remoteUrl: string;
  remotes: Array<{ name: string; url: string }>;
  branches: string[];
  hasLocalChanges: boolean;
  localChangesCount: number;
  localChanges: Array<{ status: string; file: string }>;
  recentCommits: GitCommitItem[];
  appVersion: string;
  serverTime: string;
  serverUptime: number;
  nodeVersion: string;
  platform: string;
}

export interface UpdateCheckResult {
  remote: string;
  branch: string;
  isUpToDate: boolean;
  behindCount: number;
  aheadCount: number;
  incomingCommits: GitCommitItem[];
  message: string;
  error?: string;
}

export interface PullResult {
  success: boolean;
  message: string;
  stdout: string;
  stderr: string;
  logFile: string;
  previousCommit: string;
  newCommit: string;
  changedFiles: string[];
  durationMs: number;
  stashed: boolean;
  error?: string;
}

export interface PullLogSummary {
  filename: string;
  timestamp: string;
  sizeBytes: number;
}

/**
 * Finds the Git repository root by walking up from the current directory.
 */
export function findRepoRoot(startDir: string = process.cwd()): string {
  let curr = path.resolve(startDir);
  while (curr && curr !== path.dirname(curr)) {
    if (fs.existsSync(path.join(curr, ".git"))) {
      return curr;
    }
    curr = path.dirname(curr);
  }
  const known = "c:\\Users\\BEST BUY\\Downloads\\PetPooja\\PetPooja";
  if (fs.existsSync(path.join(known, ".git"))) {
    return known;
  }
  return process.cwd();
}

/**
 * Executes a Git command in the given repository directory with a timeout.
 */
export function runGit(
  args: string[],
  cwd: string = findRepoRoot(),
  timeoutMs = 30000
): Promise<{ stdout: string; stderr: string; code: number }> {
  return new Promise((resolve) => {
    execFile(
      "git",
      args,
      { cwd, timeout: timeoutMs, maxBuffer: 10 * 1024 * 1024 },
      (error, stdout, stderr) => {
        resolve({
          stdout: stdout ? stdout.toString() : "",
          stderr: stderr ? stderr.toString() : "",
          code: error ? (typeof (error as any).code === "number" ? (error as any).code : 1) : 0,
        });
      }
    );
  });
}

/**
 * Sanitizes URLs to mask GitHub personal access tokens or credentials.
 */
export function sanitizeGitUrl(url: string): string {
  if (!url) return "";
  return url.replace(/https:\/\/[^@]+@/g, "https://");
}

/**
 * Formats a date into yyyyMMdd_HHmmss for log file names.
 */
function getTimestampString(): string {
  const now = new Date();
  const pad = (n: number) => String(n).padStart(2, "0");
  const yyyy = now.getFullYear();
  const MM = pad(now.getMonth() + 1);
  const dd = pad(now.getDate());
  const HH = pad(now.getHours());
  const mm = pad(now.getMinutes());
  const ss = pad(now.getSeconds());
  return `${yyyy}${MM}${dd}_${HH}${mm}${ss}`;
}

/**
 * Retrieves the full system and repository status.
 */
export async function getGitStatus(): Promise<GitStatusInfo> {
  const repoRoot = findRepoRoot();

  // 1. Current Branch
  const branchRes = await runGit(["rev-parse", "--abbrev-ref", "HEAD"], repoRoot);
  const branch = branchRes.stdout.trim() || "main";

  // 2. HEAD commit info
  const commitRes = await runGit(
    ["log", "-1", "--pretty=format:%H||%h||%s||%an||%ad"],
    repoRoot
  );
  let commitHash = "";
  let commitShortHash = "";
  let commitMessage = "";
  let commitAuthor = "";
  let commitDate = "";

  if (commitRes.code === 0 && commitRes.stdout.trim()) {
    const parts = commitRes.stdout.trim().split("||");
    commitHash = parts[0] || "";
    commitShortHash = parts[1] || "";
    commitMessage = parts[2] || "";
    commitAuthor = parts[3] || "";
    commitDate = parts[4] || "";
  }

  // 3. Remotes
  const remotesRes = await runGit(["remote", "-v"], repoRoot);
  const remotesMap = new Map<string, string>();
  if (remotesRes.code === 0) {
    const lines = remotesRes.stdout.split("\n");
    for (const line of lines) {
      const match = line.trim().match(/^([^\s]+)\s+([^\s]+)/);
      if (match) {
        remotesMap.set(match[1], sanitizeGitUrl(match[2]));
      }
    }
  }

  const remotes: Array<{ name: string; url: string }> = [];
  remotesMap.forEach((url, name) => {
    remotes.push({ name, url });
  });

  const originUrl = remotesMap.get("origin") || (remotes.length > 0 ? remotes[0].url : "");

  // 4. Branches list
  const branchesRes = await runGit(["branch", "--list"], repoRoot);
  const branches: string[] = [];
  if (branchesRes.code === 0) {
    const lines = branchesRes.stdout.split("\n");
    for (const line of lines) {
      const b = line.replace(/^\*?\s+/, "").trim();
      if (b && !branches.includes(b)) {
        branches.push(b);
      }
    }
  }

  // 5. Working tree local changes
  const statusRes = await runGit(["status", "--porcelain"], repoRoot);
  const localChanges: Array<{ status: string; file: string }> = [];
  if (statusRes.code === 0 && statusRes.stdout.trim()) {
    const lines = statusRes.stdout.split("\n");
    for (const line of lines) {
      if (line.trim()) {
        const statusCode = line.slice(0, 2).trim();
        const filePath = line.slice(3).trim();
        localChanges.push({ status: statusCode, file: filePath });
      }
    }
  }

  // 6. Recent 8 commits
  const recentRes = await runGit(
    ["log", "-n", "8", "--pretty=format:%H||%h||%s||%an||%ad"],
    repoRoot
  );
  const recentCommits: GitCommitItem[] = [];
  if (recentRes.code === 0 && recentRes.stdout.trim()) {
    const lines = recentRes.stdout.split("\n");
    for (const line of lines) {
      if (line.trim()) {
        const parts = line.split("||");
        recentCommits.push({
          hash: parts[0] || "",
          shortHash: parts[1] || "",
          message: parts[2] || "",
          author: parts[3] || "",
          date: parts[4] || "",
        });
      }
    }
  }

  // 7. App package.json version
  let appVersion = "1.0.0";
  try {
    const pkgPath = path.join(repoRoot, "package.json");
    if (fs.existsSync(pkgPath)) {
      const pkgData = JSON.parse(fs.readFileSync(pkgPath, "utf-8"));
      if (pkgData.version) appVersion = pkgData.version;
    }
  } catch {
    // fallback default
  }

  return {
    repoRoot,
    branch,
    commitHash,
    commitShortHash,
    commitMessage,
    commitAuthor,
    commitDate,
    remoteUrl: originUrl,
    remotes,
    branches,
    hasLocalChanges: localChanges.length > 0,
    localChangesCount: localChanges.length,
    localChanges,
    recentCommits,
    appVersion,
    serverTime: new Date().toISOString(),
    serverUptime: Math.floor(process.uptime()),
    nodeVersion: process.version,
    platform: process.platform,
  };
}

/**
 * Checks GitHub for updates (fetch + ahead/behind commit check).
 */
export async function checkForUpdates(
  remote = "origin",
  targetBranch?: string
): Promise<UpdateCheckResult> {
  const repoRoot = findRepoRoot();
  const currentBranch = targetBranch || (await runGit(["rev-parse", "--abbrev-ref", "HEAD"], repoRoot)).stdout.trim() || "main";

  // 1. Fetch from remote
  const fetchRes = await runGit(["fetch", remote, currentBranch, "--progress"], repoRoot, 25000);

  if (fetchRes.code !== 0) {
    // Check if branch exists on remote or if network error
    return {
      remote,
      branch: currentBranch,
      isUpToDate: true,
      behindCount: 0,
      aheadCount: 0,
      incomingCommits: [],
      message: `Could not fetch branch '${currentBranch}' from ${remote}.`,
      error: fetchRes.stderr || fetchRes.stdout || "Fetch failed",
    };
  }

  // 2. Count ahead and behind commits
  const upstream = `${remote}/${currentBranch}`;
  const countRes = await runGit(["rev-list", "--left-right", "--count", `HEAD...${upstream}`], repoRoot);

  let aheadCount = 0;
  let behindCount = 0;

  if (countRes.code === 0 && countRes.stdout.trim()) {
    const parts = countRes.stdout.trim().split(/\s+/);
    aheadCount = parseInt(parts[0], 10) || 0;
    behindCount = parseInt(parts[1], 10) || 0;
  }

  // 3. If behind, list the incoming commits
  const incomingCommits: GitCommitItem[] = [];
  if (behindCount > 0) {
    const logRes = await runGit(
      ["log", `HEAD..${upstream}`, "--pretty=format:%H||%h||%s||%an||%ad"],
      repoRoot
    );
    if (logRes.code === 0 && logRes.stdout.trim()) {
      const lines = logRes.stdout.split("\n");
      for (const line of lines) {
        if (line.trim()) {
          const parts = line.split("||");
          incomingCommits.push({
            hash: parts[0] || "",
            shortHash: parts[1] || "",
            message: parts[2] || "",
            author: parts[3] || "",
            date: parts[4] || "",
          });
        }
      }
    }
  }

  const isUpToDate = behindCount === 0;
  const message = isUpToDate
    ? `App is completely up to date with ${remote}/${currentBranch}.`
    : `Found ${behindCount} new update(s) ready to pull from ${remote}/${currentBranch}!`;

  return {
    remote,
    branch: currentBranch,
    isUpToDate,
    behindCount,
    aheadCount,
    incomingCommits,
    message,
  };
}

/**
 * Performs the actual Pull / Upgrade operation and logs the output.
 */
export async function pullUpdates(options: {
  remote?: string;
  branch?: string;
  stash?: boolean;
}): Promise<PullResult> {
  const startTime = Date.now();
  const repoRoot = findRepoRoot();
  const remote = options.remote || "origin";
  const branch = options.branch || (await runGit(["rev-parse", "--abbrev-ref", "HEAD"], repoRoot)).stdout.trim() || "main";
  const shouldStash = options.stash !== false; // default true

  // Ensure logs/git directory exists
  const logsDir = path.join(repoRoot, "logs", "git");
  if (!fs.existsSync(logsDir)) {
    fs.mkdirSync(logsDir, { recursive: true });
  }

  const dt = getTimestampString();
  const logFileName = `pull_${dt}.log`;
  const logFilePath = path.join(logsDir, logFileName);

  const prevCommit = (await runGit(["rev-parse", "HEAD"], repoRoot)).stdout.trim();

  let stashed = false;
  let stashOutput = "";

  // 1. Stash uncommitted changes if requested
  if (shouldStash) {
    const statusCheck = await runGit(["status", "--porcelain"], repoRoot);
    if (statusCheck.stdout.trim()) {
      const stashRes = await runGit(
        ["stash", "save", `Auto-stashed before App Upgrade at ${new Date().toISOString()}`],
        repoRoot
      );
      if (stashRes.code === 0) {
        stashed = true;
        stashOutput = stashRes.stdout;
      }
    }
  }

  // 2. Execute git pull
  const pullRes = await runGit(
    ["pull", remote, branch, "--progress", "--verbose"],
    repoRoot,
    60000
  );

  const newCommit = (await runGit(["rev-parse", "HEAD"], repoRoot)).stdout.trim();

  // 3. Get changed files
  const changedFiles: string[] = [];
  if (prevCommit && newCommit && prevCommit !== newCommit) {
    const diffRes = await runGit(
      ["diff", "--name-only", prevCommit, newCommit],
      repoRoot
    );
    if (diffRes.code === 0 && diffRes.stdout.trim()) {
      changedFiles.push(...diffRes.stdout.split("\n").map((f) => f.trim()).filter(Boolean));
    }
  }

  // 4. Build log content
  const durationMs = Date.now() - startTime;
  const humanDate = new Date().toLocaleString();
  const isSuccess = pullRes.code === 0;

  const logLines = [
    "=======================================================================",
    "              KAPMETA POS PLATFORM - GITHUB PULL LOG",
    "=======================================================================",
    `Timestamp      : ${humanDate}`,
    `Target Remote  : ${remote}`,
    `Target Branch  : ${branch}`,
    `Previous Commit: ${prevCommit}`,
    `New Commit     : ${newCommit}`,
    `Auto-Stashed   : ${stashed ? "YES (" + stashOutput.trim() + ")" : "NO"}`,
    `Execution Time : ${durationMs}ms`,
    `Exit Code      : ${pullRes.code}`,
    "=======================================================================",
    "",
    "--- GIT STDOUT ---",
    pullRes.stdout || "(none)",
    "",
    "--- GIT STDERR ---",
    pullRes.stderr || "(none)",
    "",
    "=======================================================================",
    isSuccess
      ? `[SUCCESS] LATEST UPDATES SUCCESSFULLY PULLED FROM GITHUB!`
      : `[FAILED] Pull encountered an error (Exit Code: ${pullRes.code}).`,
    "=======================================================================",
  ];

  fs.writeFileSync(logFilePath, logLines.join("\n"), "utf-8");

  return {
    success: isSuccess,
    message: isSuccess
      ? prevCommit === newCommit
        ? "Application is already up to date. No new commits were fetched."
        : `Successfully updated application! Pulled latest changes (${changedFiles.length} files updated).`
      : `Pull failed with exit code ${pullRes.code}. Check logs for details.`,
    stdout: pullRes.stdout,
    stderr: pullRes.stderr,
    logFile: logFileName,
    previousCommit: prevCommit,
    newCommit,
    changedFiles,
    durationMs,
    stashed,
    error: isSuccess ? undefined : pullRes.stderr || pullRes.stdout || "Git pull exited with an error.",
  };
}

/**
 * Lists past update log files from logs/git.
 */
export function getRecentPullLogs(): PullLogSummary[] {
  const repoRoot = findRepoRoot();
  const logsDir = path.join(repoRoot, "logs", "git");
  if (!fs.existsSync(logsDir)) return [];

  try {
    const files = fs.readdirSync(logsDir);
    const logs: PullLogSummary[] = [];

    for (const file of files) {
      if (file.startsWith("pull_") && file.endsWith(".log")) {
        const fullPath = path.join(logsDir, file);
        const stats = fs.statSync(fullPath);
        logs.push({
          filename: file,
          timestamp: stats.mtime.toISOString(),
          sizeBytes: stats.size,
        });
      }
    }

    return logs.sort((a, b) => (b.timestamp > a.timestamp ? 1 : -1)).slice(0, 20);
  } catch {
    return [];
  }
}

/**
 * Reads a specific pull log file's content.
 */
export function getPullLogContent(filename: string): string | null {
  const repoRoot = findRepoRoot();
  const sanitized = path.basename(filename); // avoid path traversal
  const filePath = path.join(repoRoot, "logs", "git", sanitized);

  if (!fs.existsSync(filePath)) return null;
  try {
    return fs.readFileSync(filePath, "utf-8");
  } catch {
    return null;
  }
}
