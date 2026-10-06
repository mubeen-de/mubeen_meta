import React, { useState } from "react";
import { getApiBase } from "../lib/auth";

interface ForgotPasswordModalProps {
  isOpen: boolean;
  onClose: () => void;
  initialEmail: string;
  initialOutletId: string;
  onFillAndLogin: (email: string, pass: string) => void;
}

const DEMO_PRESETS = [
  { role: "Super Admin", email: "admin@hotelkapila.com", pass: "password123", pin: "1234" },
  { role: "Front Cashier", email: "cashier@hotelkapila.com", pass: "password123", pin: "1234" },
  { role: "Kitchen Chef", email: "chef@hotelkapila.com", pass: "password123", pin: "1234" },
  { role: "Floor Waiter", email: "waiter@hotelkapila.com", pass: "password123", pin: "1234" },
];

export default function ForgotPasswordModal({
  isOpen,
  onClose,
  initialEmail,
  initialOutletId,
  onFillAndLogin,
}: ForgotPasswordModalProps) {
  const [emailInput, setEmailInput] = useState(initialEmail || "admin@hotelkapila.com");
  const [loading, setLoading] = useState(false);
  const [recoveryResult, setRecoveryResult] = useState<{
    ok: boolean;
    isDemo?: boolean;
    defaultPassword?: string;
    message: string;
    user?: { name: string; email: string; role: string };
  } | null>(null);

  if (!isOpen) return null;

  const handleLookup = async (lookupEmail?: string) => {
    const targetEmail = (lookupEmail || emailInput).trim();
    if (!targetEmail) return;

    setLoading(true);
    setRecoveryResult(null);

    try {
      const apiBase = getApiBase();
      const res = await fetch(`${apiBase}/auth/forgot-password`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email: targetEmail, outletId: initialOutletId }),
      });
      const data = await res.json();
      setRecoveryResult(data);
    } catch {
      setRecoveryResult({
        ok: false,
        message: "Failed to connect to authentication server. Ensure backend is running.",
      });
    } finally {
      setLoading(false);
    }
  };

  const handleUsePreset = (preset: (typeof DEMO_PRESETS)[0]) => {
    setEmailInput(preset.email);
    handleLookup(preset.email);
  };

  return (
    <div className="modal-backdrop" onClick={onClose}>
      <div className="modal-card" onClick={(e) => e.stopPropagation()}>
        <div className="modal-header">
          <div className="header-title-row">
            <span className="header-icon">🔐</span>
            <div>
              <h3 className="modal-title">Password Recovery & Assistance</h3>
              <p className="modal-subtitle">Recover access to your POS terminal or demo profile</p>
            </div>
          </div>
          <button type="button" className="close-btn" onClick={onClose}>✕</button>
        </div>

        <div className="modal-body">
          {/* Quick Demo Credentials Info */}
          <div className="demo-notice-card">
            <div className="demo-notice-header">
              <span className="badge-tag">Platform Demo Accounts</span>
              <span className="info-sub">Default Password: <strong>password123</strong></span>
            </div>
            <p className="demo-notice-text">
              If you are testing or evaluating KapMeta POS, click any profile below to autofill and recover access:
            </p>
            <div className="presets-grid">
              {DEMO_PRESETS.map((p) => (
                <button
                  key={p.role}
                  type="button"
                  className="preset-chip"
                  onClick={() => handleUsePreset(p)}
                >
                  <span className="preset-role">{p.role}</span>
                  <span className="preset-email">{p.email}</span>
                </button>
              ))}
            </div>
          </div>

          {/* Form */}
          <div className="input-group">
            <label className="input-label" htmlFor="forgot-email">
              Enter Registered Staff Email
            </label>
            <div className="field-row">
              <input
                id="forgot-email"
                type="email"
                className="modal-input"
                value={emailInput}
                onChange={(e) => setEmailInput(e.target.value)}
                placeholder="staff@hotelkapila.com"
              />
              <button
                type="button"
                className="btn-lookup"
                disabled={loading || !emailInput}
                onClick={() => handleLookup()}
              >
                {loading ? "Checking..." : "Verify / Recover →"}
              </button>
            </div>
          </div>

          {/* Result Banner */}
          {recoveryResult && (
            <div className={`result-box ${recoveryResult.isDemo ? "demo-success" : recoveryResult.ok ? "info-box" : "error-box"}`}>
              {recoveryResult.isDemo ? (
                <div>
                  <div className="result-headline">
                    <span>✅</span>
                    <strong>Standard Demo Account Verified!</strong>
                  </div>
                  <p className="result-message">
                    Credentials for <strong>{recoveryResult.user?.name || "Staff Member"}</strong> ({recoveryResult.user?.role || "Demo User"}):
                  </p>
                  <div className="credentials-pill">
                    <span>Password: <code>{recoveryResult.defaultPassword || "password123"}</code></span>
                    <span>Touch PIN: <code>1234</code></span>
                  </div>
                  <button
                    type="button"
                    className="btn-autofill-action"
                    onClick={() => {
                      onFillAndLogin(emailInput, recoveryResult.defaultPassword || "password123");
                      onClose();
                    }}
                  >
                    Auto-Fill Credentials & Sign In Now ⚡
                  </button>
                </div>
              ) : (
                <div>
                  <div className="result-headline">
                    <span>{recoveryResult.ok ? "📬" : "⚠️"}</span>
                    <strong>{recoveryResult.ok ? "Manager Notification Logged" : "Recovery Error"}</strong>
                  </div>
                  <p className="result-message">{recoveryResult.message}</p>
                  <p className="admin-instruction">
                    ℹ️ For security compliance, restaurant staff terminal passwords are reset by your Store Manager via <strong>Admin &gt; User Management</strong>.
                  </p>
                </div>
              )}
            </div>
          )}
        </div>

        <div className="modal-footer">
          <button type="button" className="btn-cancel" onClick={onClose}>
            Back to Sign In
          </button>
        </div>
      </div>

      <style jsx>{`
        .modal-backdrop {
          position: fixed;
          top: 0;
          left: 0;
          width: 100vw;
          height: 100vh;
          background: rgba(15, 23, 42, 0.6);
          backdrop-filter: blur(4px);
          display: flex;
          align-items: center;
          justify-content: center;
          z-index: 200;
          padding: 16px;
        }

        .modal-card {
          width: 100%;
          max-width: 480px;
          background: #ffffff;
          border-radius: 20px;
          border: 1px solid #e2e8f0;
          box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
          overflow: hidden;
          animation: slideUp 0.2s cubic-bezier(0.16, 1, 0.3, 1);
        }

        @keyframes slideUp {
          from {
            opacity: 0;
            transform: translateY(12px) scale(0.98);
          }
          to {
            opacity: 1;
            transform: translateY(0) scale(1);
          }
        }

        .modal-header {
          padding: 20px 24px 16px;
          border-bottom: 1px solid #f1f5f9;
          display: flex;
          align-items: center;
          justify-content: space-between;
        }

        .header-title-row {
          display: flex;
          align-items: center;
          gap: 12px;
        }

        .header-icon {
          font-size: 1.5rem;
        }

        .modal-title {
          margin: 0;
          font-size: 1.1rem;
          font-weight: 700;
          color: #0f172a;
        }

        .modal-subtitle {
          margin: 2px 0 0;
          font-size: 0.8125rem;
          color: #64748b;
        }

        .close-btn {
          background: transparent;
          border: none;
          font-size: 1.25rem;
          color: #94a3b8;
          cursor: pointer;
          width: 32px;
          height: 32px;
          display: flex;
          align-items: center;
          justify-content: center;
          border-radius: 8px;
        }

        .close-btn:hover {
          background: #f1f5f9;
          color: #334155;
        }

        .modal-body {
          padding: 20px 24px;
        }

        .demo-notice-card {
          background: #f8fafc;
          border: 1px solid #e2e8f0;
          border-radius: 12px;
          padding: 14px 16px;
          margin-bottom: 18px;
        }

        .demo-notice-header {
          display: flex;
          align-items: center;
          justify-content: space-between;
          margin-bottom: 6px;
        }

        .badge-tag {
          font-size: 0.72rem;
          font-weight: 800;
          text-transform: uppercase;
          background: #e0f2fe;
          color: #0284c7;
          padding: 2px 8px;
          border-radius: 6px;
        }

        .info-sub {
          font-size: 0.75rem;
          color: #475569;
        }

        .demo-notice-text {
          font-size: 0.8rem;
          color: #64748b;
          margin: 0 0 10px 0;
          line-height: 1.4;
        }

        .presets-grid {
          display: grid;
          grid-template-columns: repeat(2, 1fr);
          gap: 8px;
        }

        .preset-chip {
          background: #ffffff;
          border: 1px solid #cbd5e1;
          border-radius: 8px;
          padding: 8px 10px;
          text-align: left;
          cursor: pointer;
          transition: all 0.15s ease;
          display: flex;
          flex-direction: column;
        }

        .preset-chip:hover {
          border-color: #0284c7;
          background: #f0f9ff;
        }

        .preset-role {
          font-size: 0.78rem;
          font-weight: 700;
          color: #0f172a;
        }

        .preset-email {
          font-size: 0.7rem;
          color: #64748b;
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
        }

        .input-group {
          margin-bottom: 16px;
        }

        .input-label {
          display: block;
          font-size: 0.8125rem;
          font-weight: 600;
          color: #334155;
          margin-bottom: 6px;
        }

        .field-row {
          display: flex;
          gap: 8px;
        }

        .modal-input {
          flex: 1;
          padding: 10px 14px;
          border: 1px solid #cbd5e1;
          border-radius: 10px;
          font-size: 0.875rem;
          color: #0f172a;
          outline: none;
        }

        .modal-input:focus {
          border-color: #0284c7;
          box-shadow: 0 0 0 3px rgba(2, 132, 199, 0.12);
        }

        .btn-lookup {
          background: #0f172a;
          color: #ffffff;
          border: none;
          padding: 0 16px;
          border-radius: 10px;
          font-size: 0.8125rem;
          font-weight: 600;
          cursor: pointer;
          white-space: nowrap;
        }

        .btn-lookup:hover:not(:disabled) {
          background: #1e293b;
        }

        .btn-lookup:disabled {
          opacity: 0.5;
          cursor: not-allowed;
        }

        .result-box {
          margin-top: 14px;
          padding: 14px 16px;
          border-radius: 12px;
          font-size: 0.85rem;
        }

        .demo-success {
          background: #ecfdf5;
          border: 1px solid #a7f3d0;
          color: #065f46;
        }

        .info-box {
          background: #eff6ff;
          border: 1px solid #bfdbfe;
          color: #1e40af;
        }

        .error-box {
          background: #fef2f2;
          border: 1px solid #fecaca;
          color: #991b1b;
        }

        .result-headline {
          display: flex;
          align-items: center;
          gap: 6px;
          margin-bottom: 6px;
        }

        .result-message {
          margin: 0 0 10px 0;
          font-size: 0.8125rem;
          line-height: 1.4;
        }

        .credentials-pill {
          display: flex;
          gap: 12px;
          background: #ffffff;
          padding: 8px 12px;
          border-radius: 8px;
          border: 1px solid #cbd5e1;
          font-size: 0.8rem;
          margin-bottom: 12px;
        }

        .credentials-pill code {
          background: #f1f5f9;
          padding: 2px 6px;
          border-radius: 4px;
          font-weight: 700;
          color: #0f172a;
        }

        .btn-autofill-action {
          width: 100%;
          background: #10b981;
          color: #ffffff;
          border: none;
          padding: 10px;
          border-radius: 8px;
          font-weight: 700;
          font-size: 0.85rem;
          cursor: pointer;
          transition: background 0.15s ease;
        }

        .btn-autofill-action:hover {
          background: #059669;
        }

        .admin-instruction {
          font-size: 0.75rem;
          color: #64748b;
          margin: 6px 0 0 0;
        }

        .modal-footer {
          padding: 12px 24px;
          background: #f8fafc;
          border-top: 1px solid #f1f5f9;
          display: flex;
          justify-content: flex-end;
        }

        .btn-cancel {
          background: transparent;
          border: none;
          color: #64748b;
          font-size: 0.8125rem;
          font-weight: 600;
          cursor: pointer;
        }

        .btn-cancel:hover {
          color: #0f172a;
        }
      `}</style>
    </div>
  );
}
