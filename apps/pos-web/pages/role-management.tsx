import React, { useEffect, useState } from "react";
import Head from "next/head";
import Link from "next/link";
import { authedFetch, useAuthGuard } from "../lib/auth";
import Nav from "../components/Nav";

// Real response shapes from apps/api/src/routes/user-management.ts
interface UserRoleApi {
  roleId: string;
  roleName: string;
  outletId: string | null;
  outletName: string | null;
}

interface UserApi {
  id: string;
  email: string;
  firstName: string;
  lastName: string;
  phone: string | null;
  isActive: boolean;
  userRoles: UserRoleApi[];
}

interface RoleApi {
  id: string;
  name: string;
  description: string | null;
}

interface OutletApi {
  id: string;
  name: string;
}

interface PermissionApi {
  id: string;
  action: string;
  description: string | null;
}

export default function RoleManagementPage() {
  // Allow all authenticated users; control mutations via canManageUsers
  const { me, loading: authLoading } = useAuthGuard();

  const canManageUsers = Boolean(
    me?.roles?.some((r) =>
      ["SUPER_ADMIN", "SUPERADMIN", "OWNER", "ADMIN", "OUTLET_MANAGER", "MANAGER"].includes(r.toUpperCase())
    ) || me?.permissions?.includes("users.manage")
  );

  // Roles, Permissions & User mapping state
  const [users, setUsers] = useState<UserApi[]>([]);
  const [roles, setRoles] = useState<RoleApi[]>([]);
  const [permissions, setPermissions] = useState<PermissionApi[]>([]);
  const [outlets, setOutlets] = useState<OutletApi[]>([]);
  const [loading, setLoading] = useState(true);
  const [loadError, setLoadError] = useState<string | null>(null);
  const [actionError, setActionError] = useState<string | null>(null);
  const [actionNotice, setActionNotice] = useState<string | null>(null);

  // Search filter
  const [searchRole, setSearchRole] = useState("");

  // Role Editor state
  const [showRoleEditor, setShowRoleEditor] = useState(false);
  const [editingRoleId, setEditingRoleId] = useState<string | null>(null);
  const [roleName, setRoleName] = useState("");
  const [roleDescription, setRoleDescription] = useState("");
  const [roleGrantedIds, setRoleGrantedIds] = useState<Set<string>>(new Set());
  const [roleSaving, setRoleSaving] = useState(false);
  const [roleError, setRoleError] = useState<string | null>(null);
  const [deletingRoleId, setDeletingRoleId] = useState<string | null>(null);

  // Detailed View Modal state
  const [viewModalData, setViewModalData] = useState<{
    title: string;
    subtitle?: string;
    details: { label: string; value: React.ReactNode }[];
  } | null>(null);

  // CSV Exporter helper
  const exportToCsv = (filename: string, headers: string[], rows: (string | number)[][]) => {
    const escapeCsv = (val: string | number) => {
      const str = String(val ?? "");
      if (str.includes(",") || str.includes('"') || str.includes("\n")) {
        return `"${str.replace(/"/g, '""')}"`;
      }
      return str;
    };

    const csvContent =
      "\uFEFF" +
      [headers.map(escapeCsv).join(","), ...rows.map((row) => row.map(escapeCsv).join(","))].join("\r\n");

    const blob = new Blob([csvContent], { type: "text/csv;charset=utf-8;" });
    const url = URL.createObjectURL(blob);
    const link = document.createElement("a");
    link.href = url;
    link.setAttribute("download", `${filename}_${new Date().toISOString().slice(0, 10)}.csv`);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    URL.revokeObjectURL(url);
  };

  // JSON Exporter helper
  const exportToJson = (filename: string, data: any) => {
    const jsonStr = JSON.stringify(data, null, 2);
    const blob = new Blob([jsonStr], { type: "application/json" });
    const url = URL.createObjectURL(blob);
    const link = document.createElement("a");
    link.href = url;
    link.setAttribute("download", `${filename}_${new Date().toISOString().slice(0, 10)}.json`);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    URL.revokeObjectURL(url);
  };

  // Print Report
  const triggerPrint = () => {
    if (typeof window !== "undefined") {
      window.print();
    }
  };

  // Load Roles, Permissions, Users, Outlets
  const fetchData = () => {
    setLoading(true);
    setLoadError(null);
    Promise.all([
      authedFetch(`/roles`).then((res) => {
        if (!res.ok) throw new Error("HTTP error " + res.status);
        return res.json() as Promise<RoleApi[]>;
      }),
      authedFetch(`/permissions`).then((res) => {
        if (!res.ok) throw new Error("HTTP error " + res.status);
        return res.json() as Promise<PermissionApi[]>;
      }),
      authedFetch(`/users`).then((res) => {
        if (!res.ok) throw new Error("HTTP error " + res.status);
        return res.json() as Promise<UserApi[]>;
      }),
      authedFetch(`/outlets`).then((res) => {
        if (!res.ok) throw new Error("HTTP error " + res.status);
        return res.json() as Promise<OutletApi[]>;
      }),
    ])
      .then(([rolesRes, permissionsRes, usersRes, outletsRes]) => {
        setRoles(Array.isArray(rolesRes) ? rolesRes : []);
        setPermissions(Array.isArray(permissionsRes) ? permissionsRes : []);
        setUsers(Array.isArray(usersRes) ? usersRes : []);
        setOutlets(Array.isArray(outletsRes) ? outletsRes : []);
        setLoading(false);
      })
      .catch((err) => {
        setLoadError(err instanceof Error ? err.message : "Failed to load roles");
        setLoading(false);
      });
  };

  useEffect(() => {
    if (authLoading) return;
    fetchData();
  }, [authLoading]);

  // Open Create Role modal
  const openCreateRole = () => {
    setEditingRoleId(null);
    setRoleName("");
    setRoleDescription("");
    setRoleGrantedIds(new Set());
    setRoleError(null);
    setShowRoleEditor(true);
  };

  // Open Edit Role modal and load granted permissions
  const openEditRole = async (role: RoleApi) => {
    setEditingRoleId(role.id);
    setRoleName(role.name);
    setRoleDescription(role.description || "");
    setRoleError(null);
    setShowRoleEditor(true);

    try {
      const res = await authedFetch(`/roles/${role.id}/permissions`);
      if (res.ok) {
        const data = (await res.json()) as PermissionApi[];
        const granted = new Set(data.map((p) => p.id));
        setRoleGrantedIds(granted);
      } else {
        setRoleGrantedIds(new Set());
      }
    } catch {
      setRoleGrantedIds(new Set());
    }
  };

  // Toggle permission checkbox
  const togglePermission = (permId: string) => {
    setRoleGrantedIds((prev) => {
      const next = new Set(prev);
      if (next.has(permId)) next.delete(permId);
      else next.add(permId);
      return next;
    });
  };

  // Save role (Create or Update + update permissions)
  const saveRole = async () => {
    if (!roleName.trim()) {
      setRoleError("Role name is required");
      return;
    }
    setRoleError(null);
    setRoleSaving(true);
    try {
      let roleId = editingRoleId;
      if (roleId) {
        const res = await authedFetch(`/roles/${roleId}`, {
          method: "PUT",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ name: roleName.trim(), description: roleDescription.trim() || null }),
        });
        if (!res.ok) {
          const body = await res.json().catch(() => ({}));
          throw new Error(body.error || "HTTP error " + res.status);
        }
      } else {
        const res = await authedFetch(`/roles`, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ name: roleName.trim(), description: roleDescription.trim() || null }),
        });
        if (!res.ok) {
          const body = await res.json().catch(() => ({}));
          throw new Error(body.error || "HTTP error " + res.status);
        }
        const created = (await res.json()) as RoleApi;
        roleId = created.id;
      }

      const permRes = await authedFetch(`/roles/${roleId}/permissions`, {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ permissionIds: Array.from(roleGrantedIds) }),
      });
      if (!permRes.ok) {
        const body = await permRes.json().catch(() => ({}));
        throw new Error(body.error || "Role saved but failed to update permissions");
      }

      setShowRoleEditor(false);
      setActionNotice(`Role "${roleName}" saved successfully.`);
      fetchData();
    } catch (err) {
      setRoleError(err instanceof Error ? err.message : "Failed to save role");
    } finally {
      setRoleSaving(false);
    }
  };

  // Delete Role
  const deleteRole = async (roleId: string) => {
    if (!window.confirm("Are you sure you want to delete this role?")) return;
    setActionError(null);
    setDeletingRoleId(roleId);
    try {
      const res = await authedFetch(`/roles/${roleId}`, { method: "DELETE" });
      if (!res.ok && res.status !== 204) {
        const body = await res.json().catch(() => ({}));
        throw new Error(body.error || "HTTP error " + res.status);
      }
      setActionNotice("Role deleted successfully.");
      fetchData();
    } catch (err) {
      setActionError(err instanceof Error ? err.message : "Failed to delete role");
    } finally {
      setDeletingRoleId(null);
    }
  };

  const initials = me?.name
    ? me.name
        .split(" ")
        .map((p) => p.charAt(0))
        .slice(0, 2)
        .join("")
        .toUpperCase()
    : "KM";

  // Filtered roles
  const filteredRoles = roles.filter(
    (r) =>
      r.name.toLowerCase().includes(searchRole.toLowerCase()) ||
      (r.description || "").toLowerCase().includes(searchRole.toLowerCase())
  );

  const totalAssignedStaffCount = users.filter((u) => u.userRoles.length > 0).length;

  return (
    <div className="admin-app">
      <Head>
        <title>Role Management - KapMeta POS</title>
        <meta
          name="description"
          content="RBAC Roles and permissions management with granular permission schemes and assigned staff audit."
        />
      </Head>

      <div style={{ display: "flex", flex: 1, minHeight: 0 }}>
        <Nav variant="sidebar" />
        <div style={{ flex: 1, display: "flex", flexDirection: "column", minWidth: 0, overflowY: "auto" }}>
          <header className="topbar">
            <div className="topbar-left">
              <div className="brand-badge">
                <span className="brand-icon">⚡</span>
                <span className="brand-name">KapMeta Enterprise Gateway</span>
              </div>
            </div>

            <div className="topbar-right">
              {!canManageUsers && (
                <div className="view-mode-tag">
                  👁️ Staff View Mode
                </div>
              )}
              <div className="user-profile-badge">
                <div className="avatar-circle">{initials}</div>
                <div className="user-info-text">
                  <span className="user-name">{me?.name ?? "Staff Member"}</span>
                  <span className="user-role">{me?.roles?.[0] ?? "Team"}</span>
                </div>
              </div>
            </div>
          </header>

          <main className="dashboard-body">
            {authLoading && (
              <div className="empty-state-card">
                <span className="empty-icon">⏳</span>
                <h3>Loading access profile...</h3>
              </div>
            )}

            {!authLoading && (
              <>
                {/* Header Greeting & Action Row */}
                <section className="dashboard-greeting-row">
                  <div>
                    <span className="breadcrumb-line">Management &gt; Role Management</span>
                    <h1 className="greeting-title">RBAC Roles &amp; Permissions Management</h1>
                    <p className="greeting-subtitle">
                      Configure system roles, fine-tune granular permission grants across all modules, and audit role assignments.
                    </p>
                  </div>

                  {/* Actions & Export */}
                  <div className="action-buttons-group">
                    <button
                      className="export-action-btn primary"
                      onClick={() =>
                        exportToCsv(
                          "RBAC_Roles_Matrix",
                          ["Role ID", "Role Name", "Description", "Assigned Users Count"],
                          roles.map((r) => {
                            const assignedCount = users.filter((u) => u.userRoles.some((ur) => ur.roleId === r.id)).length;
                            return [r.id, r.name, r.description || "", assignedCount];
                          })
                        )
                      }
                    >
                      📥 Download Roles (CSV)
                    </button>
                    <button
                      className="export-action-btn"
                      onClick={() =>
                        exportToJson("RBAC_Roles_Full_Data", {
                          exportedAt: new Date().toISOString(),
                          roles,
                          permissions,
                          usersWithRoles: users.map((u) => ({
                            id: u.id,
                            name: `${u.firstName} ${u.lastName}`,
                            email: u.email,
                            roles: u.userRoles.map((r) => r.roleName),
                          })),
                        })
                      }
                    >
                      📦 Export JSON
                    </button>
                    <button className="export-action-btn" onClick={triggerPrint}>
                      🖨️ Print / PDF
                    </button>
                    {canManageUsers && (
                      <button className="add-user-btn" onClick={openCreateRole}>
                        + New Role
                      </button>
                    )}
                  </div>
                </section>

                {/* Primary Section Switcher */}
                <div className="tabs-header-container">
                  <Link href="/user-management" className="tab-item-btn" style={{ textDecoration: "none" }}>
                    🧑‍💼 Staff &amp; User Accounts
                    <span className="tab-pill">{users.length}</span>
                  </Link>
                  <button className="tab-item-btn active">
                    🛡️ RBAC Roles &amp; Permission Schemes
                    <span className="tab-pill">{roles.length}</span>
                  </button>
                  <Link href="/user-management?tab=reports" className="tab-item-btn" style={{ textDecoration: "none" }}>
                    📊 Operations Reports &amp; Analytics
                    <span className="tab-pill">Live</span>
                  </Link>
                </div>

                {/* Notifications & Banners */}
                {actionError && (
                  <div className="empty-state-card error-card">
                    <span className="empty-icon">⚠️</span>
                    <p>{actionError}</p>
                  </div>
                )}
                {actionNotice && (
                  <div className="empty-state-card notice-card">
                    <span className="empty-icon">ℹ️</span>
                    <p>{actionNotice}</p>
                  </div>
                )}

                {/* KPI Metrics Bar */}
                <div className="kpi-grid">
                  <div className="kpi-card">
                    <span className="kpi-icon">🛡️</span>
                    <div className="kpi-content">
                      <span className="kpi-label">Defined Roles</span>
                      <span className="kpi-value">{roles.length}</span>
                      <span className="kpi-sub">Configured security roles</span>
                    </div>
                  </div>

                  <div className="kpi-card">
                    <span className="kpi-icon">🔑</span>
                    <div className="kpi-content">
                      <span className="kpi-label">System Permissions</span>
                      <span className="kpi-value">{permissions.length}</span>
                      <span className="kpi-sub">Granular action gates</span>
                    </div>
                  </div>

                  <div className="kpi-card">
                    <span className="kpi-icon">👥</span>
                    <div className="kpi-content">
                      <span className="kpi-label">Staff Assigned</span>
                      <span className="kpi-value">{totalAssignedStaffCount}</span>
                      <span className="kpi-sub">Across {outlets.length || 1} outlet(s)</span>
                    </div>
                  </div>

                  <div className="kpi-card highlight">
                    <span className="kpi-icon">⚡</span>
                    <div className="kpi-content">
                      <span className="kpi-label">User Management</span>
                      <span className="kpi-value">
                        <Link href="/user-management" style={{ color: "inherit", textDecoration: "none" }}>
                          View Staff →
                        </Link>
                      </span>
                      <span className="kpi-sub">{users.length} active user accounts</span>
                    </div>
                  </div>
                </div>

                {/* Roles Table Section */}
                <div className="users-section-wrapper">
                  {loading && (
                    <div className="empty-state-card">
                      <span className="empty-icon">⏳</span>
                      <h3>Loading roles and permissions matrix...</h3>
                    </div>
                  )}

                  {!loading && loadError && (
                    <div className="empty-state-card error-card">
                      <span className="empty-icon">⚠️</span>
                      <h3>Could not load roles</h3>
                      <p>{loadError}</p>
                    </div>
                  )}

                  {!loading && !loadError && (
                    <section className="panel-card invoices-table-card">
                      <div className="panel-header">
                        <div>
                          <h3>RBAC Roles &amp; Permission Schemes</h3>
                          <p className="panel-sub">
                            Role definitions mapped directly to granular RolePermission database matrix
                          </p>
                          {!canManageUsers && (
                            <div
                              style={{
                                background: "rgba(59, 130, 246, 0.12)",
                                border: "1px solid rgba(59, 130, 246, 0.3)",
                                borderRadius: "6px",
                                padding: "6px 12px",
                                marginTop: "6px",
                                fontSize: "0.82rem",
                                color: "#93c5fd",
                                display: "inline-flex",
                                alignItems: "center",
                                gap: "6px",
                              }}
                            >
                              <span>🔒</span>
                              <span>
                                <strong>Read-Only Mode:</strong> Role configuration requires Administrator privileges. Sign in as <strong>admin@hotelkapila.com</strong> to edit permissions.
                              </span>
                            </div>
                          )}
                        </div>
                        <div className="panel-actions">
                          <input
                            type="text"
                            placeholder="Search roles..."
                            value={searchRole}
                            onChange={(e) => setSearchRole(e.target.value)}
                            style={{
                              padding: "6px 12px",
                              background: "#0f172a",
                              border: "1px solid #334155",
                              borderRadius: "6px",
                              color: "#f8fafc",
                              fontSize: "0.82rem",
                            }}
                          />
                          {canManageUsers && (
                            <button className="add-user-btn" onClick={openCreateRole}>
                              + New Role
                            </button>
                          )}
                        </div>
                      </div>

                      <div className="table-responsive">
                        <table className="clean-table">
                          <thead>
                            <tr>
                              <th>Role Name</th>
                              <th>Description</th>
                              <th>Assigned Staff</th>
                              <th style={{ textAlign: "right" }}>Actions</th>
                            </tr>
                          </thead>
                          <tbody>
                            {filteredRoles.length === 0 ? (
                              <tr>
                                <td colSpan={4} style={{ textAlign: "center", color: "var(--text-muted)", padding: "24px" }}>
                                  No matching roles found.
                                </td>
                              </tr>
                            ) : (
                              filteredRoles.map((role) => {
                                const assignedCount = users.filter((u) => u.userRoles.some((ur) => ur.roleId === role.id)).length;
                                return (
                                  <tr key={role.id}>
                                    <td>
                                      <strong>{role.name}</strong>
                                    </td>
                                    <td>{role.description || <span className="no-roles">—</span>}</td>
                                    <td>
                                      <span className="counter-pill">{assignedCount} users</span>
                                    </td>
                                    <td style={{ textAlign: "right" }}>
                                      <div style={{ display: "inline-flex", gap: "6px" }}>
                                        <button
                                          className="btn-table-action view"
                                          onClick={() => {
                                            const assignedUsers = users
                                              .filter((u) => u.userRoles.some((ur) => ur.roleId === role.id))
                                              .map((u) => `${u.firstName} ${u.lastName} (${u.email})`);
                                            setViewModalData({
                                              title: `Role Matrix: ${role.name}`,
                                              subtitle: `Role ID: ${role.id}`,
                                              details: [
                                                { label: "Role Title", value: role.name },
                                                {
                                                  label: "Role Description",
                                                  value: role.description || "General RBAC Security Role",
                                                },
                                                { label: "Total Users Bound", value: `${assignedCount} users` },
                                                {
                                                  label: "Assigned Staff List",
                                                  value:
                                                    assignedUsers.length > 0 ? (
                                                      <ul style={{ paddingLeft: "18px", margin: "4px 0" }}>
                                                        {assignedUsers.map((name, i) => (
                                                          <li key={i}>{name}</li>
                                                        ))}
                                                      </ul>
                                                    ) : (
                                                      "No staff members currently assigned"
                                                    ),
                                                },
                                              ],
                                            });
                                          }}
                                        >
                                          👁️ View
                                        </button>
                                        {canManageUsers && (
                                          <>
                                            <button className="edit-btn" onClick={() => openEditRole(role)}>
                                              ✏️ Edit
                                            </button>
                                            <button
                                              className="delete-btn"
                                              disabled={deletingRoleId === role.id || assignedCount > 0}
                                              onClick={() => deleteRole(role.id)}
                                              title={assignedCount > 0 ? "Revoke from all users first" : undefined}
                                            >
                                              🗑️
                                            </button>
                                          </>
                                        )}
                                      </div>
                                    </td>
                                  </tr>
                                );
                              })
                            )}
                          </tbody>
                        </table>
                      </div>
                    </section>
                  )}
                </div>

                {/* Section Link Banner */}
                <div
                  style={{
                    padding: "16px 20px",
                    background: "#1e293b",
                    borderRadius: "10px",
                    border: "1px solid #334155",
                    display: "flex",
                    justifyContent: "space-between",
                    alignItems: "center",
                    flexWrap: "wrap",
                    gap: "12px",
                  }}
                >
                  <div>
                    <h4 style={{ margin: "0 0 4px 0", color: "#f8fafc", fontSize: "0.95rem" }}>
                      Need to manage individual staff accounts and login credentials?
                    </h4>
                    <p style={{ margin: 0, color: "#94a3b8", fontSize: "0.82rem" }}>
                      Add new staff members, set passwords, configure 4-digit POS PINs, and assign outlet scopes in User Management.
                    </p>
                  </div>
                  <Link
                    href="/user-management"
                    style={{
                      background: "#2563eb",
                      color: "#ffffff",
                      padding: "8px 16px",
                      borderRadius: "8px",
                      textDecoration: "none",
                      fontWeight: 700,
                      fontSize: "0.82rem",
                    }}
                  >
                    Go to User Management →
                  </Link>
                </div>

                {/* Detail View Modal */}
                {viewModalData && (
                  <div className="modal-overlay" onClick={() => setViewModalData(null)}>
                    <div className="modal-content view-modal" onClick={(e) => e.stopPropagation()}>
                      <div className="modal-header">
                        <div>
                          <h4>{viewModalData.title}</h4>
                          {viewModalData.subtitle && <span className="modal-subtitle">{viewModalData.subtitle}</span>}
                        </div>
                        <button className="close-modal-btn" onClick={() => setViewModalData(null)}>
                          ✕
                        </button>
                      </div>

                      <div className="view-modal-body">
                        <div className="details-grid">
                          {viewModalData.details.map((item, idx) => (
                            <div key={idx} className="detail-item">
                              <span className="detail-label">{item.label}</span>
                              <div className="detail-value">{item.value}</div>
                            </div>
                          ))}
                        </div>
                      </div>

                      <div className="modal-actions">
                        <button
                          className="btn-download json"
                          onClick={() => {
                            exportToJson(
                              `Record_${viewModalData.title.replace(/[^a-zA-Z0-9]/g, "_")}`,
                              viewModalData
                            );
                          }}
                        >
                          📥 Export Details (JSON)
                        </button>
                        <button className="cancel-modal-btn" onClick={() => setViewModalData(null)}>
                          Close
                        </button>
                      </div>
                    </div>
                  </div>
                )}

                {/* Role Editor Modal */}
                {showRoleEditor && (
                  <div className="modal-overlay">
                    <div className="modal-content modal-lg">
                      <div className="modal-header">
                        <h4>{editingRoleId ? "Edit Role & Permissions" : "Create New Role"}</h4>
                        <button className="close-modal-btn" onClick={() => setShowRoleEditor(false)}>
                          ✕
                        </button>
                      </div>
                      <div className="modal-form">
                        <div className="form-group">
                          <label>Role Name *</label>
                          <input
                            type="text"
                            value={roleName}
                            onChange={(e) => setRoleName(e.target.value)}
                            placeholder="e.g. HEAD_WAITER"
                          />
                        </div>
                        <div className="form-group">
                          <label>Description</label>
                          <input
                            type="text"
                            value={roleDescription}
                            onChange={(e) => setRoleDescription(e.target.value)}
                            placeholder="e.g. Floor Captain with discount rights"
                          />
                        </div>
                        <div className="form-group">
                          <label>Granular Permissions ({roleGrantedIds.size} granted)</label>
                          <div className="permission-matrix">
                            {permissions.map((p) => {
                              const checked = roleGrantedIds.has(p.id);
                              return (
                                <label key={p.id} className="permission-row">
                                  <input type="checkbox" checked={checked} onChange={() => togglePermission(p.id)} />
                                  <div>
                                    <span className="permission-action">{p.action}</span>
                                    {p.description && <span className="permission-desc"> — {p.description}</span>}
                                  </div>
                                </label>
                              );
                            })}
                          </div>
                        </div>
                        {roleError && <div className="error-banner">{roleError}</div>}
                        <div className="modal-actions">
                          <button type="button" className="cancel-modal-btn" onClick={() => setShowRoleEditor(false)}>
                            Cancel
                          </button>
                          <button type="button" className="submit-modal-btn" disabled={roleSaving} onClick={saveRole}>
                            {roleSaving ? "Saving..." : "Save Role"}
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>
                )}
              </>
            )}
          </main>
        </div>
      </div>

      <style jsx>{`
        .admin-app {
          display: flex;
          flex-direction: column;
          height: 100vh;
          background: #0f172a;
          color: #f8fafc;
          font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
          overflow: hidden;
        }

        .topbar {
          display: flex;
          align-items: center;
          justify-content: space-between;
          padding: 12px 24px;
          background: #1e293b;
          border-bottom: 1px solid #334155;
          flex-shrink: 0;
        }

        .brand-badge {
          display: flex;
          align-items: center;
          gap: 10px;
        }

        .brand-icon {
          font-size: 1.25rem;
          color: #38bdf8;
        }

        .brand-name {
          font-size: 1.125rem;
          font-weight: 800;
          letter-spacing: -0.025em;
          color: #f1f5f9;
        }

        .topbar-right {
          display: flex;
          align-items: center;
          gap: 16px;
        }

        .view-mode-tag {
          font-size: 0.75rem;
          font-weight: 700;
          background: rgba(56, 189, 248, 0.12);
          border: 1px solid rgba(56, 189, 248, 0.3);
          color: #38bdf8;
          padding: 4px 10px;
          border-radius: 9999px;
        }

        .user-profile-badge {
          display: flex;
          align-items: center;
          gap: 10px;
        }

        .avatar-circle {
          width: 36px;
          height: 36px;
          border-radius: 50%;
          background: #3b82f6;
          color: #fff;
          display: flex;
          align-items: center;
          justify-content: center;
          font-weight: 700;
          font-size: 0.875rem;
        }

        .user-info-text {
          display: flex;
          flex-direction: column;
        }

        .user-name {
          font-size: 0.875rem;
          font-weight: 700;
          color: #f8fafc;
        }

        .user-role {
          font-size: 0.75rem;
          color: #94a3b8;
          text-transform: uppercase;
        }

        .dashboard-body {
          padding: 24px;
          flex: 1;
          display: flex;
          flex-direction: column;
          gap: 20px;
        }

        .dashboard-greeting-row {
          display: flex;
          align-items: flex-start;
          justify-content: space-between;
          flex-wrap: wrap;
          gap: 16px;
        }

        .breadcrumb-line {
          font-size: 0.75rem;
          font-weight: 700;
          text-transform: uppercase;
          letter-spacing: 0.05em;
          color: #38bdf8;
        }

        .greeting-title {
          font-size: 1.75rem;
          font-weight: 800;
          margin: 4px 0 6px 0;
          color: #f8fafc;
        }

        .greeting-subtitle {
          font-size: 0.9375rem;
          color: #94a3b8;
          max-width: 820px;
          margin: 0;
          line-height: 1.5;
        }

        .action-buttons-group {
          display: flex;
          gap: 10px;
          align-items: center;
        }

        .export-action-btn {
          padding: 8px 16px;
          font-size: 0.8125rem;
          font-weight: 700;
          border-radius: 8px;
          cursor: pointer;
          background: #334155;
          color: #f8fafc;
          border: 1px solid #475569;
          transition: all 0.15s ease;
        }

        .export-action-btn:hover {
          background: #475569;
        }

        .export-action-btn.primary {
          background: #2563eb;
          border-color: #3b82f6;
          color: #ffffff;
        }

        .export-action-btn.primary:hover {
          background: #1d4ed8;
        }

        .tabs-header-container {
          display: flex;
          gap: 12px;
          border-bottom: 1px solid #334155;
          padding-bottom: 12px;
          flex-wrap: wrap;
        }

        .tab-item-btn {
          background: #1e293b;
          border: 1px solid #334155;
          color: #94a3b8;
          padding: 10px 18px;
          border-radius: 8px;
          font-size: 0.875rem;
          font-weight: 700;
          cursor: pointer;
          display: inline-flex;
          align-items: center;
          gap: 8px;
          transition: all 0.15s ease;
        }

        .tab-item-btn:hover {
          background: #334155;
          color: #f8fafc;
        }

        .tab-item-btn.active {
          background: #2563eb;
          border-color: #3b82f6;
          color: #ffffff;
        }

        .tab-pill {
          background: rgba(0, 0, 0, 0.25);
          font-size: 0.75rem;
          padding: 2px 6px;
          border-radius: 9999px;
        }

        .kpi-grid {
          display: grid;
          grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
          gap: 16px;
        }

        .kpi-card {
          background: #1e293b;
          border: 1px solid #334155;
          border-radius: 12px;
          padding: 18px;
          display: flex;
          align-items: center;
          gap: 16px;
        }

        .kpi-card.highlight {
          border-color: #6366f1;
          background: linear-gradient(135deg, #1e293b 0%, rgba(99, 102, 241, 0.12) 100%);
        }

        .kpi-icon {
          font-size: 2rem;
        }

        .kpi-content {
          display: flex;
          flex-direction: column;
        }

        .kpi-label {
          font-size: 0.75rem;
          color: #94a3b8;
          font-weight: 600;
          text-transform: uppercase;
          letter-spacing: 0.05em;
        }

        .kpi-value {
          font-size: 1.5rem;
          font-weight: 800;
          color: #f8fafc;
          margin: 2px 0;
        }

        .kpi-sub {
          font-size: 0.75rem;
          color: #64748b;
        }

        .users-section-wrapper {
          display: flex;
          flex-direction: column;
          gap: 20px;
        }

        .panel-card {
          background: #1e293b;
          border: 1px solid #334155;
          border-radius: 12px;
          padding: 20px;
        }

        .panel-header {
          display: flex;
          justify-content: space-between;
          align-items: flex-start;
          margin-bottom: 16px;
          flex-wrap: wrap;
          gap: 12px;
        }

        .panel-header h3 {
          margin: 0;
          font-size: 1.125rem;
          font-weight: 700;
          color: #f8fafc;
        }

        .panel-sub {
          margin: 4px 0 0 0;
          font-size: 0.8125rem;
          color: #94a3b8;
        }

        .panel-actions {
          display: flex;
          gap: 8px;
          align-items: center;
        }

        .add-user-btn {
          background: #10b981;
          color: #ffffff;
          border: none;
          padding: 8px 14px;
          border-radius: 6px;
          font-size: 0.8125rem;
          font-weight: 700;
          cursor: pointer;
          transition: background 0.15s ease;
        }

        .add-user-btn:hover {
          background: #059669;
        }

        .table-responsive {
          overflow-x: auto;
        }

        .clean-table {
          width: 100%;
          border-collapse: collapse;
          font-size: 0.875rem;
        }

        .clean-table th {
          text-align: left;
          padding: 10px 14px;
          background: #0f172a;
          color: #94a3b8;
          font-weight: 700;
          font-size: 0.75rem;
          text-transform: uppercase;
          letter-spacing: 0.05em;
          border-bottom: 1px solid #334155;
        }

        .clean-table td {
          padding: 12px 14px;
          border-bottom: 1px solid #334155;
          color: #f1f5f9;
        }

        .counter-pill {
          background: rgba(56, 189, 248, 0.15);
          color: #38bdf8;
          padding: 3px 8px;
          border-radius: 9999px;
          font-size: 0.75rem;
          font-weight: 700;
        }

        .no-roles {
          color: #64748b;
          font-style: italic;
          font-size: 0.8125rem;
        }

        .btn-table-action {
          padding: 4px 10px;
          border-radius: 6px;
          font-size: 0.75rem;
          font-weight: 700;
          border: 1px solid #475569;
          background: #334155;
          color: #f8fafc;
          cursor: pointer;
        }

        .btn-table-action:hover {
          background: #475569;
        }

        .edit-btn {
          padding: 4px 10px;
          border-radius: 6px;
          font-size: 0.75rem;
          font-weight: 700;
          border: 1px solid #3b82f6;
          background: rgba(59, 130, 246, 0.15);
          color: #60a5fa;
          cursor: pointer;
        }

        .edit-btn:hover {
          background: rgba(59, 130, 246, 0.25);
        }

        .delete-btn {
          padding: 4px 8px;
          border-radius: 6px;
          font-size: 0.75rem;
          font-weight: 700;
          border: 1px solid #ef4444;
          background: rgba(239, 68, 68, 0.15);
          color: #f87171;
          cursor: pointer;
        }

        .delete-btn:hover:not(:disabled) {
          background: rgba(239, 68, 68, 0.25);
        }

        .delete-btn:disabled {
          opacity: 0.4;
          cursor: not-allowed;
        }

        .empty-state-card {
          background: #1e293b;
          border: 1px solid #334155;
          border-radius: 12px;
          padding: 32px;
          text-align: center;
          color: #94a3b8;
        }

        .empty-state-card.error-card {
          border-color: #ef4444;
          background: rgba(239, 68, 68, 0.08);
          color: #fca5a5;
        }

        .empty-state-card.notice-card {
          border-color: #3b82f6;
          background: rgba(59, 130, 246, 0.08);
          color: #93c5fd;
        }

        .empty-icon {
          font-size: 2rem;
          display: block;
          margin-bottom: 8px;
        }

        /* Modal Styles */
        .modal-overlay {
          position: fixed;
          top: 0;
          left: 0;
          right: 0;
          bottom: 0;
          background: rgba(0, 0, 0, 0.7);
          backdrop-filter: blur(4px);
          display: flex;
          align-items: center;
          justify-content: center;
          z-index: 1000;
          padding: 16px;
        }

        .modal-content {
          background: #1e293b;
          border: 1px solid #475569;
          border-radius: 12px;
          width: 100%;
          max-width: 520px;
          max-height: 90vh;
          overflow-y: auto;
          box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.5);
        }

        .modal-content.modal-lg {
          max-width: 680px;
        }

        .modal-content.view-modal {
          max-width: 600px;
        }

        .modal-header {
          display: flex;
          justify-content: space-between;
          align-items: flex-start;
          padding: 16px 20px;
          border-bottom: 1px solid #334155;
        }

        .modal-header h4 {
          margin: 0;
          font-size: 1.125rem;
          font-weight: 700;
          color: #f8fafc;
        }

        .modal-subtitle {
          font-size: 0.75rem;
          color: #94a3b8;
          font-family: monospace;
        }

        .close-modal-btn {
          background: transparent;
          border: none;
          color: #94a3b8;
          font-size: 1.25rem;
          cursor: pointer;
          padding: 0;
          line-height: 1;
        }

        .close-modal-btn:hover {
          color: #f8fafc;
        }

        .modal-form {
          padding: 20px;
          display: flex;
          flex-direction: column;
          gap: 16px;
        }

        .form-group {
          display: flex;
          flex-direction: column;
          gap: 6px;
        }

        .form-group label {
          font-size: 0.8125rem;
          font-weight: 600;
          color: #cbd5e1;
        }

        .form-group input,
        .form-group select {
          background: #0f172a;
          border: 1px solid #334155;
          border-radius: 6px;
          padding: 8px 12px;
          color: #f8fafc;
          font-size: 0.875rem;
        }

        .form-group input:focus,
        .form-group select:focus {
          outline: none;
          border-color: #3b82f6;
        }

        .permission-matrix {
          max-height: 280px;
          overflow-y: auto;
          background: #0f172a;
          border: 1px solid #334155;
          border-radius: 6px;
          padding: 8px 12px;
          display: flex;
          flex-direction: column;
          gap: 8px;
        }

        .permission-row {
          display: flex;
          align-items: flex-start;
          gap: 10px;
          font-size: 0.8125rem;
          cursor: pointer;
          padding: 4px;
          border-radius: 4px;
        }

        .permission-row:hover {
          background: #1e293b;
        }

        .permission-action {
          font-weight: 700;
          color: #38bdf8;
          font-family: monospace;
        }

        .permission-desc {
          color: #94a3b8;
        }

        .modal-actions {
          display: flex;
          justify-content: flex-end;
          gap: 10px;
          padding: 16px 20px;
          border-top: 1px solid #334155;
          background: #1e293b;
          border-bottom-left-radius: 12px;
          border-bottom-right-radius: 12px;
        }

        .cancel-modal-btn {
          background: #334155;
          color: #f8fafc;
          border: 1px solid #475569;
          padding: 8px 16px;
          border-radius: 6px;
          font-size: 0.8125rem;
          font-weight: 700;
          cursor: pointer;
        }

        .cancel-modal-btn:hover {
          background: #475569;
        }

        .submit-modal-btn {
          background: #2563eb;
          color: #ffffff;
          border: none;
          padding: 8px 18px;
          border-radius: 6px;
          font-size: 0.8125rem;
          font-weight: 700;
          cursor: pointer;
        }

        .submit-modal-btn:hover:not(:disabled) {
          background: #1d4ed8;
        }

        .submit-modal-btn:disabled {
          opacity: 0.5;
          cursor: not-allowed;
        }

        .error-banner {
          background: rgba(239, 68, 68, 0.15);
          border: 1px solid #ef4444;
          color: #fca5a5;
          padding: 8px 12px;
          border-radius: 6px;
          font-size: 0.8125rem;
        }

        .view-modal-body {
          padding: 20px;
        }

        .details-grid {
          display: flex;
          flex-direction: column;
          gap: 12px;
        }

        .detail-item {
          display: flex;
          flex-direction: column;
          gap: 2px;
          border-bottom: 1px solid #334155;
          padding-bottom: 8px;
        }

        .detail-label {
          font-size: 0.75rem;
          font-weight: 700;
          text-transform: uppercase;
          color: #94a3b8;
          letter-spacing: 0.05em;
        }

        .detail-value {
          font-size: 0.9375rem;
          color: #f8fafc;
        }

        .btn-download {
          padding: 6px 12px;
          border-radius: 6px;
          font-size: 0.75rem;
          font-weight: 700;
          cursor: pointer;
          border: 1px solid #475569;
          background: #334155;
          color: #f8fafc;
        }

        .btn-download:hover {
          background: #475569;
        }
      `}</style>
    </div>
  );
}
