import React, { useState, useEffect } from "react";
import { authedFetch } from "../lib/auth";

export interface AssignCaptainModalProps {
  isOpen: boolean;
  onClose: () => void;
  currentCaptain: string;
  onSelectCaptain: (captain: string) => void;
}

const DEFAULT_CAPTAINS = [
  { id: "cp1", label: "cp1 (Captain)" },
  { id: "cp2", label: "cp2 (Captain)" },
  { id: "cp3", label: "cp3 (Captain)" },
  { id: "cp4", label: "cp4 (Captain)" },
  { id: "cp5", label: "cp5 (Captain)" },
  { id: "cp6", label: "cp6 (Captain)" },
];

export default function AssignCaptainModal({
  isOpen,
  onClose,
  currentCaptain = "cp1 (Captain)",
  onSelectCaptain,
}: AssignCaptainModalProps) {
  const [selected, setSelected] = useState(currentCaptain);
  const [captains, setCaptains] = useState(DEFAULT_CAPTAINS);

  useEffect(() => {
    setSelected(currentCaptain);
  }, [currentCaptain, isOpen]);

  // Optionally load real staff members from API if available
  useEffect(() => {
    if (!isOpen) return;
    authedFetch("/users")
      .then((res) => (res.ok ? res.json() : []))
      .then((users: any[]) => {
        if (Array.isArray(users) && users.length > 0) {
          const waiterUsers = users.filter((u) =>
            u.userRoles?.some((ur: any) =>
              ur.roleName?.toUpperCase().includes("WAITER") ||
              ur.roleName?.toUpperCase().includes("CAPTAIN") ||
              ur.roleName?.toUpperCase().includes("FLOOR")
            )
          );
          if (waiterUsers.length > 0) {
            const mapped = waiterUsers.map((u, i) => ({
              id: u.id,
              label: `${u.firstName || `cp${i + 1}`} (Captain)`,
            }));
            setCaptains(mapped);
          }
        }
      })
      .catch(() => {
        // Keep DEFAULT_CAPTAINS
      });
  }, [isOpen]);

  if (!isOpen) return null;

  const handleDone = () => {
    onSelectCaptain(selected);
    onClose();
  };

  return (
    <div className="petpooja-modal-overlay" onClick={onClose}>
      <div
        className="petpooja-modal-container"
        style={{ width: "420px", maxWidth: "95vw" }}
        onClick={(e) => e.stopPropagation()}
      >
        {/* Header */}
        <div className="petpooja-modal-header">
          <h3 style={{ margin: 0, fontSize: "16px", fontWeight: 600, color: "#1e293b" }}>
            Assign to
          </h3>
          <button
            type="button"
            className="petpooja-close-btn"
            onClick={onClose}
            aria-label="Close"
          >
            ✕
          </button>
        </div>

        {/* List of Captains */}
        <div style={{ maxHeight: "350px", overflowY: "auto", padding: "8px 0" }}>
          {captains.map((cap) => {
            const isChecked = selected === cap.label || selected === cap.id;
            return (
              <label
                key={cap.id}
                style={{
                  display: "flex",
                  justifyContent: "space-between",
                  alignItems: "center",
                  padding: "12px 22px",
                  cursor: "pointer",
                  borderBottom: "1px solid #f8fafc",
                  backgroundColor: isChecked ? "#fef2f2" : "transparent",
                  transition: "background-color 0.1s",
                }}
                onClick={() => setSelected(cap.label)}
              >
                <span style={{ fontSize: "14px", fontWeight: isChecked ? 600 : 400, color: "#1e293b" }}>
                  {cap.label}
                </span>
                <input
                  type="radio"
                  name="captain-assign"
                  value={cap.label}
                  checked={isChecked}
                  onChange={() => setSelected(cap.label)}
                  style={{
                    width: "18px",
                    height: "18px",
                    cursor: "pointer",
                    accentColor: "#b91c1c",
                  }}
                />
              </label>
            );
          })}
        </div>

        {/* Footer Actions */}
        <div
          style={{
            display: "flex",
            justifyContent: "flex-end",
            gap: "10px",
            padding: "14px 22px",
            borderTop: "1px solid #f1f5f9",
          }}
        >
          <button
            type="button"
            onClick={onClose}
            style={{
              padding: "7px 20px",
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
            type="button"
            onClick={handleDone}
            style={{
              padding: "7px 24px",
              backgroundColor: "#b91c1c",
              border: "none",
              borderRadius: "4px",
              fontSize: "13px",
              fontWeight: 600,
              color: "#ffffff",
              cursor: "pointer",
            }}
          >
            Done
          </button>
        </div>
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
