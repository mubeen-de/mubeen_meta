import React, { useState, useEffect, useMemo, useRef } from "react";
import { authedFetch } from "../lib/auth";

interface ItemToggleModalProps {
  onClose: () => void;
}

export type DurationOption = "1hr" | "2hr" | "6hr" | "nextday" | "indefinite";

export interface ItemState {
  id: string;
  name: string;
  categoryName: string;
  priceMinor: number;
  isStocked: boolean;
  stockQty: number;
  isVeg: boolean;
  autoResumeAt?: string | null;
}

const DURATION_PRESETS: { id: DurationOption; label: string; shortLabel: string; hint: string }[] = [
  { id: "1hr", label: "1 Hour", shortLabel: "1 hr", hint: "Auto-enables in 1 hour" },
  { id: "2hr", label: "2 Hours", shortLabel: "2 hr", hint: "Auto-enables in 2 hours" },
  { id: "6hr", label: "6 Hours", shortLabel: "6 hr", hint: "Auto-enables in 6 hours" },
  { id: "nextday", label: "Next Day", shortLabel: "Tomorrow 6 AM", hint: "Auto-enables tomorrow at 6:00 AM" },
  { id: "indefinite", label: "Indefinite", shortLabel: "Manual", hint: "Remains OFF until turned ON manually" },
];

const DEFAULT_MENU_CATALOG: ItemState[] = [
  { id: "bk_1", name: "(2) Idly (1) Vada", categoryName: "Breakfast", priceMinor: 7000, isVeg: true, isStocked: true, stockQty: 100 },
  { id: "bk_2", name: "(S) Idly", categoryName: "Breakfast", priceMinor: 4000, isVeg: true, isStocked: true, stockQty: 100 },
  { id: "bk_3", name: "(S) Idly (S) Vada", categoryName: "Breakfast", priceMinor: 6000, isVeg: true, isStocked: true, stockQty: 100 },
  { id: "bk_4", name: "(S) Idly (S) Vada Sambar", categoryName: "Breakfast", priceMinor: 6500, isVeg: true, isStocked: true, stockQty: 100 },
  { id: "bk_5", name: "(S) Idly Sambar", categoryName: "Breakfast", priceMinor: 4500, isVeg: true, isStocked: true, stockQty: 100 },
  { id: "bk_6", name: "(S) Vada", categoryName: "Breakfast", priceMinor: 4500, isVeg: true, isStocked: true, stockQty: 100 },
  { id: "bk_7", name: "(S) Vada Sambar", categoryName: "Breakfast", priceMinor: 5000, isVeg: true, isStocked: true, stockQty: 100 },
  { id: "bk_8", name: "70 Mm Dosa", categoryName: "Breakfast", priceMinor: 11000, isVeg: true, isStocked: true, stockQty: 100 },
  { id: "bk_9", name: "Butter Masala Dosa", categoryName: "Breakfast", priceMinor: 9500, isVeg: true, isStocked: true, stockQty: 100 },
  { id: "bk_10", name: "Chitti Pesarattu", categoryName: "Breakfast", priceMinor: 8500, isVeg: true, isStocked: true, stockQty: 100 },
  { id: "bk_13", name: "Ghee Karam Idly", categoryName: "Breakfast", priceMinor: 7500, isVeg: true, isStocked: true, stockQty: 100 },
  { id: "bk_19", name: "Masala Dosa", categoryName: "Breakfast", priceMinor: 8000, isVeg: true, isStocked: true, stockQty: 100 },
  { id: "bk_20", name: "Onion Dosa", categoryName: "Breakfast", priceMinor: 8500, isVeg: true, isStocked: true, stockQty: 100 },
  { id: "bk_26", name: "Plain Dosa", categoryName: "Breakfast", priceMinor: 6500, isVeg: true, isStocked: true, stockQty: 100 },
  { id: "bk_27", name: "Poori", categoryName: "Breakfast", priceMinor: 7000, isVeg: true, isStocked: true, stockQty: 100 },
  { id: "bk_31", name: "Vada", categoryName: "Breakfast", priceMinor: 5000, isVeg: true, isStocked: true, stockQty: 100 },
  { id: "mb_1", name: "South Indian Executive Meal Box", categoryName: "Meal Box (Online)", priceMinor: 19900, isVeg: true, isStocked: true, stockQty: 100 },
  { id: "mb_2", name: "North Indian Mini Meal Box", categoryName: "Meal Box (Online)", priceMinor: 18900, isVeg: true, isStocked: true, stockQty: 100 },
  { id: "mb_3", name: "Special Biryani Box (Veg)", categoryName: "Meal Box (Online)", priceMinor: 22000, isVeg: true, isStocked: true, stockQty: 100 },
  { id: "mb_4", name: "Chicken Biryani Combo Box", categoryName: "Meal Box (Online)", priceMinor: 26000, isVeg: false, isStocked: true, stockQty: 100 },
  { id: "cb_1", name: "Fresh Sweet Lime Soda", categoryName: "Cold Beverage", priceMinor: 6000, isVeg: true, isStocked: true, stockQty: 100 },
  { id: "cb_2", name: "Cold Coffee with Ice Cream", categoryName: "Cold Beverage", priceMinor: 9000, isVeg: true, isStocked: true, stockQty: 100 },
  { id: "cb_4", name: "Mango Lassi", categoryName: "Cold Beverage", priceMinor: 8000, isVeg: true, isStocked: true, stockQty: 100 },
  { id: "hb_1", name: "South Indian Filter Coffee", categoryName: "Hot Beverages", priceMinor: 4000, isVeg: true, isStocked: true, stockQty: 100 },
  { id: "hb_2", name: "Special Ginger Tea", categoryName: "Hot Beverages", priceMinor: 3500, isVeg: true, isStocked: true, stockQty: 100 }
];

