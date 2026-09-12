// Shared permission-aware nav for pos-web. Renders only the links whose
// required permission is present in the current user's real GET /auth/me
// permissions array (fetched via fetchMe()/getSession() from lib/auth.ts —
// no hardcoded permission lists per repo CLAUDE.md). Each page previously
// hardcoded its own <nav> with links to every page regardless of what the
// user's role actually granted; a user with only "order.create" would still
// see (and could click into, then get redirected away from) /admin, /kitchen,
// /inventory. This component centralizes that logic so all pages agree.
import React, { useEffect, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/router";
import { fetchMe, fetchMyOutlets, switchOutlet, logout, MeOutlet, OutletSummary } from "../lib/auth";
import QuickLinks from "./QuickLinks";

interface NavLinkDef {
  href: string;
  permission: string;
  topbarLabel: string;
  pillLabel: string;
}

// Order matches the nav markup that existed inline in each page before this
// component was introduced.
const NAV_LINKS: NavLinkDef[] = [
  { href: "/", permission: "order.create", topbarLabel: "POS Terminal", pillLabel: "🛒 POS Register" },
  { href: "/waiter", permission: "order.create", topbarLabel: "Waiter App", pillLabel: "🏃 Waiter App" },
  { href: "/orders?tab=live", permission: "order.read", topbarLabel: "Live Orders", pillLabel: "🔴 Live Orders" },
  { href: "/orders?tab=all", permission: "order.read", topbarLabel: "All Orders", pillLabel: "📋 All Orders" },
  { href: "/orders?tab=online", permission: "order.read", topbarLabel: "Online Orders", pillLabel: "🌐 Online Orders" },
  { href: "/kitchen", permission: "kot.read", topbarLabel: "KDS Kitchen Board", pillLabel: "🍳 Kitchen KDS" },
  { href: "/inventory", permission: "inventory.read", topbarLabel: "Stock & 86-List", pillLabel: "📦 Stock Control" },
  { href: "/menu", permission: "menu.category.manage", topbarLabel: "Menu Management", pillLabel: "🍽️ Menu Management" },
  { href: "/channel-availability", permission: "integration.manage", topbarLabel: "Online Item Status", pillLabel: "📡 Online Status" },
  { href: "/admin?tab=analytics", permission: "report.read", topbarLabel: "Sales Analytics", pillLabel: "📊 Sales Reports" },
  { href: "/finance", permission: "report.read", topbarLabel: "Finance & Z-Report", pillLabel: "💰 Finance" },
  { href: "/crm", permission: "crm.read", topbarLabel: "Customers & Loyalty", pillLabel: "🎁 Customers" },
  { href: "/marketing", permission: "crm.write", topbarLabel: "Marketing Campaigns", pillLabel: "📣 Marketing" },
  { href: "/user-management", permission: "users.manage", topbarLabel: "User & Role Management", pillLabel: "🧑‍💼 Users & Roles" },
];

export type NavVariant = "topbar" | "pill" | "sidebar";

/* ------------------------------------------------------------------------ */
/* SIDEBAR_GROUPS - the single source of truth for app navigation.           */
/*                                                                          */
/* Both nav surfaces render from this list:                                 */
/*   - <Nav variant="sidebar" />         (the persistent sidebar)           */
/*   - components/KapMetaHeader.tsx      (the POS hamburger drawer)         */
/* A link added here therefore shows up in both. Do not hardcode a nav link */
/* anywhere else - that is exactly what produced two divergent taxonomies   */
/* and the "I can't find it" incidents recorded in                          */
/* docs/03-design/artifact-03-design-contract.md section 6.                 */
/*                                                                          */
/* Structure/labels/order follow the reference design:                      */
/*   Dashboard | Daily Operations | Menu | Inventory |                      */
/*   Marketing Automation [New] | Finance [New] | Reports | Management |    */
/*   CRM | Aggregator Center | Quick Links                                  */
/* ------------------------------------------------------------------------ */

export interface SidebarLinkDef {
  href: string;
  // Permission required to see the link. Keep this equal to the permission
  // the destination page guards with (useAuthGuard) - otherwise the link is
  // either invisible to users who may use it, or visible to users the page
  // immediately redirects away.
  permission: string;
  label: string;
  // Escape hatch for links that must stay reachable from the POS terminal
  // regardless of the cashier's permission set. The page's own useAuthGuard
  // still decides whether they can actually open it.
  alwaysVisible?: boolean;
  // Drawer-only in-place action (opens a modal instead of navigating). The
  // sidebar falls back to `href` for these.
  action?: "item-toggle";
}

export interface SidebarGroupDef {
  // Stable id - used as the React key, the drawer's expand/collapse state key
  // and the drawer's icon lookup.
  id: string;
  header: string | null; // null => single-link group, rendered directly (no header)
  badge?: string;
  links: SidebarLinkDef[];
}

export const SIDEBAR_GROUPS: SidebarGroupDef[] = [
  {
    id: "dashboard",
    header: null,
    links: [{ href: "/admin?tab=daily-ops", permission: "report.read", label: "Dashboard" }],
  },
  {
    id: "daily-operations",
    header: "Daily Operations",
    links: [
      // POS Terminal and Waiter App are not in the reference sidebar, but they
      // are this app's primary operating surfaces and dropping them would make
      // the POS unreachable from the nav. They lead the group.
      { href: "/", permission: "order.create", label: "POS Terminal" },
      { href: "/waiter", permission: "order.create", label: "Waiter App" },
      { href: "/orders?tab=live", permission: "order.read", label: "Live Orders" },
      { href: "/orders?tab=all", permission: "order.read", label: "All Orders" },
      { href: "/orders?tab=online", permission: "order.read", label: "Online Orders" },
      { href: "/kitchen", permission: "kot.read", label: "KOT" },
    ],
  },
  {
    id: "menu",
    header: "Menu",
    links: [
      { href: "/menu", permission: "menu.category.manage", label: "Menu Management" },
      {
        href: "/inventory",
        permission: "menu.86.toggle",
        label: "Menu Item On/Off (86 Stock)",
        action: "item-toggle",
      },
    ],
  },
  {
    id: "inventory",
    header: null,
    // pages/inventory.tsx guards on menu.read
    links: [{ href: "/inventory", permission: "menu.read", label: "Inventory" }],
  },
  {
    id: "marketing",
    header: null,
    badge: "New",
    links: [{ href: "/marketing", permission: "crm.write", label: "Marketing Automation" }],
  },
  {
    id: "finance",
    header: null,
    badge: "New",
    links: [{ href: "/finance", permission: "report.read", label: "Finance" }],
  },
  {
    id: "reports",
    header: "Reports",
    links: [
      { href: "/admin?tab=analytics", permission: "report.read", label: "Sales Analytics" },
      { href: "/finance", permission: "report.read", label: "Day-End Settlement / Z-Report" },
      { href: "/kitchen-analytics", permission: "report.read", label: "Kitchen Prep Times" },
      { href: "/waiter-monitor", permission: "report.read", label: "Waiter Floor Monitor" },
      { href: "/admin?tab=audit", permission: "report.read", label: "Audit Log" },
    ],
  },
  {
    id: "management",
    header: "Management",
    links: [
      // alwaysVisible: these two were the "I can't find it" incidents this
      // session. They must stay reachable from the POS terminal drawer even
      // for roles without users.manage / settings.manage.
      { href: "/user-management", permission: "users.manage", label: "User & Role Management", alwaysVisible: true },
      { href: "/settings/company", permission: "settings.manage", label: "Company Details", alwaysVisible: true },
      // pages/table-management.tsx guards on menu.category.manage
      { href: "/table-management", permission: "menu.category.manage", label: "Table Management" },
      { href: "/admin", permission: "report.read", label: "Admin Overview Hub" },
      { href: "/admin?tab=agents", permission: "report.read", label: "Multi-Agent & A2A Status" },
    ],
  },
  {
    id: "crm",
    header: "CRM",
    links: [{ href: "/crm", permission: "crm.read", label: "Customers & Loyalty" }],
  },
  {
    id: "aggregator-center",
    header: "Aggregator Center",
    links: [
      { href: "/integrations", permission: "integration.manage", label: "Connect Delivery Apps" },
      { href: "/channel-availability", permission: "integration.manage", label: "Online Item Status" },
    ],
  },
];

// Icon per SIDEBAR_GROUPS group id. Shared across <Nav variant="sidebar" />
// and <KapMetaHeader /> drawer so both surfaces draw identical icons.
export function drawerGroupIcon(id: string): JSX.Element {
  const common = {
    width: 22,
    height: 22,
    viewBox: "0 0 24 24",
    fill: "none",
    stroke: "#ffffff",
    strokeWidth: 2,
    "aria-hidden": true,
  } as const;

  switch (id) {
    case "dashboard":
      return (
        <svg {...common}>
          <line x1="4" y1="21" x2="4" y2="14" />
          <line x1="4" y1="10" x2="4" y2="3" />
          <line x1="12" y1="21" x2="12" y2="12" />
          <line x1="12" y1="8" x2="12" y2="3" />
          <line x1="20" y1="21" x2="20" y2="16" />
          <line x1="20" y1="12" x2="20" y2="3" />
          <line x1="1" y1="14" x2="7" y2="14" />
          <line x1="9" y1="8" x2="15" y2="8" />
          <line x1="17" y1="16" x2="23" y2="16" />
        </svg>
      );
    case "daily-operations":
      return (
        <svg {...common}>
          <polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2" />
        </svg>
      );
    case "menu":
      return (
        <svg {...common}>
          <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
          <polyline points="14 2 14 8 20 8" />
          <line x1="16" y1="13" x2="8" y2="13" />
          <line x1="16" y1="17" x2="8" y2="17" />
        </svg>
      );
    case "inventory":
      return (
        <svg {...common}>
          <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />
          <polyline points="3.27 6.96 12 12.01 20.73 6.96" />
          <line x1="12" y1="22.08" x2="12" y2="12" />
        </svg>
      );
    case "marketing":
      return (
        <svg {...common}>
          <path d="M3 11v2a1 1 0 0 0 1 1h3l5 4V6L7 10H4a1 1 0 0 0-1 1z" />
          <path d="M16 8a5 5 0 0 1 0 8" />
        </svg>
      );
    case "finance":
      return (
        <svg {...common}>
          <line x1="12" y1="1" x2="12" y2="23" />
          <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6" />
        </svg>
      );
    case "reports":
      return (
        <svg {...common}>
          <polyline points="22 12 18 12 15 21 9 3 6 12 2 12" />
        </svg>
      );
    case "management":
      return (
        <svg {...common}>
          <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
        </svg>
      );
    case "crm":
      return (
        <svg {...common}>
          <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
          <circle cx="9" cy="7" r="4" />
          <path d="M23 21v-2a4 4 0 0 0-3-3.87" />
          <path d="M16 3.13a4 4 0 0 1 0 7.75" />
        </svg>
      );
    case "aggregator-center":
      return (
        <svg {...common}>
          <path d="M4.93 19.07A10 10 0 0 1 12 16a10 10 0 0 1 7.07 3.07M1.39 15.54A15 15 0 0 1 12 11a15 15 0 0 1 10.61 4.54M8.46 22.54A5 5 0 0 1 12 21a5 5 0 0 1 3.54 1.54" />
          <circle cx="12" cy="11" r="1.5" fill="#ffffff" />
        </svg>
      );
    case "updates":
      return (
        <svg {...common}>
          <polyline points="23 4 23 10 17 10" />
          <polyline points="1 20 1 14 7 14" />
          <path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15" />
        </svg>
      );
    case "logout":
      return (
        <svg {...common}>
          <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4" />
          <polyline points="16 17 21 12 16 7" />
          <line x1="21" y1="12" x2="9" y2="12" />
        </svg>
      );
    default:
      return (
        <svg {...common}>
          <circle cx="12" cy="12" r="9" />
        </svg>
      );
  }
}

// Mirrors the super-admin bypass in useAuthGuard (lib/auth.ts): these roles
// can open every screen, so the nav must not hide anything from them.
export function isSuperAdminRoles(roles: string[] | null | undefined): boolean {
  if (!Array.isArray(roles)) return false;
  return roles.includes("SUPER_ADMIN") || roles.includes("SUPERADMIN") || roles.includes("OWNER");
}

// Shared filter used by BOTH nav surfaces: drop the links whose permission the
// user lacks, then drop any group left with no visible links.
export function filterSidebarGroups(
  permissions: string[] | null | undefined,
  roles?: string[] | null
): SidebarGroupDef[] {
  const perms = Array.isArray(permissions) ? permissions : [];
  const superAdmin = isSuperAdminRoles(roles);
  return SIDEBAR_GROUPS.map((group) => ({
    ...group,
    links: group.links.filter(
      (link) => superAdmin || link.alwaysVisible || perms.includes(link.permission)
    ),
  })).filter((group) => group.links.length > 0);
}

interface NavProps {
  variant?: NavVariant;
}

export default function Nav({ variant = "pill" }: NavProps): JSX.Element | null {
  const router = useRouter();
  const [permissions, setPermissions] = useState<string[] | null>(null);
  const [roles, setRoles] = useState<string[]>([]);
  const [currentOutlet, setCurrentOutlet] = useState<MeOutlet | null>(null);
  const [myOutlets, setMyOutlets] = useState<OutletSummary[]>([]);
  const [switching, setSwitching] = useState(false);
  const [billerName, setBillerName] = useState("");
  const [outletCode, setOutletCode] = useState("");
  const [appVersion, setAppVersion] = useState<string | null>(null);

  // Left Drawer expanded submenu state, keyed by SIDEBAR_GROUPS group id.
  const [expandedGroups, setExpandedGroups] = useState<Record<string, boolean>>({
    "daily-operations": true,
  });

  useEffect(() => {
    let cancelled = false;
    fetchMe().then((me) => {
      if (cancelled) return;
      setPermissions(me ? me.permissions : []);
      setRoles(me && Array.isArray(me.roles) ? me.roles : []);
      setCurrentOutlet(me ? me.outlet : null);
      if (me) {
        setBillerName(me.name || "");
        setOutletCode(me.outlet?.code || "");
      }
    });
    fetchMyOutlets().then((outlets) => {
      if (cancelled) return;
      setMyOutlets(outlets);
    });
    fetch("/api/app-version")
      .then((r) => (r.ok ? r.json() : null))
      .then((d) => {
        if (!cancelled && d?.version) setAppVersion(d.version);
      })
      .catch(() => {});
    return () => {
      cancelled = true;
    };
  }, []);

  // Automatically expand whichever group contains the active route
  useEffect(() => {
    const currentPath = router.asPath;
    const matchingGroup = SIDEBAR_GROUPS.find((g) =>
      g.links.some((l) => (l.href.includes("?") ? currentPath === l.href : router.pathname === l.href))
    );
    if (matchingGroup && matchingGroup.header) {
      setExpandedGroups((prev) => ({ ...prev, [matchingGroup.id]: true }));
    }
  }, [router.asPath, router.pathname]);

  const handleOutletChange = async (newOutletId: string) => {
    if (!newOutletId || switching) return;
    setSwitching(true);
    const result = await switchOutlet(newOutletId);
    if (result.ok) {
      window.location.reload();
    } else {
      setSwitching(false);
      alert("Failed to switch outlet. Please try again.");
    }
  };

  const outletSwitcher =
    myOutlets.length > 1 ? (
      <select
        value={currentOutlet?.id || ""}
        disabled={switching}
        onChange={(e) => handleOutletChange(e.target.value)}
        style={{
          cursor: switching ? "wait" : "pointer",
          background: "var(--bg-card, #fff)",
          border: "1px solid var(--border, #e2e8f0)",
          color: "var(--text-primary)",
          fontWeight: 600,
          padding: "10px 12px",
          minHeight: "44px",
          borderRadius: "var(--radius-pill, 9999px)",
          whiteSpace: "nowrap",
          flexShrink: 0,
        }}
      >
        {myOutlets.map((outlet) => (
          <option key={outlet.id} value={outlet.id}>
            {outlet.name} ({outlet.code})
          </option>
        ))}
      </select>
    ) : null;

  // Until we know the real permission set, render nothing rather than a
  // flash of links the user may not be allowed to see.
  if (permissions === null) return null;

  const visibleLinks = NAV_LINKS.filter((link) => permissions.includes(link.permission));

  const isActive = (href: string): boolean =>
    href.includes("?") ? router.asPath === href : router.pathname === href;

  const logoutButton = (
    <button
      type="button"
      onClick={() => {
        if (confirm("Are you sure you want to log out?")) {
          logout().catch(() => {});
        }
      }}
      className="logout-btn"
      style={{
        cursor: "pointer",
        background: "rgba(239, 68, 68, 0.08)",
        border: "1px solid rgba(239, 68, 68, 0.2)",
        color: "var(--destructive)",
        fontWeight: 600,
        display: "inline-flex",
        alignItems: "center",
        gap: "6px",
        padding: "10px 16px",
        minHeight: "44px",
        borderRadius: "var(--radius-pill)",
        whiteSpace: "nowrap",
        flexShrink: 0,
      }}
    >
      Logout 🚪
    </button>
  );

  if (variant === "topbar") {
    return (
      <div style={{ display: "flex", alignItems: "center", gap: "12px", flexGrow: 1, justifyContent: "center", minWidth: 0 }}>
        <nav className="topbar-nav" style={{ flexGrow: 1, maxWidth: "75%" }}>
          {visibleLinks.map((link) => (
            <Link
              key={link.href}
              href={link.href}
              className={`nav-pill ${isActive(link.href) ? "active" : ""}`}
            >
              {link.topbarLabel}
            </Link>
          ))}
        </nav>
        {outletSwitcher}
        {logoutButton}
      </div>
    );
  }

  if (variant === "sidebar") {
    const visibleGroups = filterSidebarGroups(permissions, roles);

    return (
      <aside className="sidebar-nav" aria-label="Main Navigation">
        {/* 1. Header: "Settings" with Left Arrow */}
        <div className="drawer-header-bar">
          <h2 className="drawer-title-text">Settings</h2>
          <Link
            href="/"
            className="drawer-back-arrow-btn"
            aria-label="Back to POS Terminal"
            title="Back to POS Terminal"
          >
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#ffffff" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
              <line x1="19" y1="12" x2="5" y2="12" />
              <polyline points="12 19 5 12 12 5" />
            </svg>
          </Link>
        </div>

        {/* Optional Outlet Switcher */}
        {myOutlets.length > 1 && (
          <div className="sidebar-outlet-switcher-wrap">
            <select
              value={currentOutlet?.id || ""}
              disabled={switching}
              onChange={(e) => handleOutletChange(e.target.value)}
              className="sidebar-outlet-select"
            >
              {myOutlets.map((outlet) => (
                <option key={outlet.id} value={outlet.id}>
                  {outlet.name} ({outlet.code})
                </option>
              ))}
            </select>
          </div>
        )}

        {/* 2. Menu Navigation Items List */}
        <div className="drawer-menu-items-scroll">
          {visibleGroups.map((group) => {
            if (group.header === null) {
              const link = group.links[0];
              const active = isActive(link.href);
              return (
                <button
                  type="button"
                  key={group.id}
                  className={`menu-row-item ${active ? "is-selected" : ""}`}
                  style={{ display: "flex", flexDirection: "row", alignItems: "center" }}
                  onClick={() => router.push(link.href)}
                >
                  <div className="item-icon-col" style={{ display: "flex", alignItems: "center", flexShrink: 0 }}>
                    {drawerGroupIcon(group.id)}
                  </div>
                  <span className="item-label-text">{link.label}</span>
                  {group.badge && <span className="item-new-badge">{group.badge}</span>}
                </button>
              );
            }

            const isExpanded = Boolean(expandedGroups[group.id]);
            const isGroupActive = group.links.some((l) => isActive(l.href));

            return (
              <React.Fragment key={group.id}>
                <button
                  type="button"
                  className={`menu-row-item ${isGroupActive ? "is-selected" : ""}`}
                  aria-expanded={isExpanded}
                  onClick={() => {
                    setExpandedGroups((prev) => ({ ...prev, [group.id]: !prev[group.id] }));
                  }}
                >
                  <div className="item-icon-col">{drawerGroupIcon(group.id)}</div>
                  <span className="item-label-text">{group.header}</span>
                  {group.badge && <span className="item-new-badge">{group.badge}</span>}
                  <span className={`chevron-indicator ${isExpanded ? "open" : ""}`}>
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#94a3b8" strokeWidth="2.5" aria-hidden="true">
                      <polyline points="6 9 12 15 18 9" />
                    </svg>
                  </span>
                </button>

                {isExpanded && (
                  <div className="submenu-container">
                    {group.links.map((link) => {
                      const active = isActive(link.href);
                      return (
                        <Link
                          key={`${group.id}-${link.label}`}
                          href={link.href}
                          className={`submenu-link ${active ? "active" : ""}`}
                        >
                          {link.label}
                        </Link>
                      );
                    })}
                  </div>
                )}
              </React.Fragment>
            );
          })}

          {/* Drawer-only item: Check Updates */}
          <button
            type="button"
            className="menu-row-item"
            onClick={() => {
              alert(`Checking kapMeta POS System Updates...\n\nCurrent Version: ${appVersion || "0.1.0"}\nDatabase: Synchronized\nStatus: Up to date (Latest Stable Release).`);
            }}
          >
            <div className="item-icon-col">{drawerGroupIcon("updates")}</div>
            <span className="item-label-text">Check Updates</span>
          </button>

          {/* Drawer-only item: Logout */}
          <button
            type="button"
            className="menu-row-item"
            onClick={() => {
              if (confirm("Are you sure you want to log out of kapMeta POS?")) {
                logout().catch(() => {});
              }
            }}
          >
            <div className="item-icon-col">{drawerGroupIcon("logout")}</div>
            <span className="item-label-text">Logout</span>
          </button>
        </div>

        {/* 3. Bottom Metadata Block (Ref ID, Version, Biller Name) */}
        <div className="drawer-footer-metadata-block">
          <div className="meta-row-header">
            <span className="meta-ref-id">Ref ID : {outletCode || "MAIN-01"}</span>
            <span className="meta-version">Version : {appVersion || "0.1.0"}</span>
          </div>
          <div className="meta-row-biller">
            <span className="meta-biller-name">Biller Name : {billerName || "—"}</span>
          </div>
        </div>

        <style jsx>{`
          .sidebar-nav {
            width: 260px;
            min-width: 260px;
            max-width: 260px;
            background: #3e3e3e;
            height: 100vh;
            position: sticky;
            top: 0;
            display: flex;
            flex-direction: column;
            color: #ffffff;
            user-select: none;
            border-right: 1px solid #4a4a4a;
            z-index: 40;
            flex-shrink: 0;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.2);
            font-family: inherit;
            box-sizing: border-box;
          }

          /* 1. Header: "Settings" with Left Arrow */
          .drawer-header-bar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 52px;
            min-height: 52px;
            padding: 0 16px;
            background: #383838;
            border-bottom: 1px solid #4a4a4a;
            flex-shrink: 0;
          }
          .drawer-title-text {
            font-size: 1.15rem;
            font-weight: 700;
            color: #ffffff;
            margin: 0;
            letter-spacing: -0.2px;
          }
          .drawer-back-arrow-btn {
            background: transparent;
            border: none;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 4px;
            border-radius: 4px;
            text-decoration: none;
            transition: background 0.12s;
          }
          .drawer-back-arrow-btn:hover {
            background: #4a4a4a;
          }

          .sidebar-outlet-switcher-wrap {
            padding: 8px 14px;
            background: #383838;
            border-bottom: 1px solid #4a4a4a;
            flex-shrink: 0;
          }
          .sidebar-outlet-select {
            width: 100%;
            cursor: pointer;
            background: #2b2b2b;
            border: 1px solid #5a5a5a;
            color: #ffffff;
            font-weight: 600;
            padding: 6px 10px;
            border-radius: 6px;
            font-size: 0.8rem;
          }

          /* 2. Menu Navigation Items List */
          .drawer-menu-items-scroll {
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow-y: auto;
            padding-top: 2px;
          }

          .menu-row-item,
          :global(.menu-row-item),
          :global(a.menu-row-item),
          :global(button.menu-row-item) {
            display: flex !important;
            flex-direction: row !important;
            align-items: center !important;
            width: 100% !important;
            padding: 14px 18px !important;
            cursor: pointer;
            transition: background 0.12s;
            background: transparent;
            border: none;
            border-left: 4px solid transparent !important;
            font: inherit;
            text-align: left;
            color: #ffffff;
            position: relative;
            text-decoration: none;
            box-sizing: border-box;
          }
          .menu-row-item:focus-visible,
          :global(.menu-row-item:focus-visible) {
            outline: 2px solid #ffffff;
            outline-offset: -2px;
          }
          .item-new-badge,
          :global(.item-new-badge) {
            background: #00b074;
            color: #ffffff;
            font-size: 0.62rem;
            font-weight: 700;
            letter-spacing: 0.02em;
            padding: 2px 6px;
            border-radius: 9999px;
            margin-right: 8px;
            margin-left: 8px;
            flex-shrink: 0;
          }
          .menu-row-item:hover,
          :global(.menu-row-item:hover) {
            background: #4a4a4a;
          }
          .menu-row-item.is-selected,
          :global(.menu-row-item.is-selected) {
            background: #575757;
            border-left: 4px solid #ffffff !important;
          }

          .item-icon-col,
          :global(.item-icon-col) {
            width: 28px !important;
            min-width: 28px !important;
            height: 28px !important;
            display: inline-flex !important;
            align-items: center !important;
            justify-content: flex-start !important;
            margin-right: 14px !important;
            flex-shrink: 0 !important;
          }
          .item-label-text,
          :global(.item-label-text) {
            flex: 1 !important;
            font-size: 0.9375rem !important;
            font-weight: 500 !important;
            color: #ffffff !important;
            letter-spacing: -0.1px !important;
            text-align: left !important;
          }
          .chevron-indicator,
          :global(.chevron-indicator) {
            display: inline-flex !important;
            align-items: center !important;
            justify-content: center !important;
            transition: transform 0.2s;
            flex-shrink: 0;
            margin-left: auto;
          }
          .chevron-indicator.open,
          :global(.chevron-indicator.open) {
            transform: rotate(180deg);
          }

          /* Submenus */
          .submenu-container {
            display: flex;
            flex-direction: column;
            background: #333333;
            padding: 4px 0 8px 56px;
            border-left: 4px solid #575757;
          }
          .submenu-link {
            padding: 8px 12px;
            color: #cbd5e1;
            text-decoration: none;
            font-size: 0.8125rem;
            font-weight: 500;
            transition: color 0.12s, padding-left 0.12s;
            box-sizing: border-box;
            display: block;
          }
          .submenu-link:hover {
            color: #ffffff;
            padding-left: 16px;
          }
          .submenu-link.active {
            color: #ffffff;
            font-weight: 700;
            background: rgba(255, 255, 255, 0.08);
            border-radius: 4px 0 0 4px;
          }
          .submenu-link:focus-visible {
            outline: 2px solid #ffffff;
            outline-offset: -2px;
          }

          /* 3. Bottom Metadata Panel */
          .drawer-footer-metadata-block {
            background: #383838;
            border-top: 1px solid #525252;
            display: flex;
            flex-direction: column;
            flex-shrink: 0;
          }
          .meta-row-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 10px 14px;
            font-size: 0.8125rem;
            font-weight: 600;
            color: #ffffff;
            border-bottom: 1px solid #4a4a4a;
          }
          .meta-ref-id,
          .meta-version {
            letter-spacing: -0.2px;
          }
          .meta-row-biller {
            padding: 10px 14px;
            font-size: 0.8125rem;
            font-weight: 600;
            color: #ffffff;
            text-align: center;
          }
        `}</style>
      </aside>
    );
  }

  return (
    <div style={{ display: "flex", alignItems: "center", gap: "12px", flexGrow: 1, justifyContent: "center", minWidth: 0 }}>
      <nav className="nav-pill-group" style={{ flexGrow: 1, maxWidth: "75%" }}>
        {visibleLinks.map((link) => (
          <Link
            key={link.href}
            href={link.href}
            className={`nav-item ${isActive(link.href) ? "active" : ""}`}
          >
            {link.pillLabel}
          </Link>
        ))}
      </nav>
      {outletSwitcher}
      {logoutButton}
    </div>
  );
}
