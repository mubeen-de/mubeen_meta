import React, { useState, useEffect, useRef } from "react";
import Head from "next/head";
import { useRouter } from "next/router";
import { useAuthGuard, getApiBase, MeResponse } from "../lib/auth";
import Nav from "../components/Nav";

interface GitCommitItem {
  hash: string;
  shortHash: string;
  message: string;
  author: string;
  date: string;
}

interface GitStatusInfo {
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

interface UpdateCheckResult {
  remote: string;
  branch: string;
  isUpToDate: boolean;
  behindCount: number;
  aheadCount: number;
  incomingCommits: GitCommitItem[];
  message: string;
  error?: string;
}

interface PullResult {
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

interface PullLogSummary {
  filename: string;
  timestamp: string;
  sizeBytes: number;
}

export default function AppUpdatePage() {
  const router = useRouter();
  const { me, loading: authLoading } = useAuthGuard();

  const [status, setStatus] = useState<GitStatusInfo | null>(null);
  const [loadingStatus, setLoadingStatus] = useState<boolean>(true);
  const [statusError, setStatusError] = useState<string | null>(null);

  // Form controls
  const [selectedBranch, setSelectedBranch] = useState<string>("");
  const [selectedRemote, setSelectedRemote] = useState<string>("origin");
  const [autoStash, setAutoStash] = useState<boolean>(true);

  // Actions state
  const [checkingUpdates, setCheckingUpdates] = useState<boolean>(false);
  const [checkResult, setCheckResult] = useState<UpdateCheckResult | null>(null);

  const [pulling, setPulling] = useState<boolean>(false);
  const [pullResult, setPullResult] = useState<PullResult | null>(null);
  const [showConfirmModal, setShowConfirmModal] = useState<boolean>(false);

  // Terminal Logs
  const [terminalLogs, setTerminalLogs] = useState<string[]>([]);
  const terminalEndRef = useRef<HTMLDivElement>(null);

  // History & Log files
  const [pullLogs, setPullLogs] = useState<PullLogSummary[]>([]);
  const [viewingLogFile, setViewingLogFile] = useState<{ filename: string; content: string } | null>(null);
  const [loadingLogContent, setLoadingLogContent] = useState<boolean>(false);

  const [copiedHash, setCopiedHash] = useState<boolean>(false);
  const [lastCheckTime, setLastCheckTime] = useState<string>("");

  const appendLog = (msg: string) => {
    const time = new Date().toLocaleTimeString();
    setTerminalLogs((prev) => [...prev, `[${time}] ${msg}`]);
  };

  // 1. Load initial status
  const loadStatus = async () => {
    setLoadingStatus(true);
    setStatusError(null);
    try {
      // Try Next.js local API route first, fall back to backend API if needed
      let res = await fetch("/api/system-update/status");
      if (!res.ok) {
        const apiBase = getApiBase();
        res = await fetch(`${apiBase}/admin/system/update/status`);
      }
      if (!res.ok) {
        throw new Error(`Failed to load status (HTTP ${res.status})`);
      }
      const data: GitStatusInfo = await res.json();
      setStatus(data);
      if (!selectedBranch) {
        setSelectedBranch(data.branch || "main");
      }
      if (data.remotes.length > 0 && !selectedRemote) {
        setSelectedRemote(data.remotes[0].name || "origin");
      }
      setLastCheckTime(new Date().toLocaleTimeString());
      appendLog(`Repository loaded: branch=${data.branch}, commit=${data.commitShortHash}`);
    } catch (err: any) {
      console.error(err);
      setStatusError(err.message || "Failed to load Git repository status");
      appendLog(`[ERROR] Could not query repository status: ${err.message}`);
    } finally {
      setLoadingStatus(false);
    }
  };

  // 2. Load historical logs list
  const loadPullLogs = async () => {
    try {
      let res = await fetch("/api/system-update/logs");
      if (!res.ok) {
        const apiBase = getApiBase();
        res = await fetch(`${apiBase}/admin/system/update/logs`);
      }
      if (res.ok) {
        const data = await res.json();
        if (Array.isArray(data.logs)) {
          setPullLogs(data.logs);
        }
      }
    } catch {
      // non-blocking
    }
  };

  useEffect(() => {
    loadStatus();
    loadPullLogs();
  }, []);

  useEffect(() => {
    if (terminalEndRef.current) {
      terminalEndRef.current.scrollIntoView({ behavior: "smooth" });
    }
  }, [terminalLogs]);

  // Check for updates
  const handleCheckUpdates = async () => {
    setCheckingUpdates(true);
    setCheckResult(null);
    appendLog(`Checking remote updates on ${selectedRemote}/${selectedBranch || status?.branch}...`);

    try {
      const payload = {
        remote: selectedRemote || "origin",
        branch: selectedBranch || status?.branch || "main",
      };

      let res = await fetch("/api/system-update/check", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      });

      if (!res.ok) {
        const apiBase = getApiBase();
        res = await fetch(`${apiBase}/admin/system/update/check`, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(payload),
        });
      }

      const data: UpdateCheckResult = await res.json();
      setCheckResult(data);
      setLastCheckTime(new Date().toLocaleTimeString());

      if (data.isUpToDate) {
        appendLog(`[CHECK] System is already UP TO DATE with ${data.remote}/${data.branch}.`);
      } else {
        appendLog(`[ALERT] Found ${data.behindCount} new commit(s) ready to pull from ${data.remote}/${data.branch}!`);
      }
    } catch (err: any) {
      appendLog(`[ERROR] Update check failed: ${err.message}`);
    } finally {
      setCheckingUpdates(false);
    }
  };

  // Trigger Git Pull & Upgrade
  const executePull = async () => {
    setShowConfirmModal(false);
    setPulling(true);
    setPullResult(null);

    const targetBranch = selectedBranch || status?.branch || "main";
    const targetRemote = selectedRemote || "origin";

    appendLog(`=======================================================`);
    appendLog(`STARTING APP UPGRADE: Pulling from ${targetRemote}/${targetBranch}...`);
    if (autoStash && status?.hasLocalChanges) {
      appendLog(`[STASH] Auto-stashing ${status.localChangesCount} uncommitted local modifications...`);
    }

    try {
      const payload = {
        remote: targetRemote,
        branch: targetBranch,
        stash: autoStash,
      };

      let res = await fetch("/api/system-update/pull", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      });

      if (!res.ok) {
        const apiBase = getApiBase();
        res = await fetch(`${apiBase}/admin/system/update/pull`, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(payload),
        });
      }

