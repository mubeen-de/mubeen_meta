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
          /* Unified Clean Executive Light Theme */
          --bg-base: #f8fafc;
          --bg-card: #ffffff;
          --bg-elevated: #ffffff;
          --bg-subtle: #f1f5f9;
          --bg-hover: #f1f5f9;
          
          /* Typography */
          --text-primary: #0f172a;
          --text-secondary: #475569;
          --text-muted: #94a3b8;
          
          /* Borders */
          --border: #e2e8f0;
          --border-strong: #cbd5e1;
          --border-subtle: #f1f5f9;
          
          /* Button Tokens: Primary, Secondary, Normal, Alert/Danger, Cancel, Success */
          --btn-primary-bg: #2563eb;
          --btn-primary-hover: #1d4ed8;
          --btn-primary-text: #ffffff;
          --btn-primary-border: #2563eb;

          --btn-secondary-bg: #f1f5f9;
          --btn-secondary-hover: #e2e8f0;
          --btn-secondary-text: #0f172a;
          --btn-secondary-border: #cbd5e1;

          --btn-normal-bg: #ffffff;
          --btn-normal-hover: #f8fafc;
          --btn-normal-text: #475569;
          --btn-normal-border: #e2e8f0;

          --btn-alert-bg: #dc2626;
          --btn-alert-hover: #b91c1c;
          --btn-alert-text: #ffffff;
          --btn-alert-border: #ef4444;
          --btn-alert-subtle-bg: #fef2f2;
          --btn-alert-subtle-text: #dc2626;

          --btn-cancel-bg: #f1f5f9;
          --btn-cancel-hover: #e2e8f0;
          --btn-cancel-text: #475569;
          --btn-cancel-border: #cbd5e1;

          --btn-success-bg: #10b981;
          --btn-success-hover: #059669;
          --btn-success-text: #ffffff;
          --btn-success-border: #10b981;

          --btn-warning-bg: #d97706;
          --btn-warning-hover: #b45309;
          --btn-warning-text: #ffffff;
          --btn-warning-border: #f59e0b;

          /* Accents */
          --accent: #2563eb;
          --accent-hover: #1d4ed8;
          --accent-subtle: rgba(37, 99, 235, 0.08);
          --accent-subtle-text: #2563eb;
          --accent-glow: rgba(37, 99, 235, 0.2);
          
          --dark-btn: #0f172a;
          --dark-btn-hover: #1e293b;
          
          --warning: #d97706;
          --warning-subtle: #fffbeb;
          --warning-text: #b45309;
          
          --destructive: #dc2626;
          --destructive-subtle: #fef2f2;
          --destructive-text: #b91c1c;
          
          --blue-subtle: rgba(37, 99, 235, 0.08);
          --blue-text: #2563eb;
          
          --purple-subtle: rgba(124, 58, 237, 0.08);
          --purple-text: #7c3aed;

          --radius-sm: 6px;
          --radius-md: 10px;
          --radius-lg: 14px;
          --radius-pill: 9999px;
          
          --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
          --shadow-card: 0 1px 3px 0 rgba(0, 0, 0, 0.06), 0 1px 2px -1px rgba(0, 0, 0, 0.06);
          --shadow-pop: 0 10px 15px -3px rgba(0, 0, 0, 0.08), 0 4px 6px -4px rgba(0, 0, 0, 0.04);
          --shadow-modal: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.06);
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
          color: var(--text-primary) !important;
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
          color: var(--text-primary) !important;
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
          background: #cbd5e1;
          border-radius: 9999px;
        }
        ::-webkit-scrollbar-thumb:hover {
          background: #94a3b8;
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
          background: var(--btn-primary-bg, #2563eb);
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
