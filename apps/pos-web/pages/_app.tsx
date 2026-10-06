import type { AppProps } from "next/app";
import React from "react";
import "../styles/globals.css";

import GlobalAlertModal from "../components/GlobalAlertModal";

function MyApp({ Component, pageProps }: AppProps) {
  return (
    <>
      <style
        dangerouslySetInnerHTML={{
          __html: `
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');

        :root {
          /* Unified Dark Theme - Backgrounds */
          --bg-base: #0b132b;
          --bg-card: #111c38;
          --bg-elevated: #1e293b;
          --bg-subtle: #070d1e;
          --bg-hover: #1e293b;
          
          /* Typography */
          --text-primary: #f8fafc;
          --text-secondary: #94a3b8;
          --text-muted: #64748b;
          
          /* Borders */
          --border: #1e293b;
          --border-strong: #334155;
          --border-subtle: #162244;
          
          /* Button Tokens: Primary, Secondary, Normal, Alert/Danger, Cancel, Success */
          --btn-primary-bg: #2563eb;
          --btn-primary-hover: #1d4ed8;
          --btn-primary-text: #ffffff;
          --btn-primary-border: #3b82f6;

          --btn-secondary-bg: #334155;
          --btn-secondary-hover: #475569;
          --btn-secondary-text: #f8fafc;
          --btn-secondary-border: #475569;

          --btn-normal-bg: #1e293b;
          --btn-normal-hover: #334155;
          --btn-normal-text: #94a3b8;
          --btn-normal-border: #334155;

          --btn-alert-bg: #dc2626;
          --btn-alert-hover: #b91c1c;
          --btn-alert-text: #ffffff;
          --btn-alert-border: #ef4444;
          --btn-alert-subtle-bg: rgba(239, 68, 68, 0.15);
          --btn-alert-subtle-text: #f87171;

          --btn-cancel-bg: #334155;
          --btn-cancel-hover: #475569;
          --btn-cancel-text: #cbd5e1;
          --btn-cancel-border: #475569;

          --btn-success-bg: #10b981;
          --btn-success-hover: #059669;
          --btn-success-text: #ffffff;
          --btn-success-border: #10b981;

          --btn-warning-bg: #d97706;
          --btn-warning-hover: #b45309;
          --btn-warning-text: #ffffff;
          --btn-warning-border: #f59e0b;

          /* Accents */
          --accent: #3b82f6;
          --accent-hover: #2563eb;
          --accent-subtle: rgba(59, 130, 246, 0.15);
          --accent-subtle-text: #93c5fd;
          --accent-glow: rgba(59, 130, 246, 0.25);
          
          --dark-btn: #1e293b;
          --dark-btn-hover: #334155;
          
          --warning: #f59e0b;
          --warning-subtle: rgba(245, 158, 11, 0.15);
          --warning-text: #fbbf24;
          
          --destructive: #ef4444;
          --destructive-subtle: rgba(239, 68, 68, 0.15);
          --destructive-text: #f87171;
          
          --blue-subtle: rgba(59, 130, 246, 0.15);
          --blue-text: #60a5fa;
          
          --purple-subtle: rgba(168, 85, 247, 0.15);
          --purple-text: #c084fc;

          --radius-sm: 6px;
          --radius-md: 10px;
          --radius-lg: 14px;
          --radius-pill: 9999px;
          
          --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.4);
          --shadow-card: 0 4px 6px -1px rgba(0, 0, 0, 0.3), 0 2px 4px -2px rgba(0, 0, 0, 0.3);
          --shadow-pop: 0 10px 15px -3px rgba(0, 0, 0, 0.4), 0 4px 6px -4px rgba(0, 0, 0, 0.4);
          --shadow-modal: 0 25px 50px -12px rgba(0, 0, 0, 0.7);
        }

        body {
          margin: 0;
          padding: 0;
          background-color: var(--bg-base);
          color: var(--text-primary);
          font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
          overflow-x: hidden;
          -webkit-font-smoothing: antialiased;
        }

        * {
          box-sizing: border-box;
        }

        /* Common Form & Input Styles */
        input, select, textarea, button {
          font-family: inherit;
        }

        /* Standardized Colorcode Button Hierarchy */
        .btn-primary, button.primary {
          background-color: var(--btn-primary-bg) !important;
          color: var(--btn-primary-text) !important;
          border: 1px solid var(--btn-primary-border) !important;
          padding: 8px 16px;
          border-radius: var(--radius-sm);
          font-weight: 600;
          font-size: 0.85rem;
          cursor: pointer;
          transition: all 0.15s ease;
          display: inline-flex;
          align-items: center;
          justify-content: center;
          gap: 6px;
        }
        .btn-primary:hover:not(:disabled), button.primary:hover:not(:disabled) {
          background-color: var(--btn-primary-hover) !important;
          box-shadow: 0 2px 8px rgba(37, 99, 235, 0.35);
        }

        .btn-secondary, button.secondary {
          background-color: var(--btn-secondary-bg) !important;
          color: var(--btn-secondary-text) !important;
          border: 1px solid var(--btn-secondary-border) !important;
          padding: 8px 16px;
          border-radius: var(--radius-sm);
          font-weight: 600;
          font-size: 0.85rem;
          cursor: pointer;
          transition: all 0.15s ease;
          display: inline-flex;
          align-items: center;
          justify-content: center;
          gap: 6px;
        }
        .btn-secondary:hover:not(:disabled), button.secondary:hover:not(:disabled) {
          background-color: var(--btn-secondary-hover) !important;
        }

        .btn-normal, .btn-outline, button.normal {
          background-color: var(--btn-normal-bg) !important;
          color: var(--btn-normal-text) !important;
          border: 1px solid var(--btn-normal-border) !important;
          padding: 8px 16px;
          border-radius: var(--radius-sm);
          font-weight: 600;
          font-size: 0.85rem;
          cursor: pointer;
          transition: all 0.15s ease;
          display: inline-flex;
          align-items: center;
          justify-content: center;
          gap: 6px;
        }
        .btn-normal:hover:not(:disabled), button.normal:hover:not(:disabled) {
          background-color: var(--btn-normal-hover) !important;
          color: #f8fafc !important;
        }

        .btn-alert, .btn-danger, button.danger {
          background-color: var(--btn-alert-bg) !important;
          color: var(--btn-alert-text) !important;
          border: 1px solid var(--btn-alert-border) !important;
          padding: 8px 16px;
          border-radius: var(--radius-sm);
          font-weight: 600;
          font-size: 0.85rem;
          cursor: pointer;
          transition: all 0.15s ease;
          display: inline-flex;
          align-items: center;
          justify-content: center;
          gap: 6px;
        }
        .btn-alert:hover:not(:disabled), .btn-danger:hover:not(:disabled), button.danger:hover:not(:disabled) {
          background-color: var(--btn-alert-hover) !important;
          box-shadow: 0 2px 8px rgba(220, 38, 38, 0.35);
        }

        .btn-cancel, button.cancel {
          background-color: var(--btn-cancel-bg) !important;
          color: var(--btn-cancel-text) !important;
          border: 1px solid var(--btn-cancel-border) !important;
          padding: 8px 16px;
          border-radius: var(--radius-sm);
          font-weight: 600;
          font-size: 0.85rem;
          cursor: pointer;
          transition: all 0.15s ease;
          display: inline-flex;
          align-items: center;
          justify-content: center;
          gap: 6px;
        }
        .btn-cancel:hover:not(:disabled), button.cancel:hover:not(:disabled) {
          background-color: var(--btn-cancel-hover) !important;
          color: #ffffff !important;
        }

        .btn-success, button.success {
          background-color: var(--btn-success-bg) !important;
          color: var(--btn-success-text) !important;
          border: 1px solid var(--btn-success-border) !important;
          padding: 8px 16px;
          border-radius: var(--radius-sm);
          font-weight: 600;
          font-size: 0.85rem;
          cursor: pointer;
          transition: all 0.15s ease;
          display: inline-flex;
          align-items: center;
          justify-content: center;
          gap: 6px;
        }
        .btn-success:hover:not(:disabled), button.success:hover:not(:disabled) {
          background-color: var(--btn-success-hover) !important;
          box-shadow: 0 2px 8px rgba(16, 185, 129, 0.35);
        }

        .btn-sm, button.small {
          padding: 4px 10px !important;
          font-size: 0.75rem !important;
        }

        /* Scrollbar */
        ::-webkit-scrollbar {
          width: 6px;
          height: 6px;
        }
        ::-webkit-scrollbar-track {
          background: transparent;
        }
        ::-webkit-scrollbar-thumb {
          background: #334155;
          border-radius: 9999px;
        }
        ::-webkit-scrollbar-thumb:hover {
          background: #475569;
        }

        /* Global Header/Topbar & Permission-Aware Navigation System */
        .topbar {
          height: 64px;
          background-color: var(--bg-card);
          border-bottom: 1px solid var(--border);
          display: flex;
          align-items: center;
          justify-content: space-between;
          padding: 0 24px;
          position: sticky;
          top: 0;
          z-index: 20;
          gap: 16px;
        }

        .topbar-left {
          display: flex;
          align-items: center;
          gap: 16px;
          flex-shrink: 0;
        }

        .topbar-right {
          display: flex;
          align-items: center;
          gap: 16px;
          flex-shrink: 0;
        }

        .brand-badge {
          display: flex;
          align-items: center;
          gap: 8px;
        }

        .brand-icon {
          width: 32px;
          height: 32px;
          border-radius: var(--radius-sm);
          background: var(--dark-btn);
          color: #fff;
          display: flex;
          align-items: center;
          justify-content: center;
          font-size: 1rem;
        }

        .brand-name {
          font-size: 1.125rem;
          font-weight: 800;
          letter-spacing: -0.5px;
          color: var(--text-primary);
        }

        /* Horizontal Scrollable Nav Pills */
        .nav-pill-group, .topbar-nav {
          display: flex;
          background-color: var(--bg-subtle);
          padding: 4px;
          border-radius: var(--radius-pill);
          border: 1px solid var(--border);
          gap: 4px;
          overflow-x: auto;
          scrollbar-width: none; /* Hide scrollbar for Firefox */
          -ms-overflow-style: none; /* Hide scrollbar for IE/Edge */
          max-width: 60%;
          flex-grow: 1;
        }

        .nav-pill-group::-webkit-scrollbar, .topbar-nav::-webkit-scrollbar {
          display: none; /* Hide scrollbar for Chrome/Safari */
        }

        .nav-item, .nav-pill {
          padding: 6px 16px;
          border-radius: var(--radius-pill);
          font-size: 0.8125rem;
          font-weight: 600;
          color: var(--text-secondary);
          text-decoration: none;
          transition: all 0.15s ease;
          white-space: nowrap;
          display: flex;
          align-items: center;
          gap: 6px;
        }

        .nav-item:hover, .nav-pill:hover {
          color: var(--text-primary);
          background-color: var(--bg-hover);
        }

        .nav-item.active, .nav-pill.active {
          background-color: var(--bg-card);
          color: var(--text-primary);
          box-shadow: var(--shadow-sm);
        }
      `,
        }}
      />
      <Component {...pageProps} />
      <GlobalAlertModal />
    </>
  );
}

export default MyApp;
