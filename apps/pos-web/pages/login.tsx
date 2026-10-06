import React, { useState, useEffect } from "react";
import Head from "next/head";
import { useRouter } from "next/router";
import { login, logout } from "../lib/auth";
import CaptainPinLoginModal from "../components/CaptainPinLoginModal";
import ForgotPasswordModal from "../components/ForgotPasswordModal";

// Human-readable messages for LoginFailure["reason"] (packages/shared-types/auth.ts).
const ERROR_MESSAGES: Record<string, string> = {
  INVALID_CREDENTIALS: "Incorrect email or password. Please try again.",
  USER_INACTIVE: "This account has been deactivated. Contact your outlet admin.",
  NO_OUTLET_ACCESS: "This account has no access to the outlet you entered.",
  NETWORK_ERROR: "Cannot reach API server (port 4001). Make sure the backend is running.",
  LOGIN_FAILED: "Login failed. Please verify credentials and try again.",
};

interface QuickRole {
  key: string;
  label: string;
  roleTitle: string;
  icon: string;
  email: string;
  password: string;
  outletId: string;
  targetPath: string;
}

const QUICK_ROLES: QuickRole[] = [
  {
    key: "admin",
    label: "ADMIN",
    roleTitle: "Super Admin / Owner",
    icon: "🛡️",
    email: "admin@hotelkapila.com",
    password: "password123",
    outletId: "11111111-1111-1111-1111-111111111111",
    targetPath: "/admin",
  },
  {
    key: "cashier",
    label: "CASHIER",
    roleTitle: "Front Desk Cashier",
    icon: "💳",
    email: "cashier@hotelkapila.com",
    password: "password123",
    outletId: "11111111-1111-1111-1111-111111111111",
    targetPath: "/",
  },
  {
    key: "chef",
    label: "CHEF",
    roleTitle: "Kitchen Display Staff",
    icon: "👨‍🍳",
    email: "chef@hotelkapila.com",
    password: "password123",
    outletId: "11111111-1111-1111-1111-111111111111",
    targetPath: "/kitchen",
  },
  {
    key: "waiter",
    label: "WAITER",
    roleTitle: "Floor Staff",
    icon: "🍽️",
    email: "waiter@hotelkapila.com",
    password: "password123",
    outletId: "11111111-1111-1111-1111-111111111111",
    targetPath: "/waiter",
  },
];

