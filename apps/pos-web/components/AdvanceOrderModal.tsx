import React, { useState } from "react";

export interface AdvanceOrderModalProps {
  isOpen: boolean;
  onClose: () => void;
  orderMode: string;
  totalRupees: string;
  onConfirmAdvance: (details: {
    scheduledDate: string;
    scheduledTime: string;
    advancePaidRupees: number;
    notes: string;
  }) => void;
}

export default function AdvanceOrderModal({
  isOpen,
  onClose,
  orderMode,
  totalRupees,
  onConfirmAdvance,
}: AdvanceOrderModalProps) {
  // Default scheduled date to tomorrow
  const tomorrow = new Date();
  tomorrow.setDate(tomorrow.getDate() + 1);
  const defaultDateStr = tomorrow.toISOString().split("T")[0];

  const [scheduledDate, setScheduledDate] = useState(defaultDateStr);
  const [scheduledTime, setScheduledTime] = useState("13:00");
  const [advancePaid, setAdvancePaid] = useState("");
  const [advanceNotes, setAdvanceNotes] = useState("");

  if (!isOpen) return null;

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onConfirmAdvance({
      scheduledDate,
      scheduledTime,
      advancePaidRupees: Number(advancePaid) || 0,
      notes: advanceNotes.trim(),
    });
    onClose();
  };

  return (
    <div className="petpooja-modal-overlay" onClick={onClose}>
      <div
        className="petpooja-modal-container"
        style={{ width: "460px", maxWidth: "95vw" }}
        onClick={(e) => e.stopPropagation()}
      >
        <div className="petpooja-modal-header">
          <h3 style={{ margin: 0, fontSize: "16px", fontWeight: 600, color: "#1e293b" }}>
            📅 Advance / Scheduled Order
          </h3>
          <button type="button" className="petpooja-close-btn" onClick={onClose}>
            ✕
          </button>
        </div>

        <form onSubmit={handleSubmit} style={{ padding: "18px 22px" }}>
          <div style={{ marginBottom: "14px" }}>
            <label style={{ display: "block", fontSize: "12px", fontWeight: 600, color: "#64748b", marginBottom: "4px" }}>
              Order Mode & Total
            </label>
            <div style={{ display: "flex", justifyContent: "space-between", padding: "8px 12px", background: "#f8fafc", borderRadius: "6px", border: "1px solid #e2e8f0" }}>
              <span style={{ fontWeight: 600, color: "#0f172a" }}>Mode: {orderMode}</span>
              <span style={{ fontWeight: 700, color: "#b91c1c" }}>Total: ₹{totalRupees}</span>
            </div>
          </div>

          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "12px", marginBottom: "14px" }}>
            <div>
              <label style={{ display: "block", fontSize: "13px", fontWeight: 600, color: "#334155", marginBottom: "4px" }}>
                Scheduled Date *
              </label>
              <input
                type="date"
                required
                value={scheduledDate}
                min={new Date().toISOString().split("T")[0]}
                onChange={(e) => setScheduledDate(e.target.value)}
                style={{
                  width: "100%",
                  padding: "8px 10px",
                  fontSize: "13px",
                  border: "1px solid #cbd5e1",
                  borderRadius: "6px",
                  boxSizing: "border-box",
                }}
              />
            </div>
            <div>
              <label style={{ display: "block", fontSize: "13px", fontWeight: 600, color: "#334155", marginBottom: "4px" }}>
                Scheduled Time *
              </label>
              <input
                type="time"
                required
                value={scheduledTime}
                onChange={(e) => setScheduledTime(e.target.value)}
                style={{
                  width: "100%",
                  padding: "8px 10px",
                  fontSize: "13px",
                  border: "1px solid #cbd5e1",
                  borderRadius: "6px",
                  boxSizing: "border-box",
                }}
              />
            </div>
          </div>

          <div style={{ marginBottom: "14px" }}>
            <label style={{ display: "block", fontSize: "13px", fontWeight: 600, color: "#334155", marginBottom: "4px" }}>
              Advance Deposit Paid (₹, optional)
            </label>
            <input
              type="number"
              min="0"
              step="any"
              placeholder="0.00"
              value={advancePaid}
              onChange={(e) => setAdvancePaid(e.target.value)}
              style={{
                width: "100%",
                padding: "8px 10px",
                fontSize: "13px",
                border: "1px solid #cbd5e1",
                borderRadius: "6px",
                boxSizing: "border-box",
              }}
            />
          </div>

          <div style={{ marginBottom: "18px" }}>
            <label style={{ display: "block", fontSize: "13px", fontWeight: 600, color: "#334155", marginBottom: "4px" }}>
              Special Packaging / Delivery Instructions
            </label>
            <textarea
              rows={3}
              value={advanceNotes}
              onChange={(e) => setAdvanceNotes(e.target.value)}
              placeholder="e.g. Deliver hot by 1:00 PM sharp, cater for 10 people..."
              style={{
                width: "100%",
                padding: "8px 10px",
                fontSize: "13px",
                border: "1px solid #cbd5e1",
                borderRadius: "6px",
                boxSizing: "border-box",
                resize: "vertical",
              }}
            />
          </div>

          <div style={{ display: "flex", justifyContent: "flex-end", gap: "10px", borderTop: "1px solid #f1f5f9", paddingTop: "14px" }}>
            <button
              type="button"
              onClick={onClose}
              style={{
                padding: "7px 18px",
                backgroundColor: "#fff",
                border: "1px solid #cbd5e1",
                borderRadius: "4px",
                fontSize: "13px",
                fontWeight: 600,
                color: "#475569",
                cursor: "pointer",
              }}
            >
              Cancel
            </button>
            <button
              type="submit"
              style={{
                padding: "7px 22px",
                backgroundColor: "#b91c1c",
                border: "none",
                borderRadius: "4px",
                fontSize: "13px",
                fontWeight: 600,
                color: "#ffffff",
                cursor: "pointer",
              }}
            >
              Confirm Advance Order
            </button>
          </div>
        </form>
      </div>

      <style jsx>{`
        .petpooja-modal-overlay {
          position: fixed;
          top: 0;
          left: 0;
          right: 0;
          bottom: 0;
          background: rgba(15, 23, 42, 0.45);
          display: flex;
          align-items: center;
          justify-content: center;
          z-index: 9999;
          backdrop-filter: blur(1px);
        }
        .petpooja-modal-container {
          background: #ffffff;
          border-radius: 8px;
          box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.2);
          overflow: hidden;
          animation: modalPop 0.15s ease-out;
        }
        .petpooja-modal-header {
          display: flex;
          justify-content: space-between;
          align-items: center;
          padding: 14px 22px;
          border-bottom: 1px solid #f1f5f9;
        }
        .petpooja-close-btn {
          background: transparent;
          border: none;
          font-size: 16px;
          color: #94a3b8;
          cursor: pointer;
          padding: 2px 6px;
        }
        .petpooja-close-btn:hover {
          color: #1e293b;
        }
        @keyframes modalPop {
          from {
            opacity: 0;
            transform: scale(0.97);
          }
          to {
            opacity: 1;
            transform: scale(1);
          }
        }
      `}</style>
    </div>
  );
}