function calculateResumeDate(option: DurationOption): Date | null {
  const now = new Date();
  if (option === "1hr") {
    return new Date(now.getTime() + 60 * 60 * 1000);
  }
  if (option === "2hr") {
    return new Date(now.getTime() + 2 * 60 * 60 * 1000);
  }
  if (option === "6hr") {
    return new Date(now.getTime() + 6 * 60 * 60 * 1000);
  }
  if (option === "nextday") {
    const nextDay = new Date(now);
    nextDay.setDate(nextDay.getDate() + 1);
    nextDay.setHours(6, 0, 0, 0); // 6:00 AM next morning
    return nextDay;
  }
  return null;
}

function formatRemainingTime(autoResumeAt?: string | null): { text: string; isPast: boolean; title: string } {
  if (!autoResumeAt) {
    return { text: "Manual ON required", isPast: false, title: "Remains OFF until manually enabled" };
  }
  const target = new Date(autoResumeAt).getTime();
  const diffMs = target - Date.now();

  if (isNaN(target)) {
    return { text: "Manual ON required", isPast: false, title: "Invalid date" };
  }

  if (diffMs <= 0) {
    return { text: "Re-enabling now...", isPast: true, title: "Expired, turning ON" };
  }

  const diffSec = Math.floor(diffMs / 1000);
  const diffMin = Math.floor(diffSec / 60);
  const diffHrs = Math.floor(diffMin / 60);

  const targetDate = new Date(target);
  const timeStr = targetDate.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" });

  if (diffMin < 60) {
    return {
      text: `Auto-ON in ${diffMin}m`,
      isPast: false,
      title: `Auto-enables at ${timeStr}`
    };
  }

  if (diffHrs < 24) {
    const remainingMins = diffMin % 60;
    return {
      text: `Auto-ON in ${diffHrs}h ${remainingMins > 0 ? `${remainingMins}m` : ""}`.trim(),
      isPast: false,
      title: `Auto-enables today at ${timeStr}`
    };
  }

  return {
    text: `Auto-ON tomorrow ${timeStr}`,
    isPast: false,
    title: `Auto-enables on ${targetDate.toLocaleDateString()} at ${timeStr}`
  };
}