export default function LoginPage() {
  const router = useRouter();
  const [email, setEmail] = useState("admin@hotelkapila.com");
  const [password, setPassword] = useState("password123");
  const [outletId, setOutletId] = useState("11111111-1111-1111-1111-111111111111");
  const [error, setError] = useState<string | null>(null);
  const [errorDetail, setErrorDetail] = useState<string | null>(null);
  const [notice, setNotice] = useState<string | null>(null);
  const [submitting, setSubmitting] = useState(false);
  const [activeRoleKey, setActiveRoleKey] = useState<string | null>(null);
  const [isPinModalOpen, setIsPinModalOpen] = useState(false);
  const [isForgotPasswordModalOpen, setIsForgotPasswordModalOpen] = useState(false);

  const performLogin = async (eMail: string, pass: string, outId: string, targetPath = "/") => {
    setError(null);
    setErrorDetail(null);
    setNotice(`Authenticating ${eMail}...`);
    setSubmitting(true);

    const result = await login(eMail, pass, outId);

    if (result.ok === false) {
      const friendlyMsg = ERROR_MESSAGES[result.error] ?? ERROR_MESSAGES.LOGIN_FAILED;
      setError(friendlyMsg);
      // Show raw error code for debugging if it doesn't match a known code
      if (!ERROR_MESSAGES[result.error]) {
        setErrorDetail(`Error code: ${result.error}`);
      }
      setNotice(null);
      setSubmitting(false);
      setActiveRoleKey(null);
      return;
    }

    setNotice("✓ Login successful! Redirecting to dashboard...");
    setTimeout(() => {
      window.location.href = targetPath;
    }, 400);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    await performLogin(email, password, outletId, "/");
  };

  const handleQuickAccess = async (role: QuickRole) => {
    setActiveRoleKey(role.key);
    setEmail(role.email);
    setPassword(role.password);
    setOutletId(role.outletId);
    await performLogin(role.email, role.password, role.outletId, role.targetPath);
  };

  return (
    <div className="login-app">
      <Head>
        <title>KapMeta POS — Sign In</title>
        <meta name="description" content="Sign in to the KapMeta POS console." />
      </Head>

      <div className="login-card">
        {/* Brand Header */}
        <div className="brand-header">
          <h1 className="welcome-title">Welcome back!</h1>
          <p className="welcome-subtitle">Access your unified enterprise gateway dashboard.</p>
        </div>

        {/* Live Notification Bar */}
        {notice && (
          <div className="notification-banner success">
            <span className="notif-icon">✨</span>
            <span>{notice}</span>
          </div>
        )}

        {error && (
          <div className="notification-banner error">
            <span className="notif-icon">⚠️</span>
            <span>{error}{errorDetail ? ` (${errorDetail})` : ""}</span>
          </div>
        )}

        {/* Form */}
        <form onSubmit={handleSubmit} className="login-form">
          <div className="field-group">
            <label className="field-label" htmlFor="email">
              Username / Email
            </label>
            <div className="input-wrapper">
              <span className="input-icon">👤</span>
              <input
                id="email"
                type="email"
                required
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                className="field-input"
                placeholder="account@hotelkapila.com"
                autoComplete="username"
              />
            </div>
          </div>

          <div className="field-group">
            <div className="field-label-row">
              <label className="field-label" htmlFor="password">
                Password
              </label>
              <button
                type="button"
                className="forgot-password"
                onClick={() => setIsForgotPasswordModalOpen(true)}
              >
                Forgot Password?
              </button>
            </div>
            <div className="input-wrapper">
              <span className="input-icon">🔒</span>
              <input
                id="password"
                type="password"
                required
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="field-input"
                placeholder="••••••••"
                autoComplete="current-password"
              />
            </div>
          </div>

          <div className="field-group">
            <label className="field-label" htmlFor="outletId">
              Outlet ID
            </label>
            <div className="input-wrapper">
              <span className="input-icon">🏢</span>
              <input
                id="outletId"
                type="text"
                required
                value={outletId}
                onChange={(e) => setOutletId(e.target.value)}
                className="field-input"
                placeholder="11111111-1111-1111-1111-111111111111"
                autoComplete="off"
              />
            </div>
          </div>

          <button type="submit" className="submit-btn" disabled={submitting}>
            {submitting ? "Signing in..." : "Sign In →"}
          </button>
        </form>

        {/* Quick Access Section */}
        <div className="quick-access-section">
          <div className="quick-access-divider">
            <span>QUICK ACCESS</span>
          </div>

          <div className="quick-access-buttons">
            {QUICK_ROLES.map((role) => {
              const isActive = activeRoleKey === role.key;
              return (
                <button
                  key={role.key}
                  type="button"
                  className={`quick-access-btn ${isActive ? "active" : ""}`}
                  disabled={submitting}
                  onClick={() => handleQuickAccess(role)}
                  title={`Sign in directly as ${role.roleTitle}`}
                >
                  <div className="icon-circle">
                    {isActive ? "⏳" : role.icon}
                  </div>
                  <span className="role-label">{role.label}</span>
                </button>
              );
            })}
          </div>

          <div style={{ marginTop: "16px", paddingTop: "14px", borderTop: "1px dashed var(--border)" }}>
            <button
              type="button"
              className="fast-pin-btn"
              onClick={() => setIsPinModalOpen(true)}
            >
              <span style={{ fontSize: "1.1rem" }}>⚡</span>
              <span>Fast Captain / Waiter Touch PIN Login</span>
            </button>
          </div>
        </div>
      </div>

      <CaptainPinLoginModal
        isOpen={isPinModalOpen}
        onClose={() => setIsPinModalOpen(false)}
        onSuccess={() => {
          router.push("/waiter");
        }}
        outletId={outletId}
      />

      <ForgotPasswordModal
        isOpen={isForgotPasswordModalOpen}
        onClose={() => setIsForgotPasswordModalOpen(false)}
        initialEmail={email}
        initialOutletId={outletId}
        onFillAndLogin={(fillEmail, fillPass) => {
          setEmail(fillEmail);
          setPassword(fillPass);
          performLogin(fillEmail, fillPass, outletId, "/");
        }}
      />

      <style jsx>{`
        .login-app {
          min-height: 100vh;
          display: flex;
          align-items: center;
          justify-content: center;
          background: var(--bg-base);
          font-family: "Inter", system-ui, -apple-system, sans-serif;
          color: var(--text-primary);
          padding: 20px;
        }

        .login-card {
          width: 100%;
          max-width: 440px;
          background: var(--bg-card);
          border: 1px solid var(--border-strong);
          border-radius: 24px;
          padding: 40px 36px;
          box-shadow: var(--shadow-modal);
        }

        .brand-header {
          margin-bottom: 24px;
        }

        .welcome-title {
          font-size: 28px;
          font-weight: 800;
          color: var(--text-primary);
          margin: 0 0 6px 0;
          letter-spacing: -0.5px;
        }

        .welcome-subtitle {
          font-size: 14px;
          color: var(--text-secondary);
          margin: 0;
          line-height: 1.5;
        }

        .notification-banner {
          display: flex;
          align-items: center;
          gap: 8px;
          padding: 12px 16px;
          border-radius: 12px;
          font-size: 13px;
          font-weight: 600;
          margin-bottom: 20px;
          animation: fadeIn 0.2s ease-in-out;
        }

        .notification-banner.success {
          background: rgba(16, 185, 129, 0.15);
          color: #34d399;
          border: 1px solid rgba(16, 185, 129, 0.3);
        }

        .notification-banner.error {
          background: rgba(239, 68, 68, 0.15);
          color: #f87171;
          border: 1px solid rgba(239, 68, 68, 0.3);
        }

        .notif-icon {
          font-size: 16px;
        }

        .login-form {
          display: flex;
          flex-direction: column;
          gap: 18px;
        }

        .field-group {
          display: flex;
          flex-direction: column;
          gap: 6px;
        }

        .field-label-row {
          display: flex;
          justify-content: space-between;
          align-items: center;
        }

        .field-label {
          font-size: 13px;
          font-weight: 600;
          color: var(--text-secondary);
        }

        .forgot-password {
          background: transparent;
          border: none;
          padding: 0;
          font-size: 12px;
          font-weight: 600;
          color: #3b82f6;
          cursor: pointer;
          transition: color 0.15s ease;
        }

        .forgot-password:hover {
          color: #60a5fa;
          text-decoration: underline;
        }

        .input-wrapper {
          position: relative;
          display: flex;
          align-items: center;
        }

        .input-icon {
          position: absolute;
          left: 14px;
          font-size: 16px;
          color: var(--text-muted);
          pointer-events: none;
        }

        .field-input {
          width: 100%;
          padding: 12px 14px 12px 42px;
          border-radius: 12px;
          border: 1px solid var(--border-strong);
          background: var(--bg-subtle);
          font-size: 14px;
          color: var(--text-primary);
          outline: none;
          transition: all 0.15s ease;
        }

        .field-input:focus {
          border-color: var(--btn-primary-bg);
          box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.25);
        }

        .submit-btn {
          margin-top: 10px;
          padding: 14px;
          background: var(--btn-primary-bg);
          color: var(--btn-primary-text);
          border: 1px solid var(--btn-primary-border);
          border-radius: 14px;
          font-size: 15px;
          font-weight: 700;
          cursor: pointer;
          transition: all 0.15s ease;
          display: flex;
          justify-content: center;
          align-items: center;
        }

        .submit-btn:hover:not(:disabled) {
          background: var(--btn-primary-hover);
          box-shadow: 0 4px 14px rgba(37, 99, 235, 0.4);
          transform: translateY(-1px);
        }

        .submit-btn:disabled {
          opacity: 0.6;
          cursor: not-allowed;
        }

        .quick-access-section {
          margin-top: 36px;
        }

        .quick-access-divider {
          display: flex;
          align-items: center;
          text-align: center;
          margin-bottom: 24px;
        }

        .quick-access-divider::before,
        .quick-access-divider::after {
          content: "";
          flex: 1;
          border-bottom: 1px solid var(--border);
        }

        .quick-access-divider span {
          padding: 0 16px;
          color: var(--text-muted);
          font-size: 11px;
          font-weight: 700;
          letter-spacing: 1.2px;
        }

        .quick-access-buttons {
          display: flex;
          justify-content: space-around;
          align-items: center;
          gap: 16px;
        }

        .quick-access-btn {
          background: transparent;
          border: none;
          display: flex;
          flex-direction: column;
          align-items: center;
          gap: 8px;
          cursor: pointer;
          padding: 6px;
          transition: transform 0.15s ease;
        }

        .quick-access-btn:hover:not(:disabled) {
          transform: translateY(-2px);
        }

        .quick-access-btn:disabled {
          opacity: 0.5;
          cursor: not-allowed;
        }

        .icon-circle {
          width: 58px;
          height: 58px;
          border-radius: 50%;
          border: 1.5px solid var(--border-strong);
          background: var(--bg-elevated);
          display: flex;
          align-items: center;
          justify-content: center;
          font-size: 22px;
          box-shadow: var(--shadow-sm);
          transition: all 0.2s ease;
        }

        .quick-access-btn:hover .icon-circle {
          border-color: #3b82f6;
          background: var(--bg-hover);
          box-shadow: 0 6px 16px rgba(37, 99, 235, 0.25);
        }

        .quick-access-btn.active .icon-circle {
          border-color: #3b82f6;
          background: rgba(59, 130, 246, 0.2);
        }

        .role-label {
          font-size: 11px;
          font-weight: 700;
          color: var(--text-secondary);
          letter-spacing: 0.5px;
        }

        .fast-pin-btn {
          width: 100%;
          display: flex;
          align-items: center;
          justify-content: center;
          gap: 8px;
          padding: 10px 14px;
          border-radius: 10px;
          border: 1px solid rgba(59, 130, 246, 0.3);
          background: rgba(59, 130, 246, 0.15);
          color: #60a5fa;
          font-weight: 700;
          font-size: 0.8125rem;
          cursor: pointer;
          transition: all 0.15s ease;
        }

        .fast-pin-btn:hover {
          background: rgba(59, 130, 246, 0.25);
          box-shadow: 0 4px 12px rgba(37, 99, 235, 0.2);
        }

        @keyframes fadeIn {
          from {
            opacity: 0;
            transform: translateY(-4px);
          }
          to {
            opacity: 1;
            transform: translateY(0);
          }
        }
      `}</style>
    </div>
  );
}
