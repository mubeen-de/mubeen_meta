import React, { useEffect, useMemo, useState } from "react";
import Head from "next/head";
import Nav from "../components/Nav";
import { authedFetch, useAuthGuard } from "../lib/auth";

type ReportCategoryId =
  | "favourite"
  | "all"
  | "order"
  | "item"
  | "category"
  | "customer"
  | "discount"
  | "others";

interface ReportDefinition {
  key: string;
  title: string;
  description: string;
  categories: Exclude<ReportCategoryId, "favourite">[];
  defaultFavourite?: boolean;
}

interface ReportSummaryCard {
  label: string;
  value: string;
  tone?: "default" | "success" | "danger" | "info";
}

interface ReportColumn {
  key: string;
  label: string;
  align?: "left" | "right" | "center";
  isCurrency?: boolean;
}

interface SuiteReportData {
  reportKey: string;
  title: string;
  description: string;
  generatedAt: string;
  fromDate: string | null;
  toDate: string | null;
  scope: "all" | "outlet";
  summary: ReportSummaryCard[];
  columns: ReportColumn[];
  rows: Array<Record<string, string | number>>;
}

const SIDEBAR_CATEGORIES: Array<{
  id: ReportCategoryId;
  label: string;
  icon: JSX.Element;
}> = [
  {
    id: "favourite",
    label: "Favourite",
    icon: (
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8">
        <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
      </svg>
    ),
  },
  {
    id: "all",
    label: "All Restaurant Report",
    icon: (
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8">
        <path d="M3 2v7c0 1.1.9 2 2 2h4a2 2 0 0 0 2-2V2" />
        <path d="M7 2v20" />
        <path d="M21 15V2v0a5 5 0 0 0-5 5v6c0 1.1.9 2 2 2h3Zm0 0v7" />
      </svg>
    ),
  },
  {
    id: "order",
    label: "Order Related Reports",
    icon: (
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8">
        <rect x="3" y="4" width="18" height="18" rx="2" />
        <line x1="8" y1="2" x2="8" y2="6" />
        <line x1="16" y1="2" x2="16" y2="6" />
        <line x1="3" y1="10" x2="21" y2="10" />
      </svg>
    ),
  },
  {
    id: "item",
    label: "Item Related Reports",
    icon: (
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8">
        <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z" />
        <polyline points="3.27 6.96 12 12.01 20.73 6.96" />
        <line x1="12" y1="22.08" x2="12" y2="12" />
      </svg>
    ),
  },
  {
    id: "category",
    label: "Category Related Reports",
    icon: (
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8">
        <rect x="9" y="3" width="6" height="5" rx="1" />
        <rect x="3" y="16" width="6" height="5" rx="1" />
        <rect x="15" y="16" width="6" height="5" rx="1" />
        <path d="M12 8v4m0 0H6v4m6-4h6v4" />
      </svg>
    ),
  },
  {
    id: "customer",
    label: "Customer Related Reports",
    icon: (
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8">
        <circle cx="12" cy="12" r="9" />
        <circle cx="12" cy="9.5" r="2.5" />
        <path d="M7.5 18a4.5 4.5 0 0 1 9 0" />
      </svg>
    ),
  },
  {
    id: "discount",
    label: "Discount Related Reports",
    icon: (
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8">
        <circle cx="12" cy="12" r="9" />
        <line x1="9" y1="15" x2="15" y2="9" />
        <circle cx="9.5" cy="9.5" r="0.8" fill="currentColor" />
        <circle cx="14.5" cy="14.5" r="0.8" fill="currentColor" />
      </svg>
    ),
  },
  {
    id: "others",
    label: "Others Reports",
    icon: (
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8">
        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
        <polyline points="14 2 14 8 20 8" />
        <line x1="8" y1="13" x2="16" y2="13" />
        <line x1="8" y1="17" x2="13" y2="17" />
      </svg>
    ),
  },
];

