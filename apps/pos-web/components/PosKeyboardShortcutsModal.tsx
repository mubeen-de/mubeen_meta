import React from "react";

interface PosKeyboardShortcutsModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export default function PosKeyboardShortcutsModal({
  isOpen,
  onClose,
}: PosKeyboardShortcutsModalProps) {
  if (!isOpen) return null;

  const shortcuts = [
    { key: "F1 or /", desc: "Focus Menu Search input", category: "Navigation" },
    { key: "F2", desc: "Hold / Park current draft cart", category: "Cart & Orders" },
    { key: "F3", desc: "Open Parked / Held orders drawer", category: "Cart & Orders" },
    { key: "F4", desc: "Open Discount & Promotion modal", category: "Billing" },
    { key: "F8", desc: "Select Cash payment mode & tender chips", category: "Billing" },
    { key: "F9", desc: "Fire KOT wave to Kitchen Display", category: "Kitchen" },
    { key: "F10", desc: "Print Thermal Invoice & Settle", category: "Billing" },
    { key: "M", desc: "Open Multi-Agent A2A Telemetry HUD", category: "System" },
    { key: "Esc", desc: "Return to Floor Map / Close active modal", category: "Navigation" },
  ];

  return (
    <div className="shortcuts-modal-backdrop" onClick={onClose}>
      <div className="shortcuts-modal-card" onClick={(e) => e.stopPropagation()}>
        <div className="shortcuts-modal-header">
          <div className="flex items-center gap-2">
            <span style={{ fontSize: "1.3rem" }}>⌨️</span>
            <div>
              <h3>POS Keyboard Shortcuts & Pro-Mode</h3>
              <p>High-speed hotkeys designed for high-throughput restaurant billing</p>
            </div>
          </div>
          <button type="button" className="btn-close-modal" onClick={onClose}>✕</button>
        </div>

        <div className="shortcuts-list">
          {shortcuts.map((s, idx) => (
            <div key={idx} className="shortcut-row">
              <div className="shortcut-key-capsule">
                <kbd>{s.key}</kbd>
              </div>
              <div className="shortcut-desc">
                <span>{s.desc}</span>
                <span className="shortcut-category">{s.category}</span>
              </div>
            </div>
          ))}
        </div>

        <div className="shortcuts-footer">
          <span>Pro-Tip: Press hotkeys directly on any physical POS keyboard or numeric keypad.</span>
          <button type="button" className="btn-got-it" onClick={onClose}>Got It</button>
        </div>
      </div>

      <style jsx>{`
        .shortcuts-modal-backdrop {
          position: fixed;
          inset: 0;
          background: rgba(11, 19, 43, 0.8);
          backdrop-filter: blur(4px);
          z-index: 100002;
          display: flex;
          align-items: center;
          justify-content: center;
          animation: fadeIn 0.15s ease-out;
        }
        .shortcuts-modal-card {
          width: 520px;
          max-width: 92vw;
          background: var(--bg-card, #111c38);
          border: 1px solid var(--border-strong, #334155);
          color: var(--text-primary, #f8fafc);
          border-radius: 12px;
          box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.5);
          overflow: hidden;
        }
        .shortcuts-modal-header {
          padding: 16px 20px;
          background: var(--bg-subtle, #070d1e);
          border-bottom: 1px solid var(--border, #1e293b);
          color: var(--text-primary, #f8fafc);
          display: flex;
          align-items: center;
          justify-content: space-between;
        }
        .shortcuts-modal-header h3 {
          margin: 0;
          font-size: 1rem;
          font-weight: 800;
          color: var(--text-primary, #f8fafc);
        }
        .shortcuts-modal-header p {
          margin: 2px 0 0;
          font-size: 0.72rem;
          color: var(--text-secondary, #94a3b8);
        }
        .btn-close-modal {
          background: transparent;
          border: none;
          color: var(--text-secondary, #94a3b8);
          font-size: 1.2rem;
          cursor: pointer;
        }
        .shortcuts-list {
          padding: 16px 20px;
          display: flex;
          flex-direction: column;
          gap: 10px;
          max-height: 400px;
          overflow-y: auto;
        }
        .shortcut-row {
          display: flex;
          align-items: center;
          gap: 14px;
          padding: 8px 10px;
          border-radius: 6px;
          background: var(--bg-subtle, #070d1e);
          border: 1px solid var(--border, #1e293b);
        }
        .shortcut-key-capsule kbd {
          background: var(--bg-elevated, #1e293b);
          color: #ffffff;
          padding: 4px 10px;
          border-radius: 6px;
          font-family: monospace;
          font-weight: 800;
          font-size: 0.8rem;
          box-shadow: 0 2px 0 rgba(0, 0, 0, 0.4);
          white-space: nowrap;
          min-width: 70px;
          display: inline-block;
          text-align: center;
          border: 1px solid var(--border-strong, #334155);
        }
        .shortcut-desc {
          flex: 1;
          display: flex;
          justify-content: space-between;
          align-items: center;
          font-size: 0.82rem;
          color: var(--text-primary, #f8fafc);
          font-weight: 600;
        }
        .shortcut-category {
          font-size: 0.68rem;
          background: var(--bg-elevated, #1e293b);
          color: var(--text-secondary, #94a3b8);
          padding: 1px 6px;
          border-radius: 4px;
          border: 1px solid var(--border, #1e293b);
        }
        .shortcuts-footer {
          padding: 12px 20px;
          background: var(--bg-subtle, #070d1e);
          border-top: 1px solid var(--border, #1e293b);
          display: flex;
          justify-content: space-between;
          align-items: center;
          font-size: 0.72rem;
          color: var(--text-secondary, #94a3b8);
        }
        .btn-got-it {
          background: var(--btn-success-bg, #10b981);
          color: #ffffff;
          border: 1px solid #059669;
          padding: 6px 16px;
          border-radius: 6px;
          font-size: 0.75rem;
          font-weight: 800;
          cursor: pointer;
          transition: background 0.15s;
        }
        .btn-got-it:hover {
          background: var(--btn-success-hover, #059669);
        }
      `}</style>
    </div>
  );
}
