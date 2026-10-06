import React, { useEffect, useState } from "react";
import Head from "next/head";
import { authedFetch, useAuthGuard, getApiBase } from "../lib/auth";
import Nav from "../components/Nav";
import SimulateAggregatorModal from "../components/SimulateAggregatorModal";

interface ChannelAccount {
  id: string;
  channel: string;
  externalOutletId: string;
  status: "ACTIVE" | "PAUSED" | "REVOKED";
  connectedAt: string | null;
  hasCredentials: boolean;
}

// Only channels with a real adapter registered in services/integration-hub
// (packages/shared-types/channel.ts ChannelCode) show up here — adding a
// third card with no backend adapter would just be a dead button.
const SUPPORTED_CHANNELS = [
  { code: "SWIGGY", label: "Swiggy", color: "#fc8019", icon: "🧡" },
  { code: "ZOMATO", label: "Zomato", color: "#e23744", icon: "❤️" },
];

export default function Integrations() {
  const { loading: authLoading } = useAuthGuard("integration.manage");
  const [accounts, setAccounts] = useState<ChannelAccount[]>([]);
  const [loading, setLoading] = useState(true);
  const [connectingChannel, setConnectingChannel] = useState<string | null>(null);
  const [externalOutletId, setExternalOutletId] = useState("");
  const [apiKey, setApiKey] = useState("");
  const [apiSecret, setApiSecret] = useState("");
  const [saving, setSaving] = useState(false);
  const [formError, setFormError] = useState<string | null>(null);
  const [copiedChannel, setCopiedChannel] = useState<string | null>(null);
  const [simulatingChannel, setSimulatingChannel] = useState<"SWIGGY" | "ZOMATO" | null>(null);

  const fetchAccounts = async () => {
    try {
      const res = await authedFetch("/integration/integrations/channels");
      if (res.ok) setAccounts(await res.json());
    } catch (e) {
      console.error("Failed to fetch channel accounts", e);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (authLoading) return;
    fetchAccounts();
  }, [authLoading]);

  const openConnect = (channel: string) => {
    setConnectingChannel(channel);
    setExternalOutletId("");
    setApiKey("");
    setApiSecret("");
    setFormError(null);
  };

  const submitConnect = async () => {
    if (!connectingChannel) return;
    if (!externalOutletId || !apiKey || !apiSecret) {
      setFormError("All fields required");
      return;
    }
    setSaving(true);
    setFormError(null);
    try {
      const res = await authedFetch(`/integration/integrations/channels/${connectingChannel}/connect`, {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ externalOutletId, apiKey, apiSecret }),
      });
      if (res.ok) {
        setConnectingChannel(null);
        fetchAccounts();
      } else {
        const err = await res.json();
        setFormError(err.error || "Connect failed");
      }
    } catch (e) {
      setFormError("Network error connecting channel");
    } finally {
      setSaving(false);
    }
  };

  const disconnect = async (accountId: string) => {
    if (!confirm("Disconnect this channel? Menu mappings stay intact — you can reconnect any time.")) return;
    try {
      const res = await authedFetch(`/integration/integrations/channels/${accountId}/disconnect`, { method: "POST" });
      if (res.ok) fetchAccounts();
    } catch (e) {
      console.error("Failed to disconnect", e);
    }
  };

  const copyWebhookUrl = (channel: string) => {
    const url = `${getApiBase()}/webhooks/${channel.toLowerCase()}`;
    navigator.clipboard.writeText(url).then(() => {
      setCopiedChannel(channel);
      setTimeout(() => setCopiedChannel(null), 2000);
    });
  };

  if (authLoading) return null;

  return (
    <div style={{ minHeight: "100vh", display: "flex", background: "var(--bg-base, #0b132b)", color: "var(--text-primary, #f8fafc)" }}>
      <Head>
        <title>KapMeta POS - Connect Delivery Apps</title>
      </Head>
      <Nav variant="sidebar" />
      <div style={{ flex: 1, padding: 24, maxWidth: 760, margin: "0 auto", width: "100%" }}>
        <h1 style={{ fontSize: "1.25rem", fontWeight: 800, marginBottom: 4, color: "var(--text-primary, #f8fafc)" }}>Connect Delivery Apps</h1>
        <p style={{ fontSize: "0.8rem", color: "var(--text-secondary, #94a3b8)", marginBottom: 20 }}>
          Link Swiggy/Zomato so their orders drop straight into Live Orders and fire to the kitchen automatically.
        </p>

        {loading ? (
          <p style={{ fontSize: "0.8rem", color: "var(--text-muted, #64748b)" }}>Loading...</p>
        ) : (
          <div style={{ display: "flex", flexDirection: "column", gap: 12 }}>
            {SUPPORTED_CHANNELS.map((ch) => {
              const account = accounts.find((a) => a.channel === ch.code);
              const isConnected = account?.status === "ACTIVE";
              const isPaused = account?.status === "PAUSED";

              return (
                <div
                  key={ch.code}
                  style={{
                    background: "var(--bg-card, #111c38)",
                    border: "1px solid var(--border, #1e293b)",
                    borderRadius: 12,
                    padding: 18,
                    display: "flex",
                    flexDirection: "column",
                    gap: 12,
                  }}
                >
                  <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
                    <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
                      <span style={{ fontSize: "1.5rem" }}>{ch.icon}</span>
                      <div>
                        <div style={{ fontWeight: 700, fontSize: "0.95rem", color: "var(--text-primary, #f8fafc)" }}>{ch.label}</div>
                        {account && (
                          <div style={{ fontSize: "0.72rem", color: "var(--text-muted, #64748b)" }}>
                            Outlet ID: {account.externalOutletId}
                          </div>
                        )}
                      </div>
                    </div>

                    <span
                      style={{
                        fontSize: "0.7rem",
                        fontWeight: 700,
                        padding: "4px 10px",
                        borderRadius: 9999,
                        background: isConnected ? "rgba(16, 185, 129, 0.15)" : isPaused ? "rgba(245, 158, 11, 0.15)" : "var(--bg-subtle, #070d1e)",
                        color: isConnected ? "#34d399" : isPaused ? "#fbbf24" : "var(--text-muted, #64748b)",
                        border: isConnected ? "1px solid rgba(16, 185, 129, 0.3)" : isPaused ? "1px solid rgba(245, 158, 11, 0.3)" : "1px solid var(--border, #1e293b)",
                      }}
                    >
                      {isConnected ? "● Connected" : isPaused ? "◐ Paused" : "○ Not Connected"}
                    </span>
                  </div>

                  {account && (
                    <div
                      style={{
                        display: "flex",
                        alignItems: "center",
                        justifyContent: "space-between",
                        background: "var(--bg-subtle, #070d1e)",
                        border: "1px solid var(--border, #1e293b)",
                        borderRadius: 8,
                        padding: "8px 12px",
                        fontSize: "0.72rem",
                      }}
                    >
                      <code style={{ color: "var(--text-secondary, #94a3b8)" }}>
                        Webhook URL: /webhooks/{ch.code.toLowerCase()}
                      </code>
                      <button
                        onClick={() => copyWebhookUrl(ch.code)}
                        style={{
                          border: "1px solid var(--btn-normal-border, #334155)",
                          background: "var(--btn-normal-bg, #1e293b)",
                          color: "var(--btn-normal-text, #94a3b8)",
                          borderRadius: 6,
                          padding: "4px 8px",
                          fontSize: "0.68rem",
                          fontWeight: 700,
                          cursor: "pointer",
                        }}
                      >
                        {copiedChannel === ch.code ? "Copied!" : "Copy"}
                      </button>
                    </div>
                  )}

                  <div style={{ display: "flex", gap: 8 }}>
                    <button
                      type="button"
                      id={`simulate-order-${ch.code.toLowerCase()}`}
                      onClick={() => setSimulatingChannel(ch.code as "SWIGGY" | "ZOMATO")}
                      style={{
                        padding: "8px 14px",
                        borderRadius: 9999,
                        border: `1px solid ${ch.color}`,
                        background: "rgba(255,255,255,0.06)",
                        color: ch.color,
                        fontWeight: 700,
                        fontSize: "0.8rem",
                        cursor: "pointer",
                        display: "flex",
                        alignItems: "center",
                        gap: 4,
                      }}
                    >
                      ⚡ Simulate Customer Order
                    </button>
                    <button
                      onClick={() => openConnect(ch.code)}
                      style={{
                        flex: 1,
                        padding: "8px 16px",
                        borderRadius: 9999,
                        border: "none",
                        background: ch.color,
                        color: "#fff",
                        fontWeight: 700,
                        fontSize: "0.8rem",
                        cursor: "pointer",
                      }}
                    >
                      {account ? "Reconnect / Rotate Key" : "Connect"}
                    </button>
                    {isConnected && (
                      <button
                        onClick={() => disconnect(account!.id)}
                        style={{
                          padding: "8px 16px",
                          borderRadius: 9999,
                          border: "1px solid var(--btn-alert-border, #ef4444)",
                          background: "transparent",
                          color: "var(--btn-alert-text, #ef4444)",
                          fontWeight: 700,
                          fontSize: "0.8rem",
                          cursor: "pointer",
                        }}
                      >
                        Disconnect
                      </button>
                    )}
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>

      {connectingChannel && (
        <div
          style={{
            position: "fixed",
            inset: 0,
            zIndex: 50,
            background: "rgba(11, 19, 43, 0.8)",
            backdropFilter: "blur(4px)",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            padding: 16,
          }}
        >
          <div style={{ background: "var(--bg-card, #111c38)", border: "1px solid var(--border-strong, #334155)", borderRadius: 16, padding: 24, width: "100%", maxWidth: 400, color: "var(--text-primary, #f8fafc)" }}>
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 16 }}>
              <h2 style={{ fontSize: "1.05rem", fontWeight: 800, color: "var(--text-primary, #f8fafc)" }}>
                Connect {SUPPORTED_CHANNELS.find((c) => c.code === connectingChannel)?.label}
              </h2>
              <button onClick={() => setConnectingChannel(null)} style={{ border: "none", background: "none", fontSize: "1.25rem", cursor: "pointer", color: "var(--text-secondary, #94a3b8)" }}>
                ×
              </button>
            </div>

            <p style={{ fontSize: "0.75rem", color: "var(--text-secondary, #94a3b8)", marginBottom: 16 }}>
              Find these in your {SUPPORTED_CHANNELS.find((c) => c.code === connectingChannel)?.label} partner dashboard under API/Integration settings.
            </p>

            <div style={{ display: "flex", flexDirection: "column", gap: 12 }}>
              <div>
                <label style={{ fontSize: "0.75rem", fontWeight: 600, display: "block", marginBottom: 4, color: "var(--text-primary, #f8fafc)" }}>Restaurant/Outlet ID on the platform</label>
                <input
                  type="text"
                  value={externalOutletId}
                  onChange={(e) => setExternalOutletId(e.target.value)}
                  style={{ width: "100%", padding: "8px 12px", borderRadius: 8, border: "1px solid var(--border-strong, #334155)", background: "var(--bg-subtle, #070d1e)", color: "var(--text-primary, #f8fafc)", fontSize: "0.85rem" }}
                />
              </div>
              <div>
                <label style={{ fontSize: "0.75rem", fontWeight: 600, display: "block", marginBottom: 4, color: "var(--text-primary, #f8fafc)" }}>API Key</label>
                <input
                  type="text"
                  value={apiKey}
                  onChange={(e) => setApiKey(e.target.value)}
                  style={{ width: "100%", padding: "8px 12px", borderRadius: 8, border: "1px solid var(--border-strong, #334155)", background: "var(--bg-subtle, #070d1e)", color: "var(--text-primary, #f8fafc)", fontSize: "0.85rem" }}
                />
              </div>
              <div>
                <label style={{ fontSize: "0.75rem", fontWeight: 600, display: "block", marginBottom: 4, color: "var(--text-primary, #f8fafc)" }}>API Secret</label>
                <input
                  type="password"
                  value={apiSecret}
                  onChange={(e) => setApiSecret(e.target.value)}
                  style={{ width: "100%", padding: "8px 12px", borderRadius: 8, border: "1px solid var(--border-strong, #334155)", background: "var(--bg-subtle, #070d1e)", color: "var(--text-primary, #f8fafc)", fontSize: "0.85rem" }}
                />
              </div>

              {formError && <div style={{ fontSize: "0.75rem", color: "var(--btn-alert-border, #ef4444)" }}>{formError}</div>}

              <button
                onClick={submitConnect}
                disabled={saving}
                style={{
                  padding: "10px",
                  borderRadius: 9999,
                  border: "1px solid var(--btn-primary-border, #3b82f6)",
                  background: "var(--btn-primary-bg, #2563eb)",
                  color: "var(--btn-primary-text, #ffffff)",
                  fontWeight: 700,
                  fontSize: "0.85rem",
                  cursor: "pointer",
                  marginTop: 4,
                  transition: "background 0.15s",
                }}
              >
                {saving ? "Connecting..." : "Save & Connect"}
              </button>
            </div>
          </div>
        </div>
      )}

      {simulatingChannel && (
        <SimulateAggregatorModal
          isOpen={Boolean(simulatingChannel)}
          initialChannel={simulatingChannel}
          onClose={() => setSimulatingChannel(null)}
        />
      )}
    </div>
  );
}