const REPORT_CATALOG: ReportDefinition[] = [
  {
    key: "category-wise",
    title: "Category Wise Report: All Restaurants",
    description: "Total sales from each category in your restaurant",
    categories: ["all", "category"],
    defaultFavourite: true,
  },
  {
    key: "orders-master",
    title: "Orders Master Report: All Restaurants",
    description: "All restaurants orders with customer information & charges incurred on each bill",
    categories: ["all", "order"],
  },
  {
    key: "order-item-wise",
    title: "Order Report: Item Wise All Restaurants",
    description: "All restaurants item wise orders with customer information & charges",
    categories: ["all", "order", "item"],
  },
  {
    key: "cancel-order-item-wise",
    title: "Cancel Order Report: Item Wise All Restaurants",
    description:
      "A summary of all your item wise orders with customer information and charges incurred on each cancelled bill",
    categories: ["all", "order", "item"],
  },
  {
    key: "locality-wise",
    title: "Locality Wise Report: All Restaurants",
    description: "Total orders of all restaurants grouped by locality",
    categories: ["all", "order"],
  },
  {
    key: "item-invoice-details",
    title: "Item Report: Invoice Details",
    description: "Total items sold under each group in your restaurant",
    categories: ["all", "item", "category"],
  },
  {
    key: "item-wise",
    title: "Item Wise Report: All Restaurants",
    description: "Total sales from each item in your restaurant",
    categories: ["all", "item"],
  },
  {
    key: "item-wise-brand",
    title: "Item Wise Report (Brand Wise): All Restaurants",
    description: "Total sales from each item in your restaurant grouped by brand",
    categories: ["all", "item"],
  },
  {
    key: "customer-wise",
    title: "Customer Wise Sales Report",
    description: "Complete customer purchase frequency, spend summary & loyalty points",
    categories: ["customer"],
  },
  {
    key: "discount-summary",
    title: "Discount Wise Report: All Restaurants",
    description: "Summary of all discounted bills, discount totals, and impact on net sales",
    categories: ["discount", "order"],
  },
  {
    key: "tax-gst-summary",
    title: "Tax & GST Summary Report (CGST / SGST)",
    description: "Daily breakdown of taxable sales, CGST (2.5%) & SGST (2.5%) tax collected",
    categories: ["others"],
  },
  {
    key: "payment-mode-summary",
    title: "Payment Mode & Settlement Report",
    description: "Collections breakdown across Cash, Card, UPI / QR, Due, and Other payment modes",
    categories: ["others"],
  },
];

const FAVOURITES_STORAGE_KEY = "kapmeta_report_favourites_v1";

function toDateInputValue(d: Date): string {
  const y = d.getFullYear();
  const m = String(d.getMonth() + 1).padStart(2, "0");
  const day = String(d.getDate()).padStart(2, "0");
  return `${y}-${m}-${day}`;
}