export default function ItemToggleModal({ onClose }: ItemToggleModalProps) {
  const [items, setItems] = useState<ItemState[]>(() => {
    try {
      const raw = typeof window !== "undefined" ? localStorage.getItem("kapmeta_stock_overrides") : null;
      if (raw) {
        const overrides = JSON.parse(raw);
        return DEFAULT_MENU_CATALOG.map((it) => {
          const ov = overrides[it.id];
          if (ov === undefined) return it;
          if (typeof ov === "boolean") {
            return { ...it, isStocked: ov };
          }
          if (typeof ov === "object" && ov !== null) {
            const hasExpired = ov.autoResumeAt && Date.now() >= new Date(ov.autoResumeAt).getTime();
            return {
              ...it,
              isStocked: hasExpired ? true : ov.isStocked,
              autoResumeAt: hasExpired ? null : ov.autoResumeAt || null,
            };
          }
          return it;
        });
      }
    } catch {}
    return DEFAULT_MENU_CATALOG;
  });

  const [search, setSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState<"ALL" | "IN_STOCK" | "OFF">("ALL");
  const [categoryFilter, setCategoryFilter] = useState<string>("All");
  const [loading, setLoading] = useState(false);
  const [togglingId, setTogglingId] = useState<string | null>(null);
  const [openDurationPickerId, setOpenDurationPickerId] = useState<string | null>(null);
  const [notification, setNotification] = useState<string | null>(null);
  const [nowTick, setNowTick] = useState(Date.now());
  const notificationTimeoutRef = useRef<NodeJS.Timeout | null>(null);

  const showNotification = (msg: string) => {
    if (notificationTimeoutRef.current) clearTimeout(notificationTimeoutRef.current);
    setNotification(msg);
    notificationTimeoutRef.current = setTimeout(() => {
      setNotification(null);
    }, 4000);
  };

  useEffect(() => {
    loadAvailability();
    return () => {
      if (notificationTimeoutRef.current) clearTimeout(notificationTimeoutRef.current);
    };
  }, []);

  // 1-second ticker for live remaining countdown and auto-enabling expired items
  useEffect(() => {
    const interval = setInterval(() => {
      const currentNow = Date.now();
      setNowTick(currentNow);

      setItems((prevItems) => {
        let hasExpiredItem = false;
        const updated = prevItems.map((item) => {
          if (!item.isStocked && item.autoResumeAt) {
            const resumeTime = new Date(item.autoResumeAt).getTime();
            if (currentNow >= resumeTime) {
              hasExpiredItem = true;
              // Silently trigger immediate ON on backend & broadcast
              handleTurnOn(item, true);
              return {
                ...item,
                isStocked: true,
                stockQty: 100,
                autoResumeAt: null,
              };
            }
          }
          return item;
        });

        if (hasExpiredItem) {
          showNotification("Expired items have automatically re-enabled!");
          return updated;
        }
        return prevItems;
      });
    }, 3000);

    return () => clearInterval(interval);
  }, []);

  const loadAvailability = async () => {
    try {
      setLoading(true);
      const res = await authedFetch("/menu/availability");
      if (res.ok) {
        const data = await res.json();
        if (Array.isArray(data) && data.length > 0) {
          const rawOverrides = typeof window !== "undefined" ? localStorage.getItem("kapmeta_stock_overrides") : null;
          const overrides = rawOverrides ? JSON.parse(rawOverrides) : {};

          const mapped = data.map((it: any) => {
            const ov = overrides[it.id];
            let isStocked = it.isStocked;
            let autoResumeAt = it.autoResumeAt || null;

            if (ov !== undefined) {
              if (typeof ov === "boolean") {
                isStocked = ov;
              } else if (typeof ov === "object" && ov !== null) {
                const hasExpired = ov.autoResumeAt && Date.now() >= new Date(ov.autoResumeAt).getTime();
                isStocked = hasExpired ? true : ov.isStocked;
                autoResumeAt = hasExpired ? null : ov.autoResumeAt || null;
              }
            }

            return {
              id: it.id,
              name: it.name,
              categoryName: it.categoryName || it.category?.name || "General",
              priceMinor: Number(it.priceMinor || 0),
              isStocked: Boolean(isStocked),
              stockQty: it.stockQty ?? 100,
              isVeg: it.isVeg ?? true,
              autoResumeAt,
            };
          });
          setItems(mapped);
        }
      }
    } catch (err) {
      console.error("Failed to load item availability", err);
    } finally {
      setLoading(false);
    }
  };

  const persistToLocalAndBroadcast = (itemId: string, isStocked: boolean, autoResumeAt: string | null) => {
    if (typeof window === "undefined") return;
    try {
      const raw = localStorage.getItem("kapmeta_stock_overrides") || "{}";
      const parsed = JSON.parse(raw);
      parsed[itemId] = {
        isStocked,
        autoResumeAt,
      };
      localStorage.setItem("kapmeta_stock_overrides", JSON.stringify(parsed));
    } catch (e) {}

    window.dispatchEvent(
      new CustomEvent("item-availability-changed", {
        detail: {
          itemId,
          isStocked,
          stockQty: isStocked ? 100 : 0,
          autoResumeAt,
        },
      })
    );
  };

  // Immediate Turn ON handler
  const handleTurnOn = async (item: ItemState, silent = false) => {
    if (!silent) setTogglingId(item.id);
    setOpenDurationPickerId(null);
    try {
      await authedFetch(`/menu/items/${item.id}/availability`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          isStocked: true,
          stockQty: 100,
          autoResumeAt: null,
          expectedVersion: 1,
        }),
      }).catch(() => {});

      persistToLocalAndBroadcast(item.id, true, null);

      setItems((prev) =>
        prev.map((it) =>
          it.id === item.id ? { ...it, isStocked: true, stockQty: 100, autoResumeAt: null } : it
        )
      );

      if (!silent) {
        showNotification(`✓ ${item.name} is now turned ON (IN STOCK)`);
      }
    } catch (err) {
      console.error("Failed to turn item ON", err);
    } finally {
      if (!silent) setTogglingId(null);
    }
  };

  // Turn OFF with specific duration option (1hr, 2hr, 6hr, nextday, indefinite)
  const handleTurnOff = async (item: ItemState, duration: DurationOption) => {
    setTogglingId(item.id);
    setOpenDurationPickerId(null);
    const resumeDate = calculateResumeDate(duration);
    const resumeIso = resumeDate ? resumeDate.toISOString() : null;

    try {
      await authedFetch(`/menu/items/${item.id}/availability`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          isStocked: false,
          stockQty: 0,
          durationOption: duration,
          autoResumeAt: resumeIso,
          expectedVersion: 1,
        }),
      }).catch(() => {});

      persistToLocalAndBroadcast(item.id, false, resumeIso);

      setItems((prev) =>
        prev.map((it) =>
          it.id === item.id ? { ...it, isStocked: false, stockQty: 0, autoResumeAt: resumeIso } : it
        )
      );

      const preset = DURATION_PRESETS.find((p) => p.id === duration);
      showNotification(`⊘ ${item.name} set to OFF (${preset?.label || duration})`);
    } catch (err) {
      console.error("Failed to turn item OFF", err);
    } finally {
      setTogglingId(null);
    }
  };

  const categories = useMemo(() => {
    const set = new Set(items.map((i) => i.categoryName).filter(Boolean));
    return ["All", ...Array.from(set)];
  }, [items]);

  const filteredItems = useMemo(() => {
    return items.filter((it) => {
      const matchesSearch =
        it.name.toLowerCase().includes(search.toLowerCase()) ||
        it.categoryName.toLowerCase().includes(search.toLowerCase());
      if (!matchesSearch) return false;

      if (categoryFilter !== "All" && it.categoryName !== categoryFilter) return false;

      if (statusFilter === "IN_STOCK") return it.isStocked;
      if (statusFilter === "OFF") return !it.isStocked;

      return true;
    });
  }, [items, search, categoryFilter, statusFilter, nowTick]);

  const inStockCount = items.filter((i) => i.isStocked).length;
  const offCount = items.length - inStockCount;
  const timedOffCount = items.filter((i) => !i.isStocked && i.autoResumeAt).length;

  return (
    <div className="item-toggle-backdrop" onClick={onClose}>
      <div className="item-toggle-card" onClick={(e) => e.stopPropagation()}>
        {/* Header */}
        <div className="item-toggle-header">
          <div className="header-left">
            <div className="modal-icon-badge">
              <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#dc2626" strokeWidth="2.2">
                <rect x="2" y="6" width="20" height="12" rx="6" />
                <circle cx="8" cy="12" r="3" fill="#dc2626" />
              </svg>
            </div>
            <div>
              <h3 className="modal-title">Item On/Off (86 Stock Control)</h3>
              <p className="modal-subtitle">
                Set items OFF for <strong>1hr, 2hr, 6hr, or Next Day</strong> with automatic re-enable, or enable immediately.
              </p>
            </div>
          </div>
          <button className="close-btn" onClick={onClose} title="Close Modal">✕</button>
        </div>

        {/* Real-time Toast Banner */}
        {notification && (
          <div className="notification-banner">
            <span className="notif-dot">●</span>
            {notification}
          </div>
        )}

        {/* Quick Stats Summary Bar */}
        <div className="stats-bar">
          <div className="stat-pill total">
            <span>Total Items:</span>
            <strong>{items.length}</strong>
          </div>
          <div
            className={`stat-pill in-stock ${statusFilter === "IN_STOCK" ? "active" : ""}`}
            onClick={() => setStatusFilter(statusFilter === "IN_STOCK" ? "ALL" : "IN_STOCK")}
            title="Filter In Stock items"
          >
            <span className="dot dot-green">●</span>
            <span>In Stock:</span>
            <strong>{inStockCount}</strong>
          </div>
          <div
            className={`stat-pill off ${statusFilter === "OFF" ? "active" : ""}`}
            onClick={() => setStatusFilter(statusFilter === "OFF" ? "ALL" : "OFF")}
            title="Filter 86'd Off items"
          >
            <span className="dot dot-red">●</span>
            <span>86'd / OFF:</span>
            <strong>{offCount}</strong>
          </div>
          {timedOffCount > 0 && (
            <div className="stat-pill timed">
              <span className="clock-icon">⏰</span>
              <span>Auto-Timed:</span>
              <strong>{timedOffCount}</strong>
            </div>
          )}
        </div>

        {/* Search & Filters */}
        <div className="filter-controls">
          <div className="search-box">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#94a3b8" strokeWidth="2">
              <circle cx="11" cy="11" r="8" />
              <line x1="21" y1="21" x2="16.65" y2="16.65" />
            </svg>
            <input
              type="text"
              className="toggle-search-input"
              placeholder="Search dish name or category..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
            />
            {search && (
              <button className="clear-search" onClick={() => setSearch("")}>✕</button>
            )}
          </div>

          <div className="category-select-wrapper">
            <select
              className="category-dropdown"
              value={categoryFilter}
              onChange={(e) => setCategoryFilter(e.target.value)}
            >
              {categories.map((c) => (
                <option key={c} value={c}>{c === "All" ? "All Categories" : c}</option>
              ))}
            </select>
          </div>
        </div>

        {/* Scrollable Items List */}
        <div className="items-list-scroll">
          {loading ? (
            <div className="empty-state">
              <div className="spinner" />
              <p>Loading menu items & stock availability...</p>
            </div>
          ) : filteredItems.length === 0 ? (
            <div className="empty-state">
              <span style={{ fontSize: "2rem" }}>🍽️</span>
              <p>No menu items matched your search.</p>
            </div>
          ) : (
            filteredItems.map((item) => {
              const isToggling = togglingId === item.id;
              const isPickerOpen = openDurationPickerId === item.id;
              const remaining = !item.isStocked ? formatRemainingTime(item.autoResumeAt) : null;

              return (
                <div
                  key={item.id}
                  className={`item-toggle-card-row ${item.isStocked ? "is-in-stock" : "is-off"}`}
                >
                  <div className="item-info-cluster">
                    <span className={`veg-indicator ${item.isVeg ? "veg" : "non-veg"}`}>
                      ●
                    </span>
                    <div className="item-text">
                      <div className="item-title-line">
                        <span className="item-name">{item.name}</span>
                        {!item.isStocked && (
                          <span
                            className={`badge-timed ${remaining?.isPast ? "is-past" : ""}`}
                            title={remaining?.title}
                          >
                            <span className="badge-clock">⏰</span>
                            {remaining?.text}
                          </span>
                        )}
                      </div>
                      <div className="item-meta">
                        <span className="item-category">{item.categoryName}</span>
                        <span className="meta-sep">•</span>
                        <span className="item-price">₹{(item.priceMinor / 100).toFixed(2)}</span>
                      </div>
                    </div>
                  </div>

                  {/* Actions & Buttons */}
                  <div className="item-action-cluster">
                    {item.isStocked ? (
                      /* ITEM IS IN STOCK (Turn OFF actions) */
                      <div className="stocked-actions">
                        <span className="status-badge-stock on">IN STOCK</span>

                        {/* Quick Turn OFF Trigger */}
                        <div className="turn-off-trigger-group">
                          <button
                            type="button"
                            disabled={isToggling}
                            className={`btn-turn-off ${isPickerOpen ? "open" : ""}`}
                            onClick={() =>
                              setOpenDurationPickerId(isPickerOpen ? null : item.id)
                            }
                            title="Turn OFF with duration"
                          >
                            {isToggling ? "..." : "Turn OFF ▾"}
                          </button>
                        </div>
                      </div>
                    ) : (
                      /* ITEM IS OFF (Immediate ON + Change Duration) */
                      <div className="off-actions">
                        <span className="status-badge-stock off">86'D OFF</span>

                        {/* 1. Immediate ON Button */}
                        <button
                          type="button"
                          disabled={isToggling}
                          className="btn-immediate-on"
                          onClick={() => handleTurnOn(item)}
                          title="Turn ON Immediately (enable dish right now)"
                        >
                          {isToggling ? "Enabling..." : "⚡ Turn ON Now"}
                        </button>

                        {/* 2. Change / Adjust Duration Trigger */}
                        <button
                          type="button"
                          disabled={isToggling}
                          className={`btn-adjust-duration ${isPickerOpen ? "active" : ""}`}
                          onClick={() =>
                            setOpenDurationPickerId(isPickerOpen ? null : item.id)
                          }
                          title="Change or set duration (1hr, 2hr, 6hr, next day)"
                        >
                          {isPickerOpen ? "Close Options ✕" : "Change Time ▾"}
                        </button>
                      </div>
                    )}
                  </div>

                  {/* Duration Picker Tray (Expands when clicked for both ON and OFF items) */}
                  {isPickerOpen && (
                    <div className="duration-picker-drawer">
                      <div className="drawer-header">
                        <span className="drawer-title">
                          {item.isStocked ? "Select OFF Duration:" : "Change OFF Duration:"}
                        </span>
                        <span className="drawer-hint">Item will automatically re-enable when duration ends.</span>
                      </div>
                      <div className="preset-buttons-row">
                        {DURATION_PRESETS.map((preset) => (
                          <button
                            key={preset.id}
                            type="button"
                            disabled={isToggling}
                            className={`btn-preset-pill ${preset.id === "indefinite" ? "indefinite" : ""}`}
                            onClick={() => handleTurnOff(item, preset.id)}
                            title={preset.hint}
                          >
                            <span className="pill-clock">⏰</span>
                            <strong>{preset.label}</strong>
                            <small className="pill-desc">{preset.shortLabel}</small>
                          </button>
                        ))}
                      </div>
                    </div>
                  )}
                </div>
              );
            })
          )}
        </div>

        {/* Modal Footer */}
        <div className="item-toggle-footer">
          <div className="footer-legend">
            <span>💡 <strong>Tip:</strong> Items with duration auto-enable across POS, Captain & Online channels.</span>
          </div>
          <button type="button" className="footer-close-btn" onClick={onClose}>
            Done
          </button>
        </div>
      </div>

      <style jsx>{`
        .item-toggle-backdrop {
          position: fixed;
          top: 0;
          left: 0;
          width: 100vw;
          height: 100vh;
          background: rgba(15, 23, 42, 0.65);
          backdrop-filter: blur(4px);
          z-index: 1000;
          display: flex;
          align-items: center;
          justify-content: center;
          animation: fadeIn 0.15s ease-out;
        }

        .item-toggle-card {
          background: #ffffff;
          padding: 20px 24px 16px 24px;
          border-radius: 16px;
          width: 95%;
          max-width: 720px;
          box-shadow: 0 25px 50px -12px rgba(15, 23, 42, 0.25), 0 0 0 1px rgba(226, 232, 240, 0.8);
          max-height: 90vh;
          display: flex;
          flex-direction: column;
          gap: 12px;
          animation: slideUp 0.18s ease-out;
        }

        @keyframes fadeIn {
          from { opacity: 0; }
          to { opacity: 1; }
        }

        @keyframes slideUp {
          from { transform: translateY(12px) scale(0.98); opacity: 0; }
          to { transform: translateY(0) scale(1); opacity: 1; }
        }

        .item-toggle-header {
          display: flex;
          align-items: center;
          justify-content: space-between;
          border-bottom: 1px solid #e2e8f0;
          padding-bottom: 12px;
        }

        .header-left {
          display: flex;
          align-items: center;
          gap: 12px;
        }

        .modal-icon-badge {
          width: 40px;
          height: 40px;
          border-radius: 10px;
          background: #fef2f2;
          border: 1px solid #fecaca;
          display: flex;
          align-items: center;
          justify-content: center;
          flex-shrink: 0;
        }

        .modal-title {
          margin: 0;
          font-size: 1.15rem;
          font-weight: 700;
          color: #0f172a;
          letter-spacing: -0.02em;
        }

        .modal-subtitle {
          margin: 2px 0 0 0;
          font-size: 0.8125rem;
          color: #64748b;
        }

        .close-btn {
          background: #f1f5f9;
          border: 1px solid #e2e8f0;
          width: 32px;
          height: 32px;
          border-radius: 8px;
          display: flex;
          align-items: center;
          justify-content: center;
          font-size: 1rem;
          cursor: pointer;
          color: #64748b;
          transition: all 0.15s ease;
        }
        .close-btn:hover {
          background: #e2e8f0;
          color: #0f172a;
        }

        .notification-banner {
          background: #ecfdf5;
          border: 1px solid #a7f3d0;
          color: #065f46;
          font-size: 0.8125rem;
          font-weight: 600;
          padding: 8px 12px;
          border-radius: 8px;
          display: flex;
          align-items: center;
          gap: 8px;
          animation: fadeIn 0.2s ease-in;
        }
        .notif-dot {
          color: #10b981;
          font-size: 0.75rem;
        }

        .stats-bar {
          display: flex;
          align-items: center;
          gap: 8px;
          flex-wrap: wrap;
        }

        .stat-pill {
          display: flex;
          align-items: center;
          gap: 6px;
          padding: 4px 10px;
          border-radius: 20px;
          font-size: 0.75rem;
          border: 1px solid #e2e8f0;
          background: #f8fafc;
          color: #475569;
          cursor: pointer;
          user-select: none;
          transition: all 0.15s ease;
        }
        .stat-pill:hover {
          border-color: #cbd5e1;
        }
        .stat-pill.active {
          border-color: #0284c7;
          background: #f0f9ff;
          color: #0369a1;
          font-weight: 600;
        }
        .stat-pill.timed {
          background: #fffbeb;
          border-color: #fde68a;
          color: #b45309;
        }
        .dot {
          font-size: 0.6875rem;
        }
        .dot-green { color: #16a34a; }
        .dot-red { color: #dc2626; }
        .clock-icon { font-size: 0.8125rem; }

        .filter-controls {
          display: flex;
          align-items: center;
          gap: 10px;
        }

        .search-box {
          position: relative;
          flex: 1;
          display: flex;
          align-items: center;
        }
        .search-box svg {
          position: absolute;
          left: 10px;
          pointer-events: none;
        }
        .toggle-search-input {
          width: 100%;
          padding: 8px 30px 8px 32px;
          border: 1px solid #cbd5e1;
          border-radius: 8px;
          font-size: 0.84rem;
          outline: none;
          transition: border-color 0.15s ease;
        }
        .toggle-search-input:focus {
          border-color: #0284c7;
          box-shadow: 0 0 0 2px rgba(2, 132, 199, 0.15);
        }
        .clear-search {
          position: absolute;
          right: 8px;
          background: none;
          border: none;
          font-size: 0.8rem;
          cursor: pointer;
          color: #94a3b8;
        }

        .category-dropdown {
          padding: 8px 12px;
          border: 1px solid #cbd5e1;
          border-radius: 8px;
          font-size: 0.84rem;
          background: #ffffff;
          color: #334155;
          outline: none;
          cursor: pointer;
        }

        .items-list-scroll {
          flex: 1;
          overflow-y: auto;
          display: flex;
          flex-direction: column;
          gap: 8px;
          padding-right: 4px;
          min-height: 280px;
          max-height: 52vh;
        }

        .empty-state {
          display: flex;
          flex-direction: column;
          align-items: center;
          justify-content: center;
          padding: 40px 20px;
          color: #94a3b8;
          gap: 8px;
          font-size: 0.875rem;
        }

        .spinner {
          width: 24px;
          height: 24px;
          border: 2px solid #e2e8f0;
          border-top-color: #0284c7;
          border-radius: 50%;
          animation: spin 0.6s linear infinite;
        }

        @keyframes spin {
          to { transform: rotate(360deg); }
        }

        .item-toggle-card-row {
          display: flex;
          flex-direction: column;
          padding: 10px 14px;
          border: 1px solid #e2e8f0;
          border-radius: 10px;
          background: #ffffff;
          transition: all 0.15s ease;
        }
        .item-toggle-card-row.is-in-stock:hover {
          border-color: #cbd5e1;
          background: #fafafa;
        }
        .item-toggle-card-row.is-off {
          background: #fffcfc;
          border-color: #fed7d7;
        }

        .item-info-cluster {
          display: flex;
          align-items: flex-start;
          gap: 10px;
          flex: 1;
        }

        .veg-indicator {
          font-size: 0.95rem;
          line-height: 1.2;
        }
        .veg-indicator.veg { color: #16a34a; }
        .veg-indicator.non-veg { color: #dc2626; }

        .item-text {
          flex: 1;
        }

        .item-title-line {
          display: flex;
          align-items: center;
          gap: 8px;
          flex-wrap: wrap;
        }

        .item-name {
          font-weight: 600;
          font-size: 0.9rem;
          color: #0f172a;
        }

        .item-meta {
          font-size: 0.75rem;
          color: #64748b;
          display: flex;
          align-items: center;
          gap: 6px;
          margin-top: 2px;
        }

        .meta-sep {
          color: #cbd5e1;
        }

        .badge-timed {
          display: inline-flex;
          align-items: center;
          gap: 4px;
          background: #fff7ed;
          border: 1px solid #fdba74;
          color: #c2410c;
          font-size: 0.7rem;
          font-weight: 700;
          padding: 2px 7px;
          border-radius: 12px;
          letter-spacing: -0.01em;
        }
        .badge-timed.is-past {
          background: #fef2f2;
          border-color: #fca5a5;
          color: #dc2626;
        }
        .badge-clock {
          font-size: 0.75rem;
        }

        .item-action-cluster {
          display: flex;
          align-items: center;
          justify-content: flex-end;
          gap: 8px;
          margin-top: 6px;
        }

        .status-badge-stock {
          font-size: 0.6875rem;
          font-weight: 700;
          padding: 3px 8px;
          border-radius: 5px;
          letter-spacing: 0.03em;
        }
        .status-badge-stock.on {
          background: #dcfce7;
          color: #15803d;
        }
        .status-badge-stock.off {
          background: #fee2e2;
          color: #b91c1c;
        }

        .stocked-actions, .off-actions {
          display: flex;
          align-items: center;
          gap: 8px;
          flex-wrap: wrap;
        }

        .btn-turn-off {
          background: #ef4444;
          color: #ffffff;
          border: none;
          padding: 6px 12px;
          border-radius: 6px;
          font-size: 0.78rem;
          font-weight: 700;
          cursor: pointer;
          transition: background 0.15s ease;
        }
        .btn-turn-off:hover {
          background: #dc2626;
        }
        .btn-turn-off.open {
          background: #b91c1c;
        }

        .btn-immediate-on {
          background: #16a34a;
          color: #ffffff;
          border: none;
          padding: 6px 14px;
          border-radius: 6px;
          font-size: 0.78rem;
          font-weight: 700;
          cursor: pointer;
          display: flex;
          align-items: center;
          gap: 4px;
          transition: all 0.15s ease;
          box-shadow: 0 1px 2px rgba(22, 163, 74, 0.2);
        }
        .btn-immediate-on:hover {
          background: #15803d;
          transform: translateY(-1px);
        }

        .btn-adjust-duration {
          background: #f8fafc;
          border: 1px solid #cbd5e1;
          color: #334155;
          padding: 6px 10px;
          border-radius: 6px;
          font-size: 0.75rem;
          font-weight: 600;
          cursor: pointer;
          transition: all 0.15s ease;
        }
        .btn-adjust-duration:hover {
          background: #e2e8f0;
          color: #0f172a;
        }
        .btn-adjust-duration.active {
          background: #e2e8f0;
          border-color: #94a3b8;
        }

        /* Duration Picker Drawer */
        .duration-picker-drawer {
          margin-top: 10px;
          padding: 10px 12px;
          background: #f8fafc;
          border: 1px dashed #cbd5e1;
          border-radius: 8px;
          display: flex;
          flex-direction: column;
          gap: 8px;
          animation: slideDown 0.12s ease-out;
        }

        @keyframes slideDown {
          from { opacity: 0; transform: translateY(-4px); }
          to { opacity: 1; transform: translateY(0); }
        }

        .drawer-header {
          display: flex;
          align-items: baseline;
          justify-content: space-between;
          flex-wrap: wrap;
          gap: 6px;
        }

        .drawer-title {
          font-size: 0.75rem;
          font-weight: 700;
          color: #1e293b;
        }

        .drawer-hint {
          font-size: 0.7rem;
          color: #64748b;
        }

        .preset-buttons-row {
          display: grid;
          grid-template-columns: repeat(auto-fit, minmax(110px, 1fr));
          gap: 6px;
        }

        .btn-preset-pill {
          background: #ffffff;
          border: 1px solid #cbd5e1;
          border-radius: 6px;
          padding: 6px 8px;
          display: flex;
          flex-direction: column;
          align-items: center;
          justify-content: center;
          cursor: pointer;
          transition: all 0.15s ease;
          text-align: center;
        }
        .btn-preset-pill:hover {
          border-color: #ef4444;
          background: #fef2f2;
          color: #dc2626;
          transform: translateY(-1px);
        }
        .btn-preset-pill strong {
          font-size: 0.75rem;
          color: #0f172a;
        }
        .btn-preset-pill:hover strong {
          color: #dc2626;
        }
        .pill-clock {
          font-size: 0.75rem;
          margin-bottom: 2px;
        }
        .pill-desc {
          font-size: 0.65rem;
          color: #64748b;
          margin-top: 1px;
        }
        .btn-preset-pill.indefinite:hover {
          border-color: #64748b;
          background: #f1f5f9;
          color: #334155;
        }
        .btn-preset-pill.indefinite:hover strong {
          color: #334155;
        }

        .item-toggle-footer {
          display: flex;
          align-items: center;
          justify-content: space-between;
          border-top: 1px solid #e2e8f0;
          padding-top: 12px;
        }

        .footer-legend {
          font-size: 0.75rem;
          color: #64748b;
        }

        .footer-close-btn {
          background: #0f172a;
          color: #ffffff;
          border: none;
          padding: 8px 18px;
          border-radius: 8px;
          font-size: 0.8125rem;
          font-weight: 600;
          cursor: pointer;
          transition: background 0.15s ease;
        }
        .footer-close-btn:hover {
          background: #1e293b;
        }
      `}</style>
    </div>
  );
}