      const data: PullResult = await res.json();
      setPullResult(data);

      if (data.success) {
        appendLog(`[SUCCESS] Git pull completed in ${data.durationMs}ms!`);
        if (data.stashed) {
          appendLog(`[STASH] Local modifications were safely stashed before update.`);
        }
        if (data.previousCommit !== data.newCommit) {
          appendLog(`[UPDATE] Updated HEAD: ${data.previousCommit.slice(0, 7)} -> ${data.newCommit.slice(0, 7)}`);
          if (data.changedFiles && data.changedFiles.length > 0) {
            appendLog(`[FILES] ${data.changedFiles.length} files were updated:`);
            data.changedFiles.slice(0, 10).forEach((f) => appendLog(`  - ${f}`));
            if (data.changedFiles.length > 10) {
              appendLog(`  ...and ${data.changedFiles.length - 10} more files`);
            }
          }
        } else {
          appendLog(`[INFO] No new commits needed to be fetched. Current code is latest.`);
        }
        appendLog(`[LOG] Saved full execution log to: ${data.logFile}`);
        appendLog(`[NOTICE] Please click 'Reload Application' to load the new build assets.`);
      } else {
        appendLog(`[FAILED] Pull failed: ${data.error || "Unknown error"}`);
        if (data.stderr) {
          appendLog(`[GIT STDERR] ${data.stderr}`);
        }
      }

