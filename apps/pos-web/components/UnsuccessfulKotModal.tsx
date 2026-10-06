import React, { useState } from "react";

interface QueuedKot {
  id: string;
  tableNumber: string;
  itemCount: number;
  createdAt: string;
  errorMessage?: string;
}

interface UnsuccessfulKotModalProps {
  queuedKots: QueuedKot[];
  onClose: () => void;
  onRetryAll: () => void;
  onClearAll: () => void;
}

export default function UnsuccessfulKotModal({
  queuedKots,
  onClose,
  onRetryAll,
  onClearAll,
}: UnsuccessfulKotModalProps) {
  const [retrying, setRetrying] = useState(false);

  const handleRetry = async () => {
    setRetrying(true);
    await onRetryAll();
    setRetrying(false);
  };

  return (
    <div className="unsuccessful-modal-backdrop" onClick={onClose}>
      <div className="unsuccessful-modal-card" onClick={(e) => e.stopPropagation()}>
        <div className="modal-header">
          <div style={{ display: "flex", alignItems: "center", gap: "8px" }}>
            <span style={{ fontSize: "1.25rem", color: "#dc2626" }}>⚠️</span>
            <h3 style={{ margin: 0, fontSize: "1.125rem", fontWeight: 700 }}>Unsuccessful KOT Queue</h3>
          </div>
          <button className="close-btn" onClick={onClose}>✕</button>
        </div>

        <p style={{ margin: "8px 0 12px 0", fontSize: "0.8125rem", color: "#64748b" }}>
          Orders taken during offline LAN disconnections waiting to sync with POS server / KDS.
        </p>

        <div className="kot-queue-list">
          {queuedKots.length === 0 ? (
            <div style={{ textAlign: "center", padding: "32px 0", color: "#16a34a" }}>
              ✓ All KOTs successfully synced with the Kitchen POS Server.
            </div>
          ) : (
            queuedKots.map((k) => (
              <div key={k.id} className="queued-item-row">
                <div>
                  <div style={{ fontWeight: 700, fontSize: "0.875rem", color: "var(--text-primary, #f8fafc)" }}>
                    Table {k.tableNumber} • {k.itemCount} items
                  </div>
                  <div style={{ fontSize: "0.75rem", color: "#f87171", marginTop: "2px" }}>
                    {k.errorMessage || "Network timeout / POS unreachable"}
                  </div>
                </div>
                <div style={{ fontSize: "0.6875rem", color: "var(--text-muted, #64748b)" }}>
                  {new Date(k.createdAt).toLocaleTimeString()}
                </div>
              </div>
            ))
          )}
        </div>

        <div style={{ display: "flex", justifyContent: "space-between", marginTop: "20px" }}>
          {queuedKots.length > 0 && (
            <button type="button" className="btn-clear" onClick={onClearAll}>
              Clear Queue
            </button>
          )}
          <div style={{ display: "flex", gap: "8px", marginLeft: "auto" }}>
            <button type="button" className="btn-close" onClick={onClose}>
              Close
            </button>
            {queuedKots.length > 0 && (
              <button
                type="button"
                className="btn-retry"
                onClick={handleRetry}
                disabled={retrying}
              >
                {retrying ? "Retrying..." : "Sync / Retry All"}
              </button>
            )}
          </div>
        </div>
      </div>

      <style jsx>{`
        .unsuccessful-modal-backdrop {
          position: fixed;
          top: 0;
          left: 0;
          width: 100vw;
          height: 100vh;
          background: rgba(11, 19, 43, 0.7);
          backdrop-filter: blur(4px);
          z-index: 250;
          display: flex;
          align-items: center;
          justify-content: center;
        }
        .unsuccessful-modal-card {
          background: var(--bg-card, #111c38);
          border: 1px solid var(--border-strong, #334155);
          color: var(--text-primary, #f8fafc);
          padding: 24px;
          border-radius: 12px;
          width: 90%;
          max-width: 480px;
          box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.5);
          max-height: 80vh;
          display: flex;
          flex-direction: column;
        }
        .modal-header {
          display: flex;
          align-items: center;
          justify-content: space-between;
          color: var(--text-primary, #f8fafc);
        }
        .close-btn {
          background: transparent;
          border: none;
          font-size: 1.1rem;
          color: var(--text-secondary, #94a3b8);
          cursor: pointer;
          transition: color 0.15s;
        }
        .close-btn:hover {
          color: var(--text-primary, #f8fafc);
        }
        .kot-queue-list {
          overflow-y: auto;
          flex: 1;
          display: flex;
          flex-direction: column;
          gap: 8px;
          margin-top: 8px;
        }
        .queued-item-row {
          display: flex;
          align-items: center;
          justify-content: space-between;
          padding: 10px 12px;
          background: rgba(220, 38, 38, 0.12);
          border: 1px solid rgba(220, 38, 38, 0.3);
          border-radius: 6px;
        }
        .btn-clear {
          background: var(--btn-alert-bg, #dc2626);
          color: var(--btn-alert-text, #ffffff);
          border: 1px solid var(--btn-alert-border, #ef4444);
          padding: 8px 14px;
          border-radius: 6px;
          font-weight: 700;
          font-size: 0.8125rem;
          cursor: pointer;
          transition: background 0.15s;
        }
        .btn-clear:hover {
          background: var(--btn-alert-hover, #b91c1c);
        }
        .btn-close {
          background: var(--btn-cancel-bg, #334155);
          border: 1px solid var(--btn-cancel-border, #475569);
          color: var(--btn-cancel-text, #cbd5e1);
          padding: 8px 16px;
          border-radius: 6px;
          font-weight: 700;
          font-size: 0.8125rem;
          cursor: pointer;
          transition: background 0.15s;
        }
        .btn-close:hover {
          background: var(--btn-cancel-hover, #475569);
          color: #f8fafc;
        }
        .btn-retry {
          background: var(--btn-primary-bg, #2563eb);
          color: var(--btn-primary-text, #ffffff);
          border: 1px solid var(--btn-primary-border, #3b82f6);
          padding: 8px 18px;
          border-radius: 6px;
          font-weight: 700;
          font-size: 0.8125rem;
          cursor: pointer;
          transition: background 0.15s;
        }
        .btn-retry:hover {
          background: var(--btn-primary-hover, #1d4ed8);
        }
      `}</style>
    </div>
  );
}