export default function ReportsHubPage() {
  const { me, loading: authLoading } = useAuthGuard("report.read");

  const [activeCategory, setActiveCategory] = useState<ReportCategoryId>("all");
  const [searchQuery, setSearchQuery] = useState("");
  const [editFavMode, setEditFavMode] = useState(false);
  const [favourites, setFavourites] = useState<string[]>(() =>
    REPORT_CATALOG.filter((r) => r.defaultFavourite).map((r) => r.key)
  );

  // Active report details state
  const [selectedReport, setSelectedReport] = useState<ReportDefinition | null>(null);
  const [reportData, setReportData] = useState<SuiteReportData | null>(null);
  const [loadingReport, setLoadingReport] = useState(false);
  const [reportError, setReportError] = useState<string | null>(null);

  // Filters inside report details
  const [datePreset, setDatePreset] = useState<"today" | "7d" | "month" | "30d" | "all" | "custom">("30d");
  const [fromDate, setFromDate] = useState<string>(() => {
    const d = new Date();
    d.setDate(d.getDate() - 29);
    return toDateInputValue(d);
  });
  const [toDate, setToDate] = useState<string>(() => toDateInputValue(new Date()));
  const [scope, setScope] = useState<"all" | "outlet">("all");
  const [rowFilter, setRowFilter] = useState("");
  const [sortCol, setSortCol] = useState<string | null>(null);
  const [sortDir, setSortDir] = useState<"asc" | "desc">("desc");

  useEffect(() => {
    try {
      const saved = window.localStorage.getItem(FAVOURITES_STORAGE_KEY);
      if (saved) {
        const parsed = JSON.parse(saved);
        if (Array.isArray(parsed)) setFavourites(parsed);
      }
    } catch {
      // ignore storage issues
    }
  }, []);

  const toggleFavourite = (key: string, e?: React.MouseEvent) => {
    if (e) e.stopPropagation();
    setFavourites((prev) => {
      const next = prev.includes(key) ? prev.filter((k) => k !== key) : [...prev, key];
      try {
        window.localStorage.setItem(FAVOURITES_STORAGE_KEY, JSON.stringify(next));
      } catch {
        // ignore
      }
      return next;
    });
  };

  const applyPreset = (preset: "today" | "7d" | "month" | "30d" | "all") => {
    setDatePreset(preset);
    const today = new Date();
    if (preset === "today") {
      const s = toDateInputValue(today);
      setFromDate(s);
      setToDate(s);
    } else if (preset === "7d") {
      const start = new Date(today);
      start.setDate(today.getDate() - 6);
      setFromDate(toDateInputValue(start));
      setToDate(toDateInputValue(today));
    } else if (preset === "month") {
      const start = new Date(today.getFullYear(), today.getMonth(), 1);
      setFromDate(toDateInputValue(start));
      setToDate(toDateInputValue(today));
    } else if (preset === "30d") {
      const start = new Date(today);
      start.setDate(today.getDate() - 29);
      setFromDate(toDateInputValue(start));
      setToDate(toDateInputValue(today));
    }
  };

  const fetchReport = async (
    report: ReportDefinition,
    opts?: { preset?: string; from?: string; to?: string; sc?: "all" | "outlet" }
  ) => {
    const activePreset = opts?.preset ?? datePreset;
    const f = opts?.from ?? fromDate;
    const t = opts?.to ?? toDate;
    const sc = opts?.sc ?? scope;

    setLoadingReport(true);
    setReportError(null);
    try {
      const params = new URLSearchParams();
      params.set("scope", sc);
      if (activePreset === "all") {
        params.set("allTime", "true");
      } else {
        if (f) params.set("fromDate", f);
        if (t) params.set("toDate", t);
      }
      const res = await authedFetch(`/reporting/suite/${report.key}?${params.toString()}`);
      if (!res.ok) {
        const body = await res.json().catch(() => ({}));
        throw new Error(body.error || `HTTP ${res.status}`);
      }
      const data: SuiteReportData = await res.json();
      setReportData(data);
    } catch (err: any) {
      setReportError(err?.message || "Failed to load report data");
    } finally {
      setLoadingReport(false);
    }
  };

  const openReport = (report: ReportDefinition) => {
    setSelectedReport(report);
    setRowFilter("");
    setSortCol(null);
    setSortDir("desc");
    fetchReport(report);
  };

  useEffect(() => {
    if (selectedReport) {
      fetchReport(selectedReport);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [datePreset, fromDate, toDate, scope]);

  const filteredCatalog = useMemo(() => {
    const q = searchQuery.trim().toLowerCase();
    return REPORT_CATALOG.filter((rep) => {
      const matchesCat =
        activeCategory === "favourite"
          ? favourites.includes(rep.key)
          : rep.categories.includes(activeCategory);
      if (!matchesCat) return false;
      if (!q) return true;
      return rep.title.toLowerCase().includes(q) || rep.description.toLowerCase().includes(q);
    });
  }, [activeCategory, favourites, searchQuery]);

  const displayedRows = useMemo(() => {
    if (!reportData) return [];
    const q = rowFilter.trim().toLowerCase();
    let list = reportData.rows;
    if (q) {
      list = list.filter((row) =>
        Object.values(row).some((val) => String(val ?? "").toLowerCase().includes(q))
      );
    }
    if (sortCol) {
      list = [...list].sort((a, b) => {
        const va = a[sortCol];
        const vb = b[sortCol];
        if (typeof va === "number" && typeof vb === "number") {
          return sortDir === "asc" ? va - vb : vb - va;
        }
        return sortDir === "asc"
          ? String(va ?? "").localeCompare(String(vb ?? ""))
          : String(vb ?? "").localeCompare(String(va ?? ""));
      });
    }
    return list;
  }, [reportData, rowFilter, sortCol, sortDir]);

  const handleSort = (colKey: string) => {
    if (sortCol === colKey) {
      setSortDir((prev) => (prev === "asc" ? "desc" : "asc"));
    } else {
      setSortCol(colKey);
      setSortDir("desc");
    }
  };

  const handleExportCsv = () => {
    if (!reportData) return;
    const headers = reportData.columns.map((c) => `"${c.label.replace(/"/g, '""')}"`).join(",");
    const lines = displayedRows.map((row) =>
      reportData.columns
        .map((c) => {
          const val = row[c.key] ?? "";
          return `"${String(val).replace(/"/g, '""')}"`;
        })
        .join(",")
    );
    const csv = "\uFEFF" + [headers, ...lines].join("\r\n");
    const blob = new Blob([csv], { type: "text/csv;charset=utf-8;" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = `${reportData.reportKey}_${toDateInputValue(new Date())}.csv`;
    a.click();
    URL.revokeObjectURL(url);
  };

  return (
    <div className="reports-shell">
      <Head>
        <title>KapMeta POS — Reports Hub</title>
        <meta name="description" content="All Restaurant Reports, Order, Item, Category, Customer, and Discount analytics." />
      </Head>

      <div style={{ display: "flex", flex: 1, minHeight: 0 }}>
        <Nav variant="sidebar" />
        <div className="reports-page-col">
          {/* Top bar */}
          <header className="reports-topbar">
            <div className="topbar-left">
              <span className="topbar-title">Reports</span>
              <span className="topbar-sub">
                {selectedReport ? selectedReport.title : "All Restaurant Reports & Analytics"}
              </span>
            </div>
            <div className="topbar-right">
              <div className="user-chip">
                <span className="user-avatar">{me?.name ? me.name.charAt(0).toUpperCase() : "U"}</span>
                <span>{me?.name ?? "User"}</span>
              </div>
            </div>
          </header>

          {authLoading ? (
            <div className="loading-box">Checking permissions...</div>
          ) : selectedReport ? (
            /* ==================== REPORT DETAILS VIEW ==================== */
            <main className="detail-workspace">
              <div className="detail-header-bar">
                <div className="detail-header-left">
                  <button
                    type="button"
                    className="btn-back"
                    onClick={() => {
                      setSelectedReport(null);
                      setReportData(null);
                    }}
                  >
                    ← Back to Reports
                  </button>
                  <div>
                    <h2 className="detail-title">
                      {selectedReport.title}
                      <button
                        type="button"
                        className={`star-btn inline-star ${favourites.includes(selectedReport.key) ? "starred" : ""}`}
                        onClick={(e) => toggleFavourite(selectedReport.key, e)}
                        title={favourites.includes(selectedReport.key) ? "Remove from Favourites" : "Add to Favourites"}
                      >
                        {favourites.includes(selectedReport.key) ? "★" : "☆"}
                      </button>
                    </h2>
                    <p className="detail-desc">{selectedReport.description}</p>
                  </div>
                </div>
                <div className="detail-header-actions">
                  <button
                    type="button"
                    className="btn-outline"
                    onClick={() => fetchReport(selectedReport)}
                    disabled={loadingReport}
                  >
                    🔄 Refresh
                  </button>
                  <button
                    type="button"
                    className="btn-export"
                    onClick={handleExportCsv}
                    disabled={!reportData || displayedRows.length === 0}
                  >
                    📥 Export CSV
                  </button>
                  <button
                    type="button"
                    className="btn-outline"
                    onClick={() => window.print()}
                    disabled={!reportData}
                  >
                    🖨️ Print
                  </button>
                </div>
              </div>

              {/* Filter Controls Bar */}
              <div className="detail-filter-bar">
                <div className="preset-pills">
                  {(
                    [
                      { id: "today", label: "Today" },
                      { id: "7d", label: "Last 7 Days" },
                      { id: "month", label: "This Month" },
                      { id: "30d", label: "Last 30 Days" },
                      { id: "all", label: "All Time" },
                    ] as const
                  ).map((p) => (
                    <button
                      key={p.id}
                      type="button"
                      className={`preset-btn ${datePreset === p.id ? "active" : ""}`}
                      onClick={() => applyPreset(p.id)}
                    >
                      {p.label}
                    </button>
                  ))}
                </div>

                {datePreset !== "all" && (
                  <div className="date-range-inputs">
                    <label>
                      From
                      <input
                        type="date"
                        value={fromDate}
                        onChange={(e) => {
                          setDatePreset("custom");
                          setFromDate(e.target.value);
                        }}
                      />
                    </label>
                    <label>
                      To
                      <input
                        type="date"
                        value={toDate}
                        onChange={(e) => {
                          setDatePreset("custom");
                          setToDate(e.target.value);
                        }}
                      />
                    </label>
                  </div>
                )}

                <div className="scope-toggle">
                  <button
                    type="button"
                    className={scope === "all" ? "active" : ""}
                    onClick={() => setScope("all")}
                  >
                    All Restaurants
                  </button>
                  <button
                    type="button"
                    className={scope === "outlet" ? "active" : ""}
                    onClick={() => setScope("outlet")}
                  >
                    Current Outlet
                  </button>
                </div>

                <div className="table-search-wrap">
                  <input
                    type="text"
                    placeholder="Filter rows..."
                    value={rowFilter}
                    onChange={(e) => setRowFilter(e.target.value)}
                  />
                </div>
              </div>

              {/* Summary KPI Cards */}
              {reportData && (
                <div className="summary-kpi-row">
                  {reportData.summary.map((s) => (
                    <div key={s.label} className={`summary-kpi-card tone-${s.tone || "default"}`}>
                      <span className="kpi-label">{s.label}</span>
                      <span className="kpi-val">{s.value}</span>
                    </div>
                  ))}
                </div>
              )}

              {/* Table Body */}
              <div className="report-table-card">
                {loadingReport ? (
                  <div className="table-state-msg">Loading live report data...</div>
                ) : reportError ? (
                  <div className="table-state-msg error">⚠️ {reportError}</div>
                ) : !reportData || displayedRows.length === 0 ? (
                  <div className="table-state-msg">
                    No records found for this date range. Try selecting <strong>All Time</strong> or another date range.
                  </div>
                ) : (
                  <div className="table-scroll">
                    <table className="suite-table">
                      <thead>
                        <tr>
                          {reportData.columns.map((col) => (
                            <th
                              key={col.key}
                              style={{ textAlign: col.align || "left" }}
                              onClick={() => handleSort(col.key)}
                              title="Click to sort"
                            >
                              <span>{col.label}</span>
                              {sortCol === col.key && (
                                <span className="sort-arrow">{sortDir === "asc" ? " ▲" : " ▼"}</span>
                              )}
                            </th>
                          ))}
                        </tr>
                      </thead>
                      <tbody>
                        {displayedRows.map((row, idx) => (
                          <tr key={idx}>
                            {reportData.columns.map((col) => {
                              const raw = row[col.key];
                              const formatted =
                                col.isCurrency && typeof raw === "number"
                                  ? `₹${raw.toFixed(2)}`
                                  : String(raw ?? "—");
                              return (
                                <td
                                  key={col.key}
                                  style={{ textAlign: col.align || "left" }}
                                  className={col.isCurrency ? "num-cell" : ""}
                                >
                                  {col.key === "status" || col.key === "cancelType" ? (
                                    <span className={`status-badge status-${String(raw).toLowerCase().replace(/\s+/g, "-")}`}>
                                      {formatted}
                                    </span>
                                  ) : (
                                    formatted
                                  )}
                                </td>
                              );
                            })}
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                )}

                {reportData && !loadingReport && (
                  <div className="table-footer">
                    <span>
                      Showing <strong>{displayedRows.length}</strong> of <strong>{reportData.rows.length}</strong> rows
                    </span>
                    <span>Generated {new Date(reportData.generatedAt).toLocaleTimeString()}</span>
                  </div>
                )}
              </div>
            </main>
          ) : (
            /* ==================== REPORTS CATALOG VIEW (MATCHES SCREENSHOT) ==================== */
            <main className="catalog-workspace">
              {/* Left Category Sidebar */}
              <aside className="report-cat-sidebar">
                {SIDEBAR_CATEGORIES.map((cat) => {
                  const isActive = activeCategory === cat.id;
                  const favCount = cat.id === "favourite" ? favourites.length : null;
                  return (
                    <button
                      key={cat.id}
                      type="button"
                      className={`cat-nav-item ${isActive ? "active" : ""}`}
                      onClick={() => setActiveCategory(cat.id)}
                    >
                      <span className="cat-icon">{cat.icon}</span>
                      <span className="cat-label">{cat.label}</span>
                      {favCount !== null && favCount > 0 && <span className="fav-count">{favCount}</span>}
                    </button>
                  );
                })}
              </aside>

              {/* Right Content: Search + 2-Column Report Cards */}
              <section className="report-catalog-main">
                <div className="catalog-search-bar">
                  <div className="search-input-box">
                    <svg
                      className="search-icon"
                      width="16"
                      height="16"
                      viewBox="0 0 24 24"
                      fill="none"
                      stroke="currentColor"
                      strokeWidth="2"
                    >
                      <circle cx="11" cy="11" r="8" />
                      <line x1="21" y1="21" x2="16.65" y2="16.65" />
                    </svg>
                    <input
                      type="text"
                      placeholder="Search for reports here..."
                      value={searchQuery}
                      onChange={(e) => setSearchQuery(e.target.value)}
                    />
                    {searchQuery && (
                      <button type="button" className="clear-search" onClick={() => setSearchQuery("")}>
                        ✕
                      </button>
                    )}
                  </div>

                  <button
                    type="button"
                    className={`btn-edit-fav ${editFavMode ? "active" : ""}`}
                    onClick={() => setEditFavMode((v) => !v)}
                    title={editFavMode ? "Done editing favourites" : "Customize Favourite Reports"}
                  >
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                      <path d="M12 20h9" />
                      <path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z" />
                    </svg>
                  </button>
                </div>

                {editFavMode && (
                  <div className="fav-edit-hint">
                    Click the star (★) on any report card to pin or unpin it from your <strong>Favourite</strong> list.
                  </div>
                )}

                {filteredCatalog.length === 0 ? (
                  <div className="empty-catalog">
                    <div style={{ fontSize: "2rem" }}>📊</div>
                    <h3>No reports found</h3>
                    <p>
                      {activeCategory === "favourite"
                        ? "Star any report to add it to your Favourites."
                        : "Try clearing your search filter to see all reports."}
                    </p>
                  </div>
                ) : (
                  <div className="reports-card-grid">
                    {filteredCatalog.map((rep) => {
                      const isStarred = favourites.includes(rep.key);
                      return (
                        <div
                          key={rep.key}
                          className={`report-card ${editFavMode ? "edit-mode" : ""}`}
                          onClick={() => {
                            if (editFavMode) {
                              toggleFavourite(rep.key);
                            } else {
                              openReport(rep);
                            }
                          }}
                        >
                          <div className="report-card-top">
                            <h3 className="report-card-title">{rep.title}</h3>
                            <button
                              type="button"
                              className={`star-btn ${isStarred ? "starred" : ""}`}
                              onClick={(e) => toggleFavourite(rep.key, e)}
                              aria-label={isStarred ? "Remove from favourites" : "Add to favourites"}
                              title={isStarred ? "Favourited" : "Add to Favourites"}
                            >
                              {isStarred ? "★" : "☆"}
                            </button>
                          </div>
                          <p className="report-card-desc">{rep.description}</p>
                          <div className="report-card-footer">
                            <button
                              type="button"
                              className="view-details-link"
                              onClick={(e) => {
                                e.stopPropagation();
                                openReport(rep);
                              }}
                            >
                              View Details
                            </button>
                          </div>
                        </div>
                      );
                    })}
                  </div>
                )}
              </section>
            </main>
          )}
        </div>
      </div>

      <style jsx>{`
        .reports-shell {
          min-height: 100vh;
          display: flex;
          flex-direction: column;
          background: #f3f5f8;
          color: #1e293b;
        }
        .reports-page-col {
          flex: 1;
          display: flex;
          flex-direction: column;
          min-width: 0;
          background: #f3f5f8;
        }
        .reports-topbar {
          display: flex;
          align-items: center;
          justify-content: space-between;
          padding: 12px 24px;
          background: #ffffff;
          border-bottom: 1px solid #e2e8f0;
        }
        .topbar-left {
          display: flex;
          align-items: baseline;
          gap: 12px;
        }
        .topbar-title {
          font-size: 1.05rem;
          font-weight: 800;
          color: #0f172a;
        }
        .topbar-sub {
          font-size: 0.8125rem;
          color: #64748b;
        }
        .user-chip {
          display: flex;
          align-items: center;
          gap: 8px;
          font-size: 0.8125rem;
          font-weight: 600;
          color: #334155;
        }
        .user-avatar {
          width: 28px;
          height: 28px;
          border-radius: 50%;
          background: #2563eb;
          color: #ffffff;
          display: inline-flex;
          align-items: center;
          justify-content: center;
          font-weight: 700;
          font-size: 0.75rem;
        }
        .loading-box {
          padding: 48px;
          text-align: center;
          color: #64748b;
          font-weight: 600;
        }

        /* ==================== CATALOG WORKSPACE ==================== */
        .catalog-workspace {
          flex: 1;
          display: flex;
          gap: 18px;
          padding: 16px 20px;
          align-items: flex-start;
        }

        .report-cat-sidebar {
          width: 240px;
          flex-shrink: 0;
          background: #ffffff;
          border: 1px solid #e2e8f0;
          border-radius: 8px;
          overflow: hidden;
          box-shadow: 0 1px 2px rgba(15, 23, 42, 0.04);
        }
        .cat-nav-item {
          width: 100%;
          display: flex;
          align-items: center;
          gap: 12px;
          padding: 14px 16px;
          background: #ffffff;
          border: none;
          border-bottom: 1px solid #f1f5f9;
          border-left: 3px solid transparent;
          font-size: 0.8125rem;
          font-weight: 500;
          color: #334155;
          text-align: left;
          cursor: pointer;
          transition: background 0.14s ease, color 0.14s ease;
        }
        .cat-nav-item:last-child {
          border-bottom: none;
        }
        .cat-nav-item:hover {
          background: #f8fafc;
          color: #0f172a;
        }
        .cat-nav-item.active {
          border-left-color: #2563eb;
          background: #f8fafc;
          color: #0f172a;
          font-weight: 700;
        }
        .cat-icon {
          display: inline-flex;
          align-items: center;
          color: #64748b;
          flex-shrink: 0;
        }
        .cat-nav-item.active .cat-icon {
          color: #0f172a;
        }
        .cat-label {
          flex: 1;
        }
        .fav-count {
          background: #eff6ff;
          color: #2563eb;
          font-size: 0.6875rem;
          font-weight: 700;
          padding: 1px 7px;
          border-radius: 999px;
        }

        .report-catalog-main {
          flex: 1;
          min-width: 0;
          display: flex;
          flex-direction: column;
          gap: 16px;
        }
        .catalog-search-bar {
          display: flex;
          align-items: center;
          justify-content: space-between;
          gap: 12px;
        }
        .search-input-box {
          position: relative;
          width: 340px;
          max-width: 100%;
          display: flex;
          align-items: center;
        }
        .search-icon {
          position: absolute;
          left: 12px;
          color: #94a3b8;
          pointer-events: none;
        }
        .search-input-box input {
          width: 100%;
          padding: 9px 32px 9px 36px;
          background: #ffffff;
          border: 1px solid #cbd5e1;
          border-radius: 6px;
          font-size: 0.8125rem;
          color: #0f172a;
          outline: none;
          transition: border-color 0.15s;
        }
        .search-input-box input:focus {
          border-color: #2563eb;
          box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }
        .clear-search {
          position: absolute;
          right: 8px;
          background: none;
          border: none;
          color: #94a3b8;
          cursor: pointer;
          font-size: 0.75rem;
        }
        .btn-edit-fav {
          width: 36px;
          height: 36px;
          display: inline-flex;
          align-items: center;
          justify-content: center;
          background: #ffffff;
          border: 1px solid #3b82f6;
          color: #2563eb;
          border-radius: 6px;
          cursor: pointer;
          transition: all 0.15s ease;
        }
        .btn-edit-fav:hover,
        .btn-edit-fav.active {
          background: #2563eb;
          color: #ffffff;
        }
        .fav-edit-hint {
          background: #eff6ff;
          border: 1px solid #bfdbfe;
          color: #1e40af;
          padding: 8px 14px;
          border-radius: 6px;
          font-size: 0.8rem;
        }

        .reports-card-grid {
          display: grid;
          grid-template-columns: repeat(2, minmax(0, 1fr));
          gap: 16px;
        }
        @media (max-width: 960px) {
          .catalog-workspace {
            flex-direction: column;
          }
          .report-cat-sidebar {
            width: 100%;
          }
          .reports-card-grid {
            grid-template-columns: 1fr;
          }
        }

        .report-card {
          background: #ffffff;
          border: 1px solid #e2e8f0;
          border-radius: 10px;
          padding: 18px 20px;
          min-height: 144px;
          display: flex;
          flex-direction: column;
          justify-content: space-between;
          cursor: pointer;
          box-shadow: 0 1px 2px rgba(15, 23, 42, 0.03);
          transition: border-color 0.15s ease, box-shadow 0.15s ease, transform 0.15s ease;
        }
        .report-card:hover {
          border-color: #93c5fd;
          box-shadow: 0 6px 16px rgba(15, 23, 42, 0.07);
          transform: translateY(-1px);
        }
        .report-card.edit-mode {
          border-style: dashed;
          border-color: #60a5fa;
        }
        .report-card-top {
          display: flex;
          align-items: flex-start;
          justify-content: space-between;
          gap: 12px;
        }
        .report-card-title {
          margin: 0;
          font-size: 0.9375rem;
          font-weight: 700;
          color: #0f172a;
          line-height: 1.35;
        }
        .star-btn {
          background: none;
          border: none;
          font-size: 1.25rem;
          line-height: 1;
          color: #cbd5e1;
          cursor: pointer;
          padding: 0 2px;
          transition: transform 0.12s ease, color 0.12s ease;
        }
        .star-btn:hover {
          transform: scale(1.15);
          color: #f59e0b;
        }
        .star-btn.starred {
          color: #f59e0b;
        }
        .inline-star {
          margin-left: 8px;
          vertical-align: middle;
        }
        .report-card-desc {
          margin: 8px 0 18px 0;
          font-size: 0.8125rem;
          color: #64748b;
          line-height: 1.45;
          flex: 1;
        }
        .report-card-footer {
          display: flex;
          justify-content: flex-end;
        }
        .view-details-link {
          background: none;
          border: none;
          padding: 0;
          font-size: 0.8125rem;
          font-weight: 600;
          color: #334155;
          text-decoration: underline;
          text-underline-offset: 3px;
          cursor: pointer;
        }
        .view-details-link:hover {
          color: #2563eb;
        }

        .empty-catalog {
          background: #ffffff;
          border: 1px solid #e2e8f0;
          border-radius: 10px;
          padding: 48px 24px;
          text-align: center;
          color: #64748b;
        }
        .empty-catalog h3 {
          margin: 8px 0 4px;
          color: #0f172a;
        }

        /* ==================== REPORT DETAILS VIEW ==================== */
        .detail-workspace {
          flex: 1;
          padding: 18px 24px;
          display: flex;
          flex-direction: column;
          gap: 14px;
        }
        .detail-header-bar {
          display: flex;
          justify-content: space-between;
          align-items: flex-start;
          flex-wrap: wrap;
          gap: 12px;
          background: #ffffff;
          border: 1px solid #e2e8f0;
          border-radius: 10px;
          padding: 16px 20px;
        }
        .detail-header-left {
          display: flex;
          align-items: flex-start;
          gap: 14px;
          flex-wrap: wrap;
        }
        .btn-back {
          background: #f1f5f9;
          border: 1px solid #cbd5e1;
          color: #0f172a;
          padding: 7px 12px;
          border-radius: 6px;
          font-size: 0.8rem;
          font-weight: 700;
          cursor: pointer;
        }
        .btn-back:hover {
          background: #e2e8f0;
        }
        .detail-title {
          margin: 0;
          font-size: 1.05rem;
          font-weight: 800;
          color: #0f172a;
        }
        .detail-desc {
          margin: 3px 0 0;
          font-size: 0.8rem;
          color: #64748b;
        }
        .detail-header-actions {
          display: flex;
          gap: 8px;
          flex-wrap: wrap;
        }
        .btn-outline {
          background: #ffffff;
          border: 1px solid #cbd5e1;
          color: #334155;
          padding: 7px 12px;
          border-radius: 6px;
          font-size: 0.8rem;
          font-weight: 600;
          cursor: pointer;
        }
        .btn-outline:hover:not(:disabled) {
          background: #f8fafc;
          border-color: #94a3b8;
        }
        .btn-export {
          background: #16a34a;
          border: 1px solid #15803d;
          color: #ffffff;
          padding: 7px 14px;
          border-radius: 6px;
          font-size: 0.8rem;
          font-weight: 700;
          cursor: pointer;
        }
        .btn-export:hover:not(:disabled) {
          background: #15803d;
        }
        .btn-export:disabled,
        .btn-outline:disabled {
          opacity: 0.5;
          cursor: not-allowed;
        }

        .detail-filter-bar {
          display: flex;
          align-items: center;
          flex-wrap: wrap;
          gap: 10px;
          background: #ffffff;
          border: 1px solid #e2e8f0;
          border-radius: 10px;
          padding: 12px 16px;
        }
        .preset-pills {
          display: flex;
          gap: 4px;
          flex-wrap: wrap;
        }
        .preset-btn {
          background: #f8fafc;
          border: 1px solid #cbd5e1;
          color: #475569;
          padding: 5px 10px;
          border-radius: 6px;
          font-size: 0.75rem;
          font-weight: 600;
          cursor: pointer;
        }
        .preset-btn.active {
          background: #2563eb;
          border-color: #2563eb;
          color: #ffffff;
        }
        .date-range-inputs {
          display: flex;
          align-items: center;
          gap: 8px;
        }
        .date-range-inputs label {
          display: flex;
          align-items: center;
          gap: 5px;
          font-size: 0.75rem;
          font-weight: 600;
          color: #475569;
        }
        .date-range-inputs input {
          padding: 4px 8px;
          border: 1px solid #cbd5e1;
          border-radius: 6px;
          font-size: 0.75rem;
          color: #0f172a;
        }
        .scope-toggle {
          display: inline-flex;
          border: 1px solid #cbd5e1;
          border-radius: 6px;
          overflow: hidden;
        }
        .scope-toggle button {
          background: #ffffff;
          border: none;
          padding: 5px 10px;
          font-size: 0.75rem;
          font-weight: 600;
          color: #475569;
          cursor: pointer;
        }
        .scope-toggle button.active {
          background: #0f172a;
          color: #ffffff;
        }
        .table-search-wrap {
          margin-left: auto;
        }
        .table-search-wrap input {
          padding: 5px 10px;
          border: 1px solid #cbd5e1;
          border-radius: 6px;
          font-size: 0.78rem;
          width: 200px;
          outline: none;
        }
        .table-search-wrap input:focus {
          border-color: #2563eb;
        }

        .summary-kpi-row {
          display: grid;
          grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
          gap: 12px;
        }
        .summary-kpi-card {
          background: #ffffff;
          border: 1px solid #e2e8f0;
          border-radius: 10px;
          padding: 12px 16px;
          display: flex;
          flex-direction: column;
          gap: 4px;
        }
        .summary-kpi-card.tone-success {
          border-left: 4px solid #16a34a;
        }
        .summary-kpi-card.tone-danger {
          border-left: 4px solid #dc2626;
        }
        .summary-kpi-card.tone-info {
          border-left: 4px solid #2563eb;
        }
        .kpi-label {
          font-size: 0.72rem;
          font-weight: 600;
          color: #64748b;
          text-transform: uppercase;
          letter-spacing: 0.03em;
        }
        .kpi-val {
          font-size: 1.15rem;
          font-weight: 800;
          color: #0f172a;
          font-variant-numeric: tabular-nums;
        }

        .report-table-card {
          background: #ffffff;
          border: 1px solid #e2e8f0;
          border-radius: 10px;
          overflow: hidden;
          display: flex;
          flex-direction: column;
        }
        .table-scroll {
          overflow-x: auto;
        }
        .suite-table {
          width: 100%;
          border-collapse: collapse;
          font-size: 0.8125rem;
        }
        .suite-table th {
          background: #f8fafc;
          color: #475569;
          font-size: 0.72rem;
          font-weight: 700;
          text-transform: uppercase;
          letter-spacing: 0.03em;
          padding: 10px 12px;
          border-bottom: 1px solid #e2e8f0;
          white-space: nowrap;
          cursor: pointer;
          user-select: none;
        }
        .suite-table th:hover {
          background: #f1f5f9;
          color: #0f172a;
        }
        .sort-arrow {
          color: #2563eb;
        }
        .suite-table td {
          padding: 9px 12px;
          border-bottom: 1px solid #f1f5f9;
          color: #1e293b;
          white-space: nowrap;
        }
        .suite-table tbody tr:hover {
          background: #f8fafc;
        }
        .num-cell {
          font-variant-numeric: tabular-nums;
          font-weight: 600;
        }
        .status-badge {
          display: inline-block;
          padding: 2px 8px;
          border-radius: 999px;
          font-size: 0.6875rem;
          font-weight: 700;
          background: #f1f5f9;
          color: #475569;
        }
        .status-completed {
          background: #dcfce7;
          color: #166534;
        }
        .status-cancelled,
        .status-voided,
        .status-order-cancelled,
        .status-item-voided {
          background: #fee2e2;
          color: #991b1b;
        }
        .status-open,
        .status-kot_sent,
        .status-in_progress {
          background: #dbeafe;
          color: #1e40af;
        }
        .table-state-msg {
          padding: 40px 24px;
          text-align: center;
          color: #64748b;
          font-size: 0.875rem;
        }
        .table-state-msg.error {
          color: #dc2626;
          font-weight: 600;
        }
        .table-footer {
          display: flex;
          justify-content: space-between;
          padding: 10px 16px;
          background: #f8fafc;
          border-top: 1px solid #e2e8f0;
          font-size: 0.75rem;
          color: #64748b;
        }

        @media print {
          .reports-topbar,
          .detail-filter-bar,
          .detail-header-actions,
          .btn-back {
            display: none !important;
          }
        }
      `}</style>
    </div>
  );
}