      // Refresh repository status and logs
      loadStatus();
      loadPullLogs();
    } catch (err: any) {
      appendLog(`[FATAL ERROR] Pull request failed: ${err.message}`);
      setPullResult({
        success: false,
        message: "Network or server failure during pull operation.",
        stdout: "",
        stderr: err.message,
        logFile: "",
        previousCommit: "",
        newCommit: "",
        changedFiles: [],
        durationMs: 0,
        stashed: false,
        error: err.message,
      });
    } finally {
      setPulling(false);
    }
  };

  // View historical log file
  const handleViewLogFile = async (filename: string) => {
    setLoadingLogContent(true);
    setViewingLogFile(null);
    try {
      let res = await fetch(`/api/system-update/logs?file=${encodeURIComponent(filename)}`);
      if (!res.ok) {
        const apiBase = getApiBase();
        res = await fetch(`${apiBase}/admin/system/update/logs?file=${encodeURIComponent(filename)}`);
      }
      if (res.ok) {
        const data = await res.json();
        setViewingLogFile({ filename, content: data.content });
      } else {
        alert("Could not load log file contents.");
      }
    } catch {
      alert("Failed to fetch log file.");
    } finally {
      setLoadingLogContent(false);
    }
  };

  const copyCommitHash = () => {
    if (status?.commitHash) {
      navigator.clipboard.writeText(status.commitHash);
      setCopiedHash(true);
      setTimeout(() => setCopiedHash(false), 2000);
    }
  };

  const copyTerminalOutput = () => {
    if (terminalLogs.length > 0) {
      navigator.clipboard.writeText(terminalLogs.join("\n"));
      alert("Terminal logs copied to clipboard!");
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

  return (
    <div className="admin-app">
      <Head>
        <title>KapMeta POS - App Update & Upgrade Center</title>
        <meta
          name="description"
          content="Pull application updates, upgrade the POS system, and synchronize code from GitHub repository."
        />
      </Head>

      <div style={{ display: "flex", flex: 1, minHeight: 0 }}>
        <Nav variant="sidebar" />

        <div style={{ flex: 1, display: "flex", flexDirection: "column", minWidth: 0, overflowY: "auto" }}>
          {/* Topbar */}
          <header className="topbar">
            <div className="topbar-left">
              <div className="brand-badge">
                <span className="brand-icon">⚡</span>
                <span className="brand-name">KapMeta System Updates</span>
              </div>
            </div>

            <div className="topbar-right">
              <div className="user-profile-badge">
                <div className="avatar-circle">{initials}</div>
                <div className="user-info-text">
                  <span className="user-name">{me?.name ?? "Admin"}</span>
                  <span className="user-role">{me?.roles?.[0] ?? "System Operator"}</span>
                </div>
              </div>
            </div>
          </header>

          {/* Main Dashboard Body */}
          <main className="dashboard-body" style={{ padding: "24px", maxWidth: "1280px", margin: "0 auto", width: "100%" }}>
            {authLoading && (
              <div className="empty-state-card">
                <span className="empty-icon">🔐</span>
                <h3>Authenticating session...</h3>
              </div>
            )}

            {!authLoading && (
              <>
                {/* 1. Header Banner */}
                <div className="update-header-card">
                  <div className="header-text-block">
                    <div className="header-pill-badge">
                      <span className="badge-dot"></span>
                      <span>App Lifecycle & GitHub Sync</span>
                    </div>
                    <h1 className="header-title">App Update & Upgrade Center</h1>
                    <p className="header-desc">
                      Keep KapMeta POS updated with the latest features, security patches, and performance optimizations.
                      Click the <strong>Pull Updates</strong> button below to upgrade your application directly from GitHub.
                    </p>
                  </div>

                  <div className="header-status-box">
                    <div className="status-metric">
                      <span className="metric-label">Active Branch</span>
                      <span className="metric-val branch-tag">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
                          <line x1="6" y1="3" x2="6" y2="15"></line>
                          <circle cx="18" cy="6" r="3"></circle>
                          <circle cx="6" cy="18" r="3"></circle>
                          <path d="M18 9a9 9 0 0 1-9 9"></path>
                        </svg>
                        {status?.branch || "Loading..."}
                      </span>
                    </div>

                    <div className="status-metric">
                      <span className="metric-label">Current Commit</span>
                      <div className="metric-val commit-row">
                        <code className="commit-code">{status?.commitShortHash || "—"}</code>
                        <button
                          type="button"
                          className="copy-btn"
                          onClick={copyCommitHash}
                          title="Copy Full Commit SHA"
                        >
                          {copiedHash ? "✓" : "📋"}
                        </button>
                      </div>
                    </div>

                    <div className="status-metric">
                      <span className="metric-label">App Version</span>
                      <span className="metric-val version-tag">v{status?.appVersion || "1.0.0"}</span>
                    </div>
                  </div>
                </div>

                {/* 2. Success Banner (after pull) */}
                {pullResult && pullResult.success && (
                  <div className="success-banner-card">
                    <div className="success-icon-box">🎉</div>
                    <div className="success-info">
                      <h3>Application Upgraded Successfully!</h3>
                      <p>{pullResult.message}</p>
                      {pullResult.previousCommit !== pullResult.newCommit && (
                        <div className="success-stats">
                          <span>Previous: <code>{pullResult.previousCommit.slice(0, 7)}</code></span>
                          <span>→</span>
                          <span>New: <code>{pullResult.newCommit.slice(0, 7)}</code></span>
                          {pullResult.changedFiles.length > 0 && (
                            <span className="files-tag">{pullResult.changedFiles.length} files updated</span>
                          )}
                        </div>
                      )}
                    </div>
                    <div className="success-actions">
                      <button
                        type="button"
                        className="btn-reload"
                        onClick={() => window.location.reload()}
                      >
                        🔄 Reload Application Now
                      </button>
                    </div>
                  </div>
                )}

                {/* 3. Hero Action Card: Pull & Upgrade */}
                <div className="hero-pull-card">
                  <div className="hero-left">
                    <div className="cta-icon-circle">
                      <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
                        <polyline points="7 10 12 15 17 10"></polyline>
                        <line x1="12" y1="15" x2="12" y2="3"></line>
                        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                      </svg>
                    </div>
                    <div className="cta-titles">
                      <h2>1-Click Software Upgrade</h2>
                      <p>
                        Pulls the latest code from GitHub into your running environment, updates assets, and logs the output.
                      </p>
                    </div>
                  </div>

                  <div className="hero-right">
                    <button
                      type="button"
                      className="btn-check-updates"
                      onClick={handleCheckUpdates}
                      disabled={checkingUpdates || pulling}
                    >
                      {checkingUpdates ? (
                        <>
                          <span className="spinner-sm"></span> Checking GitHub...
                        </>
                      ) : (
                        <>
                          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                            <circle cx="11" cy="11" r="8"></circle>
                            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                          </svg>
                          Check for Updates
                        </>
                      )}
                    </button>

                    <button
                      type="button"
                      className="btn-pull-upgrade"
                      onClick={() => setShowConfirmModal(true)}
                      disabled={pulling || checkingUpdates}
                    >
                      {pulling ? (
                        <>
                          <span className="spinner-sm"></span> Pulling & Upgrading...
                        </>
                      ) : (
                        <>
                          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
                            <polyline points="8 17 12 21 16 17"></polyline>
                            <line x1="12" y1="12" x2="12" y2="21"></line>
                            <path d="M20.88 18.09A5 5 0 0 0 18 9h-1.26A8 8 0 1 0 3 16.29"></path>
                          </svg>
                          Pull Latest Updates & Upgrade
                        </>
                      )}
                    </button>
                  </div>
                </div>

                {/* 4. Controls & Options Bar */}
                <div className="controls-options-bar">
                  <div className="control-group">
                    <label className="ctrl-label">Target Branch</label>
                    <select
                      className="ctrl-select"
                      value={selectedBranch}
                      onChange={(e) => setSelectedBranch(e.target.value)}
                      disabled={pulling}
                    >
                      {status?.branches && status.branches.length > 0 ? (
                        status.branches.map((b) => (
                          <option key={b} value={b}>
                            {b} {b === status.branch ? "(active)" : ""}
                          </option>
                        ))
                      ) : (
                        <option value={status?.branch || "main"}>{status?.branch || "main"}</option>
                      )}
                    </select>
                  </div>

                  <div className="control-group">
                    <label className="ctrl-label">Remote Repository</label>
                    <select
                      className="ctrl-select"
                      value={selectedRemote}
                      onChange={(e) => setSelectedRemote(e.target.value)}
                      disabled={pulling}
                    >
                      {status?.remotes && status.remotes.length > 0 ? (
                        status.remotes.map((r) => (
                          <option key={r.name} value={r.name}>
                            {r.name}
                          </option>
                        ))
                      ) : (
                        <option value="origin">origin</option>
                      )}
                    </select>
                  </div>

                  <div className="control-group toggle-group">
                    <label className="toggle-label" title="Safely stashes any uncommitted local code tweaks so git pull does not fail">
                      <input
                        type="checkbox"
                        checked={autoStash}
                        onChange={(e) => setAutoStash(e.target.checked)}
                        disabled={pulling}
                      />
                      <span>Auto-stash local changes before pull</span>
                    </label>
                  </div>

                  {lastCheckTime && (
                    <div className="last-check-tag">
                      Last Checked: <strong>{lastCheckTime}</strong>
                    </div>
                  )}
                </div>

                {/* Check Result Banner if available */}
                {checkResult && (
                  <div className={`check-result-card ${checkResult.isUpToDate ? "up-to-date" : "has-updates"}`}>
                    <div className="check-res-icon">
                      {checkResult.isUpToDate ? "✅" : "🔔"}
                    </div>
                    <div className="check-res-body">
                      <h4>{checkResult.message}</h4>
                      {checkResult.incomingCommits.length > 0 && (
                        <div className="incoming-commits-list">
                          <p className="incoming-title">Commits waiting to be pulled:</p>
                          {checkResult.incomingCommits.map((c) => (
                            <div key={c.hash} className="incoming-commit-row">
                              <code>{c.shortHash}</code>
                              <span className="incoming-msg">{c.message}</span>
                              <span className="incoming-author">by {c.author}</span>
                            </div>
                          ))}
                        </div>
                      )}
                    </div>
                    {!checkResult.isUpToDate && (
                      <button
                        type="button"
                        className="btn-pull-now-inline"
                        onClick={() => setShowConfirmModal(true)}
                        disabled={pulling}
                      >
                        📥 Pull Now
                      </button>
                    )}
                  </div>
                )}

                {/* 5. Live Terminal Console Box */}
                <div className="terminal-container">
                  <div className="terminal-header">
                    <div className="terminal-dots">
                      <span className="dot red"></span>
                      <span className="dot yellow"></span>
                      <span className="dot green"></span>
                    </div>
                    <div className="terminal-title">
                      <span>KapMeta Upgrade Console • git pull</span>
                    </div>
                    <div className="terminal-actions">
                      <button type="button" className="term-btn" onClick={copyTerminalOutput}>
                        Copy Logs
                      </button>
                      <button
                        type="button"
                        className="term-btn"
                        onClick={() => setTerminalLogs([])}
                      >
                        Clear
                      </button>
                    </div>
                  </div>

                  <div className="terminal-screen">
                    {terminalLogs.length === 0 ? (
                      <div className="terminal-empty">
                        <span>Console ready. Click <strong>"Check for Updates"</strong> or <strong>"Pull Latest Updates & Upgrade"</strong> above to begin.</span>
                      </div>
                    ) : (
                      terminalLogs.map((log, idx) => {
                        let colorClass = "term-normal";
                        if (log.includes("[SUCCESS]")) colorClass = "term-success";
                        if (log.includes("[ERROR]") || log.includes("[FAILED]")) colorClass = "term-error";
                        if (log.includes("[ALERT]")) colorClass = "term-alert";
                        if (log.includes("[STASH]") || log.includes("[NOTICE]")) colorClass = "term-info";

                        return (
                          <div key={idx} className={`term-line ${colorClass}`}>
                            {log}
                          </div>
                        );
                      })
                    )}
                    <div ref={terminalEndRef} />
                  </div>
                </div>

                {/* 6. Telemetry & History Grid */}
                <div className="telemetry-grid">
                  {/* Left Column: Local Working Tree & System Status */}
                  <div className="telemetry-card">
                    <div className="card-head">
                      <h3>Working Tree Health</h3>
                      {status?.hasLocalChanges ? (
                        <span className="badge-warn">{status.localChangesCount} Uncommitted Files</span>
                      ) : (
                        <span className="badge-clean">Clean Working Tree</span>
                      )}
                    </div>

                    <div className="working-tree-body">
                      {status?.hasLocalChanges ? (
                        <>
                          <p className="working-tree-hint">
                            The following files have local edits. With <strong>Auto-stash</strong> enabled, they will be preserved safely:
                          </p>
                          <ul className="dirty-files-list">
                            {status.localChanges.map((f, i) => (
                              <li key={i}>
                                <span className="status-code">{f.status}</span>
                                <span className="file-name">{f.file}</span>
                              </li>
                            ))}
                          </ul>
                        </>
                      ) : (
                        <p className="clean-hint">
                          ✓ Working directory is completely clean and synchronized. Ready for seamless pull.
                        </p>
                      )}

                      <div className="sys-metrics-list">
                        <div className="sys-row">
                          <span>Remote URL:</span>
                          <code>{status?.remoteUrl || "—"}</code>
                        </div>
                        <div className="sys-row">
                          <span>Node Runtime:</span>
                          <strong>{status?.nodeVersion || process.version}</strong>
                        </div>
                        <div className="sys-row">
                          <span>Server Platform:</span>
                          <strong>{status?.platform || "win32"}</strong>
                        </div>
                        <div className="sys-row">
                          <span>Process Uptime:</span>
                          <strong>{status ? `${Math.floor(status.serverUptime / 60)} min` : "—"}</strong>
                        </div>
                      </div>
                    </div>
                  </div>

                  {/* Right Column: Historical Pull Logs */}
                  <div className="telemetry-card">
                    <div className="card-head">
                      <h3>Recent Upgrade Logs</h3>
                      <button
                        type="button"
                        className="btn-refresh-logs"
                        onClick={loadPullLogs}
                        title="Refresh Logs List"
                      >
                        ↻ Refresh
                      </button>
                    </div>

                    <div className="logs-list-body">
                      {pullLogs.length === 0 ? (
                        <p className="no-logs-hint">No past upgrade log files recorded yet.</p>
                      ) : (
                        <div className="logs-table-wrap">
                          <table className="logs-table">
                            <thead>
                              <tr>
                                <th>Log File</th>
                                <th>Date & Time</th>
                                <th>Size</th>
                                <th>Action</th>
                              </tr>
                            </thead>
                            <tbody>
                              {pullLogs.slice(0, 7).map((log) => (
                                <tr key={log.filename}>
                                  <td>
                                    <code className="log-name">{log.filename}</code>
                                  </td>
                                  <td>{new Date(log.timestamp).toLocaleString()}</td>
                                  <td>{(log.sizeBytes / 1024).toFixed(1)} KB</td>
                                  <td>
                                    <button
                                      type="button"
                                      className="btn-view-log"
                                      onClick={() => handleViewLogFile(log.filename)}
                                    >
                                      View
                                    </button>
                                  </td>
                                </tr>
                              ))}
                            </tbody>
                          </table>
                        </div>
                      )}
                    </div>
                  </div>
                </div>

                {/* 7. Recent 5 Commits Timeline */}
                <div className="timeline-section-card">
                  <div className="card-head">
                    <h3>Recent Repository Commits (Deployment History)</h3>
                    <span className="commit-counter">{status?.recentCommits?.length || 0} recent commits</span>
                  </div>

                  <div className="commits-timeline">
                    {status?.recentCommits?.map((commit, idx) => (
                      <div key={commit.hash || idx} className="timeline-item">
                        <div className="timeline-marker">
                          <span className="marker-dot"></span>
                          {idx < (status.recentCommits.length - 1) && <span className="marker-line"></span>}
                        </div>
                        <div className="timeline-content">
                          <div className="commit-meta-line">
                            <code className="commit-sha">{commit.shortHash}</code>
                            <span className="commit-date">{commit.date}</span>
                            <span className="commit-author">by <strong>{commit.author}</strong></span>
                          </div>
                          <div className="commit-msg">{commit.message}</div>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              </>
            )}
          </main>
        </div>
      </div>

      {/* Confirmation Modal */}
      {showConfirmModal && (
        <div className="modal-backdrop">
          <div className="confirm-modal-box">
            <div className="modal-head">
              <span className="modal-icon">⚠️</span>
              <h3>Confirm App Upgrade</h3>
            </div>
            <div className="modal-body">
              <p>
                Are you sure you want to pull updates from GitHub repository?
              </p>
              <div className="modal-details-card">
                <div><strong>Remote:</strong> {selectedRemote || "origin"}</div>
                <div><strong>Branch:</strong> {selectedBranch || status?.branch || "main"}</div>
                <div><strong>Auto-Stash:</strong> {autoStash ? "Yes (Safely preserve local edits)" : "No"}</div>
              </div>
              <p className="modal-warning-sub">
                The terminal will pull latest commits and reload app assets. Active customer billing sessions won't be disrupted.
              </p>
            </div>
            <div className="modal-footer">
              <button
                type="button"
                className="btn-modal-cancel"
                onClick={() => setShowConfirmModal(false)}
              >
                Cancel
              </button>
              <button
                type="button"
                className="btn-modal-confirm"
                onClick={executePull}
              >
                Yes, Pull & Upgrade Now
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Log File Viewer Modal */}
      {viewingLogFile && (
        <div className="modal-backdrop" onClick={() => setViewingLogFile(null)}>
          <div className="log-viewer-modal-box" onClick={(e) => e.stopPropagation()}>
            <div className="modal-head">
              <span className="modal-icon">📄</span>
              <h3>Log File: {viewingLogFile.filename}</h3>
              <button
                type="button"
                className="btn-modal-close"
                onClick={() => setViewingLogFile(null)}
              >
                ✕
              </button>
            </div>
            <div className="modal-log-body">
              <pre>{viewingLogFile.content}</pre>
            </div>
            <div className="modal-footer">
              <button
                type="button"
                className="btn-modal-confirm"
                onClick={() => {
                  navigator.clipboard.writeText(viewingLogFile.content);
                  alert("Log content copied!");
                }}
              >
                📋 Copy All Content
              </button>
              <button
                type="button"
                className="btn-modal-cancel"
                onClick={() => setViewingLogFile(null)}
              >
                Close
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Page CSS Styles */}
      <style jsx>{`
        .admin-app {
          display: flex;
          height: 100vh;
          width: 100vw;
          background: #f8fafc;
          font-family: "Inter", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
          overflow: hidden;
        }

        .topbar {
          height: 56px;
          min-height: 56px;
          background: #ffffff;
          border-bottom: 1px solid #e2e8f0;
          display: flex;
          align-items: center;
          justify-content: space-between;
          padding: 0 24px;
        }

        .topbar-left {
          display: flex;
          align-items: center;
          gap: 12px;
        }

        .brand-badge {
          display: flex;
          align-items: center;
          gap: 8px;
          font-weight: 700;
          font-size: 1rem;
          color: #0f172a;
        }

        .brand-icon {
          font-size: 1.2rem;
        }

        .topbar-right {
          display: flex;
          align-items: center;
        }

        .user-profile-badge {
          display: flex;
          align-items: center;
          gap: 10px;
        }

        .avatar-circle {
          width: 32px;
          height: 32px;
          border-radius: 50%;
          background: #2563eb;
          color: #ffffff;
          font-weight: 700;
          font-size: 0.8rem;
          display: flex;
          align-items: center;
          justify-content: center;
        }

        .user-info-text {
          display: flex;
          flex-direction: column;
        }

        .user-name {
          font-size: 0.85rem;
          font-weight: 600;
          color: #0f172a;
        }

        .user-role {
          font-size: 0.75rem;
          color: #64748b;
        }

        /* Header Card */
        .update-header-card {
          background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
          border-radius: 16px;
          padding: 28px 32px;
          color: #ffffff;
          display: flex;
          justify-content: space-between;
          align-items: center;
          gap: 24px;
          box-shadow: 0 10px 25px -5px rgba(15, 23, 42, 0.2);
          margin-bottom: 24px;
        }

        .header-text-block {
          max-width: 650px;
        }

        .header-pill-badge {
          display: inline-flex;
          align-items: center;
          gap: 8px;
          background: rgba(255, 255, 255, 0.1);
          padding: 4px 12px;
          border-radius: 9999px;
          font-size: 0.78rem;
          font-weight: 600;
          letter-spacing: 0.02em;
          color: #93c5fd;
          margin-bottom: 12px;
        }

        .badge-dot {
          width: 8px;
          height: 8px;
          border-radius: 50%;
          background: #38bdf8;
          box-shadow: 0 0 8px #38bdf8;
        }

        .header-title {
          font-size: 1.8rem;
          font-weight: 800;
          margin: 0 0 8px 0;
          letter-spacing: -0.02em;
        }

        .header-desc {
          margin: 0;
          font-size: 0.92rem;
          color: #cbd5e1;
          line-height: 1.5;
        }

        .header-status-box {
          background: rgba(255, 255, 255, 0.05);
          border: 1px solid rgba(255, 255, 255, 0.1);
          border-radius: 12px;
          padding: 16px 20px;
          display: flex;
          flex-direction: column;
          gap: 12px;
          min-width: 240px;
        }

        .status-metric {
          display: flex;
          justify-content: space-between;
          align-items: center;
        }

        .metric-label {
          font-size: 0.8rem;
          color: #94a3b8;
          font-weight: 500;
        }

        .metric-val {
          font-size: 0.85rem;
          font-weight: 600;
          color: #ffffff;
        }

        .branch-tag {
          display: inline-flex;
          align-items: center;
          gap: 6px;
          background: rgba(37, 99, 235, 0.2);
          color: #60a5fa;
          padding: 2px 8px;
          border-radius: 6px;
          border: 1px solid rgba(96, 165, 250, 0.3);
        }

        .version-tag {
          background: rgba(16, 185, 129, 0.2);
          color: #34d399;
          padding: 2px 8px;
          border-radius: 6px;
          border: 1px solid rgba(52, 211, 153, 0.3);
        }

        .commit-row {
          display: flex;
          align-items: center;
          gap: 6px;
        }

        .commit-code {
          background: rgba(0, 0, 0, 0.3);
          padding: 2px 6px;
          border-radius: 4px;
          font-family: monospace;
          color: #f1f5f9;
        }

        .copy-btn {
          background: transparent;
          border: none;
          cursor: pointer;
          font-size: 0.85rem;
          padding: 0;
          color: #cbd5e1;
        }

        /* Success Banner */
        .success-banner-card {
          background: #ecfdf5;
          border: 1px solid #10b981;
          border-radius: 12px;
          padding: 18px 24px;
          display: flex;
          align-items: center;
          gap: 18px;
          margin-bottom: 24px;
          box-shadow: 0 4px 12px rgba(16, 185, 129, 0.15);
        }

        .success-icon-box {
          font-size: 2rem;
        }

        .success-info h3 {
          margin: 0 0 4px 0;
          color: #065f46;
          font-size: 1.1rem;
          font-weight: 700;
        }

        .success-info p {
          margin: 0 0 6px 0;
          color: #047857;
          font-size: 0.9rem;
        }

        .success-stats {
          display: flex;
          align-items: center;
          gap: 8px;
          font-size: 0.85rem;
          color: #065f46;
        }

        .files-tag {
          background: #10b981;
          color: #ffffff;
          padding: 2px 8px;
          border-radius: 9999px;
          font-size: 0.75rem;
          font-weight: 600;
        }

        .btn-reload {
          background: #10b981;
          color: #ffffff;
          border: none;
          padding: 10px 20px;
          border-radius: 8px;
          font-weight: 700;
          cursor: pointer;
          font-size: 0.9rem;
          transition: all 0.2s;
          white-space: nowrap;
        }

        .btn-reload:hover {
          background: #059669;
          transform: translateY(-1px);
        }

        /* Hero Pull Card */
        .hero-pull-card {
          background: #ffffff;
          border: 1px solid #e2e8f0;
          border-radius: 16px;
          padding: 24px 28px;
          display: flex;
          align-items: center;
          justify-content: space-between;
          gap: 24px;
          margin-bottom: 20px;
          box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
        }

        .hero-left {
          display: flex;
          align-items: center;
          gap: 18px;
        }

        .cta-icon-circle {
          width: 54px;
          height: 54px;
          border-radius: 14px;
          background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
          color: #ffffff;
          display: flex;
          align-items: center;
          justify-content: center;
          box-shadow: 0 8px 16px -2px rgba(37, 99, 235, 0.35);
        }

        .cta-titles h2 {
          margin: 0 0 4px 0;
          font-size: 1.25rem;
          font-weight: 700;
          color: #0f172a;
        }

        .cta-titles p {
          margin: 0;
          font-size: 0.88rem;
          color: #64748b;
        }

        .hero-right {
          display: flex;
          align-items: center;
          gap: 14px;
        }

        .btn-check-updates {
          background: #f1f5f9;
          color: #334155;
          border: 1px solid #cbd5e1;
          padding: 12px 20px;
          border-radius: 10px;
          font-weight: 600;
          font-size: 0.9rem;
          cursor: pointer;
          display: inline-flex;
          align-items: center;
          gap: 8px;
          transition: all 0.2s;
        }

        .btn-check-updates:hover:not(:disabled) {
          background: #e2e8f0;
          color: #0f172a;
        }

        .btn-pull-upgrade {
          background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
          color: #ffffff;
          border: none;
          padding: 13px 26px;
          border-radius: 10px;
          font-weight: 700;
          font-size: 0.95rem;
          cursor: pointer;
          display: inline-flex;
          align-items: center;
          gap: 10px;
          box-shadow: 0 4px 14px rgba(37, 99, 235, 0.4);
          transition: all 0.2s;
        }

        .btn-pull-upgrade:hover:not(:disabled) {
          background: linear-gradient(135deg, #1d4ed8 0%, #1e40af 100%);
          transform: translateY(-1px);
          box-shadow: 0 6px 20px rgba(37, 99, 235, 0.5);
        }

        .btn-pull-upgrade:disabled, .btn-check-updates:disabled {
          opacity: 0.6;
          cursor: not-allowed;
        }

        .spinner-sm {
          width: 16px;
          height: 16px;
          border: 2px solid rgba(255, 255, 255, 0.3);
          border-top-color: #ffffff;
          border-radius: 50%;
          animation: spin 0.8s linear infinite;
        }

        @keyframes spin {
          to { transform: rotate(360deg); }
        }

        /* Controls bar */
        .controls-options-bar {
          background: #ffffff;
          border: 1px solid #e2e8f0;
          border-radius: 12px;
          padding: 14px 20px;
          display: flex;
          align-items: center;
          gap: 24px;
          flex-wrap: wrap;
          margin-bottom: 20px;
        }

        .control-group {
          display: flex;
          align-items: center;
          gap: 10px;
        }

        .ctrl-label {
          font-size: 0.85rem;
          font-weight: 600;
          color: #475569;
        }

        .ctrl-select {
          padding: 6px 12px;
          border: 1px solid #cbd5e1;
          border-radius: 8px;
          background: #f8fafc;
          font-size: 0.85rem;
          font-weight: 500;
          color: #0f172a;
        }

        .toggle-group {
          margin-left: 10px;
        }

        .toggle-label {
          display: inline-flex;
          align-items: center;
          gap: 8px;
          font-size: 0.85rem;
          font-weight: 500;
          color: #334155;
          cursor: pointer;
        }

        .last-check-tag {
          margin-left: auto;
          font-size: 0.8rem;
          color: #64748b;
        }

        /* Check Result Card */
        .check-result-card {
          border-radius: 12px;
          padding: 16px 20px;
          display: flex;
          align-items: center;
          gap: 16px;
          margin-bottom: 20px;
        }

        .check-result-card.up-to-date {
          background: #f0fdf4;
          border: 1px solid #86efac;
          color: #166534;
        }

        .check-result-card.has-updates {
          background: #fefce8;
          border: 1px solid #fde047;
          color: #854d0e;
        }

        .check-res-icon {
          font-size: 1.5rem;
        }

        .check-res-body h4 {
          margin: 0;
          font-size: 0.95rem;
          font-weight: 700;
        }

        .incoming-commits-list {
          margin-top: 8px;
        }

        .incoming-title {
          margin: 0 0 4px 0;
          font-size: 0.82rem;
          font-weight: 600;
        }

        .incoming-commit-row {
          display: flex;
          align-items: center;
          gap: 8px;
          font-size: 0.8rem;
          margin-bottom: 2px;
        }

        .incoming-commit-row code {
          background: rgba(0, 0, 0, 0.08);
          padding: 1px 4px;
          border-radius: 4px;
        }

        .incoming-author {
          opacity: 0.75;
        }

        .btn-pull-now-inline {
          margin-left: auto;
          background: #eab308;
          color: #000000;
          border: none;
          padding: 8px 16px;
          border-radius: 8px;
          font-weight: 700;
          font-size: 0.85rem;
          cursor: pointer;
        }

        /* Terminal Container */
        .terminal-container {
          background: #090d16;
          border: 1px solid #1e293b;
          border-radius: 14px;
          overflow: hidden;
          box-shadow: 0 8px 24px rgba(0, 0, 0, 0.25);
          margin-bottom: 24px;
        }

        .terminal-header {
          background: #0f172a;
          border-bottom: 1px solid #1e293b;
          padding: 10px 16px;
          display: flex;
          align-items: center;
          justify-content: space-between;
        }

        .terminal-dots {
          display: flex;
          align-items: center;
          gap: 6px;
        }

        .dot {
          width: 10px;
          height: 10px;
          border-radius: 50%;
        }

        .dot.red { background: #ef4444; }
        .dot.yellow { background: #f59e0b; }
        .dot.green { background: #10b981; }

        .terminal-title {
          font-size: 0.78rem;
          font-weight: 600;
          color: #94a3b8;
          font-family: monospace;
        }

        .terminal-actions {
          display: flex;
          gap: 8px;
        }

        .term-btn {
          background: rgba(255, 255, 255, 0.08);
          border: 1px solid rgba(255, 255, 255, 0.12);
          color: #cbd5e1;
          padding: 3px 10px;
          border-radius: 6px;
          font-size: 0.75rem;
          font-weight: 500;
          cursor: pointer;
        }

        .term-btn:hover {
          background: rgba(255, 255, 255, 0.15);
          color: #ffffff;
        }

        .terminal-screen {
          padding: 16px;
          max-height: 260px;
          min-height: 160px;
          overflow-y: auto;
          font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
          font-size: 0.82rem;
          line-height: 1.6;
        }

        .terminal-empty {
          color: #64748b;
          font-style: italic;
        }

        .term-line {
          word-break: break-all;
        }

        .term-normal { color: #cbd5e1; }
        .term-success { color: #4ade80; font-weight: 600; }
        .term-error { color: #f87171; font-weight: 600; }
        .term-alert { color: #facc15; font-weight: 600; }
        .term-info { color: #38bdf8; }

        /* Telemetry Grid */
        .telemetry-grid {
          display: grid;
          grid-template-columns: 1fr 1fr;
          gap: 20px;
          margin-bottom: 24px;
        }

        @media (max-width: 900px) {
          .telemetry-grid {
            grid-template-columns: 1fr;
          }
          .update-header-card {
            flex-direction: column;
            align-items: flex-start;
          }
          .hero-pull-card {
            flex-direction: column;
            align-items: flex-start;
          }
          .hero-right {
            width: 100%;
            justify-content: flex-start;
          }
        }

        .telemetry-card {
          background: #ffffff;
          border: 1px solid #e2e8f0;
          border-radius: 14px;
          padding: 20px 24px;
          box-shadow: 0 2px 4px rgba(0, 0, 0, 0.03);
        }

        .card-head {
          display: flex;
          align-items: center;
          justify-content: space-between;
          margin-bottom: 16px;
          border-bottom: 1px solid #f1f5f9;
          padding-bottom: 12px;
        }

        .card-head h3 {
          margin: 0;
          font-size: 1.05rem;
          font-weight: 700;
          color: #0f172a;
        }

        .badge-clean {
          background: #ecfdf5;
          color: #059669;
          padding: 3px 10px;
          border-radius: 9999px;
          font-size: 0.75rem;
          font-weight: 600;
        }

        .badge-warn {
          background: #fffbeb;
          color: #d97706;
          padding: 3px 10px;
          border-radius: 9999px;
          font-size: 0.75rem;
          font-weight: 600;
        }

        .working-tree-hint, .clean-hint {
          font-size: 0.85rem;
          color: #64748b;
          margin: 0 0 10px 0;
        }

        .dirty-files-list {
          list-style: none;
          padding: 0;
          margin: 0 0 16px 0;
          max-height: 100px;
          overflow-y: auto;
          background: #f8fafc;
          border: 1px solid #e2e8f0;
          border-radius: 8px;
        }

        .dirty-files-list li {
          display: flex;
          align-items: center;
          gap: 10px;
          padding: 6px 12px;
          border-bottom: 1px solid #f1f5f9;
          font-size: 0.8rem;
          font-family: monospace;
        }

        .dirty-files-list li:last-child {
          border-bottom: none;
        }

        .status-code {
          color: #d97706;
          font-weight: 700;
        }

        .file-name {
          color: #334155;
        }

        .sys-metrics-list {
          display: flex;
          flex-direction: column;
          gap: 8px;
          border-top: 1px solid #f1f5f9;
          padding-top: 12px;
        }

        .sys-row {
          display: flex;
          justify-content: space-between;
          font-size: 0.82rem;
          color: #475569;
        }

        .sys-row code {
          background: #f1f5f9;
          padding: 2px 6px;
          border-radius: 4px;
          max-width: 250px;
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
        }

        .btn-refresh-logs {
          background: transparent;
          border: 1px solid #cbd5e1;
          color: #475569;
          padding: 3px 8px;
          border-radius: 6px;
          font-size: 0.75rem;
          font-weight: 600;
          cursor: pointer;
        }

        .btn-refresh-logs:hover {
          background: #f1f5f9;
        }

        .logs-table-wrap {
          overflow-x: auto;
        }

        .logs-table {
          width: 100%;
          border-collapse: collapse;
          font-size: 0.8rem;
        }

        .logs-table th {
          text-align: left;
          padding: 6px 8px;
          background: #f8fafc;
          color: #64748b;
          font-weight: 600;
          border-bottom: 1px solid #e2e8f0;
        }

        .logs-table td {
          padding: 8px 8px;
          border-bottom: 1px solid #f1f5f9;
          color: #334155;
        }

        .log-name {
          font-family: monospace;
          color: #2563eb;
          font-size: 0.78rem;
        }

        .btn-view-log {
          background: #eff6ff;
          color: #2563eb;
          border: 1px solid #bfdbfe;
          padding: 2px 8px;
          border-radius: 4px;
          font-size: 0.75rem;
          font-weight: 600;
          cursor: pointer;
        }

        .btn-view-log:hover {
          background: #dbeafe;
        }

        .no-logs-hint {
          color: #94a3b8;
          font-size: 0.85rem;
          font-style: italic;
          margin: 0;
        }

        /* Timeline Card */
        .timeline-section-card {
          background: #ffffff;
          border: 1px solid #e2e8f0;
          border-radius: 14px;
          padding: 20px 24px;
          box-shadow: 0 2px 4px rgba(0, 0, 0, 0.03);
          margin-bottom: 30px;
        }

        .commit-counter {
          font-size: 0.8rem;
          color: #64748b;
        }

        .commits-timeline {
          display: flex;
          flex-direction: column;
          padding-left: 8px;
        }

        .timeline-item {
          display: flex;
          gap: 16px;
          position: relative;
        }

        .timeline-marker {
          display: flex;
          flex-direction: column;
          align-items: center;
          width: 16px;
        }

        .marker-dot {
          width: 10px;
          height: 10px;
          border-radius: 50%;
          background: #2563eb;
          box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.15);
          margin-top: 5px;
        }

        .marker-line {
          width: 2px;
          background: #e2e8f0;
          flex: 1;
          margin: 4px 0;
        }

        .timeline-content {
          padding-bottom: 18px;
          flex: 1;
        }

        .commit-meta-line {
          display: flex;
          align-items: center;
          gap: 10px;
          font-size: 0.78rem;
          margin-bottom: 4px;
        }

        .commit-sha {
          background: #f1f5f9;
          color: #0f172a;
          padding: 2px 6px;
          border-radius: 4px;
          font-weight: 700;
        }

        .commit-date {
          color: #64748b;
        }

        .commit-author {
          color: #475569;
        }

        .commit-msg {
          font-size: 0.88rem;
          font-weight: 500;
          color: #1e293b;
        }

        /* Modal Styles */
        .modal-backdrop {
          position: fixed;
          top: 0;
          left: 0;
          right: 0;
          bottom: 0;
          background: rgba(15, 23, 42, 0.65);
          backdrop-filter: blur(4px);
          display: flex;
          align-items: center;
          justify-content: center;
          z-index: 9999;
          padding: 20px;
        }

        .confirm-modal-box {
          background: #ffffff;
          border-radius: 16px;
          width: 100%;
          max-width: 460px;
          padding: 24px;
          box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.2);
        }

        .modal-head {
          display: flex;
          align-items: center;
          gap: 10px;
          margin-bottom: 14px;
        }

        .modal-head h3 {
          margin: 0;
          font-size: 1.15rem;
          color: #0f172a;
          font-weight: 700;
        }

        .modal-icon {
          font-size: 1.3rem;
        }

        .modal-body p {
          margin: 0 0 12px 0;
          font-size: 0.9rem;
          color: #334155;
          line-height: 1.5;
        }

        .modal-details-card {
          background: #f8fafc;
          border: 1px solid #e2e8f0;
          border-radius: 8px;
          padding: 12px 14px;
          font-size: 0.85rem;
          display: flex;
          flex-direction: column;
          gap: 4px;
          color: #1e293b;
          margin-bottom: 12px;
        }

        .modal-warning-sub {
          font-size: 0.8rem !important;
          color: #64748b !important;
        }

        .modal-footer {
          display: flex;
          justify-content: flex-end;
          gap: 10px;
          margin-top: 20px;
        }

        .btn-modal-cancel {
          background: #f1f5f9;
          color: #475569;
          border: 1px solid #cbd5e1;
          padding: 8px 16px;
          border-radius: 8px;
          font-weight: 600;
          font-size: 0.85rem;
          cursor: pointer;
        }

        .btn-modal-confirm {
          background: #2563eb;
          color: #ffffff;
          border: none;
          padding: 8px 18px;
          border-radius: 8px;
          font-weight: 600;
          font-size: 0.85rem;
          cursor: pointer;
        }

        .btn-modal-close {
          margin-left: auto;
          background: transparent;
          border: none;
          font-size: 1.1rem;
          cursor: pointer;
          color: #64748b;
        }

        .log-viewer-modal-box {
          background: #ffffff;
          border-radius: 14px;
          width: 100%;
          max-width: 820px;
          max-height: 80vh;
          display: flex;
          flex-direction: column;
          padding: 20px 24px;
          box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.2);
        }

        .modal-log-body {
          flex: 1;
          overflow-y: auto;
          background: #090d16;
          border-radius: 8px;
          padding: 16px;
          margin: 12px 0;
        }

        .modal-log-body pre {
          margin: 0;
          color: #38bdf8;
          font-family: monospace;
          font-size: 0.8rem;
          line-height: 1.5;
          white-space: pre-wrap;
        }
      `}</style>
    </div>
  );
}
