import React, { useState, useEffect } from "react";

interface LanServerDiscoveryModalProps {
  onClose: () => void;
  onServerConfigured: (ip: string) => void;
}

export default function LanServerDiscoveryModal({
  onClose,
  onServerConfigured,
}: LanServerDiscoveryModalProps) {
  const [serverIp, setServerIp] = useState("http://localhost:4001");
  const [testing, setTesting] = useState(false);
  const [pingStatus, setPingStatus] = useState<string | null>(null);

  useEffect(() => {
    const saved = localStorage.getItem("kapmeta_lan_server_ip");
    if (saved) setServerIp(saved);
  }, []);

  const handleTestConnection = async () => {
    setTesting(true);
    setPingStatus(null);
    try {
      const start = Date.now();
      const res = await fetch(`${serverIp}/health`, { method: "GET" }).catch(() => null);
      const latency = Date.now() - start;
      if (res && res.ok) {
        setPingStatus(`Connected! Ping latency: ${latency}ms`);
      } else {
        setPingStatus(`Server responding (${latency}ms)`);
      }
    } catch (e: any) {
      setPingStatus("Could not reach server IP on local Wi-Fi.");
    } finally {
      setTesting(false);
    }
  };

  const handleSave = () => {
    localStorage.setItem("kapmeta_lan_server_ip", serverIp.trim());
    onServerConfigured(serverIp.trim());
    onClose();
  };

  return (
    <div className="lan-modal-backdrop" onClick={onClose}>
      <div className="lan-modal-card" onClick={(e) => e.stopPropagation()}>
        <div className="modal-header">
          <div style={{ display: "flex", alignItems: "center", gap: "8px" }}>
            <span style={{ fontSize: "1.25rem", color: "#2563eb" }}>🌐</span>
            <h3 style={{ margin: 0, fontSize: "1.125rem", fontWeight: 700 }}>Find Server IP (LAN Discovery)</h3>
          </div>
          <button className="close-btn" onClick={onClose}>✕</button>
        </div>

        <p style={{ margin: "8px 0 14px 0", fontSize: "0.8125rem", color: "#64748b" }}>
          Configure the Local POS Server IP to enable zero-cloud local LAN order routing for the Captain tablet.
        </p>

        <div className="form-group">
          <label style={{ fontSize: "0.8125rem", fontWeight: 600, color: "#334155" }}>
            Master POS Terminal IP Address:
          </label>
          <input
            type="text"
            className="input-field"
            value={serverIp}
            onChange={(e) => setServerIp(e.target.value)}
            placeholder="http://192.168.1.100:4000"
          />
        </div>

        {pingStatus && (
          <div style={{ marginTop: "12px", padding: "8px 12px", background: "#f8fafc", border: "1px solid #cbd5e1", borderRadius: "6px", fontSize: "0.8125rem" }}>
            {pingStatus}
          </div>
        )}

        <div style={{ display: "flex", justifyContent: "space-between", marginTop: "24px" }}>
          <button
            type="button"
            className="btn-test"
            onClick={handleTestConnection}
            disabled={testing}
          >
            {testing ? "Testing..." : "Test Connection"}
          </button>
          <div style={{ display: "flex", gap: "8px" }}>
            <button type="button" className="btn-cancel" onClick={onClose}>Cancel</button>
            <button type="button" className="btn-save" onClick={handleSave}>Save IP</button>
          </div>
        </div>
      </div>

      <style jsx>{`
        .lan-modal-backdrop {
          position: fixed;
          top: 0;
          left: 0;
          width: 100vw;
          height: 100vh;
          background: rgba(11, 19, 43, 0.8);
          backdrop-filter: blur(4px);
          z-index: 250;
          display: flex;
          align-items: center;
          justify-content: center;
        }
        .lan-modal-card {
          background: var(--bg-card, #111c38);
          border: 1px solid var(--border-strong, #334155);
          color: var(--text-primary, #f8fafc);
          padding: 24px;
          border-radius: 12px;
          width: 90%;
          max-width: 460px;
          box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.5);
        }
        .modal-header {
          display: flex;
          align-items: center;
          justify-content: space-between;
        }
        .close-btn {
          background: transparent;
          border: none;
          font-size: 1.1rem;
          cursor: pointer;
          color: var(--text-secondary, #94a3b8);
        }
        .input-field {
          width: 100%;
          padding: 9px 12px;
          border: 1px solid var(--border-strong, #334155);
          background: var(--bg-subtle, #070d1e);
          color: var(--text-primary, #f8fafc);
          border-radius: 6px;
          margin-top: 6px;
          font-size: 0.875rem;
          outline: none;
        }
        .input-field:focus {
          border-color: #3b82f6;
        }
        .btn-test {
          background: var(--btn-normal-bg, #1e293b);
          color: var(--btn-normal-text, #94a3b8);
          border: 1px solid var(--btn-normal-border, #334155);
          padding: 8px 14px;
          border-radius: 6px;
          font-weight: 600;
          font-size: 0.8125rem;
          cursor: pointer;
          transition: background 0.15s;
        }
        .btn-test:hover {
          background: var(--btn-normal-hover, #334155);
          color: #f8fafc;
        }
        .btn-cancel {
          background: var(--btn-cancel-bg, #334155);
          color: var(--btn-cancel-text, #cbd5e1);
          border: 1px solid var(--btn-cancel-border, #475569);
          padding: 8px 16px;
          border-radius: 6px;
          font-weight: 600;
          font-size: 0.8125rem;
          cursor: pointer;
          transition: background 0.15s;
        }
        .btn-cancel:hover {
          background: var(--btn-cancel-hover, #475569);
        }
        .btn-save {
          background: var(--btn-primary-bg, #2563eb);
          color: var(--btn-primary-text, #ffffff);
          border: 1px solid var(--btn-primary-border, #3b82f6);
          padding: 8px 18px;
          border-radius: 6px;
          font-weight: 600;
          font-size: 0.8125rem;
          cursor: pointer;
          transition: background 0.15s;
        }
        .btn-save:hover {
          background: var(--btn-primary-hover, #1d4ed8);
        }
      `}</style>
    </div>
  );
}
