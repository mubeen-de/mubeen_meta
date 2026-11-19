import React, { useEffect, useState, useMemo } from "react";
import Head from "next/head";
import { useRouter } from "next/router";

// This page is deliberately public / unauthenticated — a customer scans a QR
// code at their table and lands here with no login. It never imports
// lib/auth or uses authedFetch; it only talks to the PUBLIC endpoints under
function getApiBase(): string {
  if (process.env.NEXT_PUBLIC_API_BASE) {
    return process.env.NEXT_PUBLIC_API_BASE;
  }
  if (typeof window !== "undefined") {
    // When accessed from mobile phone on LAN/Wi-Fi, route API calls to the same host on port 4001
    return `${window.location.protocol}//${window.location.hostname}:4001`;
  }
  return "http://localhost:4001";
}

interface MenuItemApi {
  id: string;
  name: string;
  description: string | null;
  priceMinor: string;
  isVeg: boolean;
  categoryName: string;
  taxRate: string;
}

interface MenuResponse {
  outletName: string | null;
  table: { id: string; tableNumber: string; section: string | null };
  categories: { id: string; name: string }[];
  items: MenuItemApi[];
}

interface CartLine {
  item: MenuItemApi;
  quantity: number;
}

export default function TableSelfOrderPage() {
  const router = useRouter();
  const [tableId, setTableId] = useState<string | null>(null);
  const [waiterId, setWaiterId] = useState<string | null>(null);
  const [captainCode, setCaptainCode] = useState<string | null>(null);
  const [captainName, setCaptainName] = useState<string | null>(null);

  useEffect(() => {
    // 1. Resolve tableId
    const queryId = router.query.tableId;
    if (typeof queryId === "string" && queryId) {
      setTableId(queryId);
    } else {
      const match = window.location.pathname.match(/\/order\/([^/?#]+)/);
      if (match) setTableId(decodeURIComponent(match[1]));
    }

    // 2. Resolve waiter & captain parameters from URL or sessionStorage
    const urlParams = new URLSearchParams(window.location.search);
    const qWaiterId = (typeof router.query.waiterId === "string" ? router.query.waiterId : null) || urlParams.get("waiterId");
    const qCaptainCode = (typeof router.query.captainCode === "string" ? router.query.captainCode : null) || urlParams.get("captainCode") || urlParams.get("captain");
    const qCaptainName = (typeof router.query.captainName === "string" ? router.query.captainName : null) || urlParams.get("captainName");

    if (qWaiterId) {
      setWaiterId(qWaiterId);
      try { sessionStorage.setItem("kapmeta_order_waiterId", qWaiterId); } catch {}
    } else {
      try { setWaiterId(sessionStorage.getItem("kapmeta_order_waiterId")); } catch {}
    }

    if (qCaptainCode) {
      setCaptainCode(qCaptainCode);
      try { sessionStorage.setItem("kapmeta_order_captainCode", qCaptainCode); } catch {}
    } else {
      try { setCaptainCode(sessionStorage.getItem("kapmeta_order_captainCode")); } catch {}
    }

    if (qCaptainName) {
      setCaptainName(qCaptainName);
      try { sessionStorage.setItem("kapmeta_order_captainName", qCaptainName); } catch {}
    } else {
      try { setCaptainName(sessionStorage.getItem("kapmeta_order_captainName")); } catch {}
    }
  }, [router.query]);

  const [menu, setMenu] = useState<MenuResponse | null>(null);
  const [loading, setLoading] = useState(true);
  const [loadError, setLoadError] = useState<string | null>(null);
  const [selectedCategory, setSelectedCategory] = useState<string>("All");
  const [searchQuery, setSearchQuery] = useState("");
  const [vegOnly, setVegOnly] = useState(false);
  const [cart, setCart] = useState<Record<string, CartLine>>({});
  const [notes, setNotes] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const [submitError, setSubmitError] = useState<string | null>(null);
  const [confirmation, setConfirmation] = useState<{
    orderNumber: string | null;
    captainCode: string | null;
    captainName: string | null;
  } | null>(null);

  useEffect(() => {
    if (!tableId) return;
    setLoading(true);
    setLoadError(null);
    fetch(`${getApiBase()}/public/tables/${tableId}/menu`)
      .then(async (res) => {
        if (!res.ok) {
          const body = await res.json().catch(() => ({}));
          throw new Error(body.error || "This table's ordering link is no longer valid.");
        }
        return res.json();
      })
      .then((data: MenuResponse) => setMenu(data))
      .catch((err) => setLoadError(err.message || "Failed to load menu"))
      .finally(() => setLoading(false));
  }, [tableId]);

  const categories = useMemo(() => {
    if (!menu) return ["All"];
    const names = Array.from(new Set(menu.items.map((i) => i.categoryName)));
    return ["All", ...names];
  }, [menu]);

  const filteredItems = useMemo(() => {
    if (!menu) return [];
    return menu.items.filter((item) => {
      if (selectedCategory !== "All" && item.categoryName !== selectedCategory) return false;
      if (vegOnly && !item.isVeg) return false;
      if (searchQuery.trim()) {
        const query = searchQuery.toLowerCase();
        const matchName = item.name.toLowerCase().includes(query);
        const matchDesc = item.description?.toLowerCase().includes(query);
        if (!matchName && !matchDesc) return false;
      }
      return true;
    });
  }, [menu, selectedCategory, vegOnly, searchQuery]);

  const cartLines = Object.values(cart);
  const cartCount = cartLines.reduce((sum, l) => sum + l.quantity, 0);
  const cartTotalMinor = cartLines.reduce((sum, l) => sum + Number(l.item.priceMinor) * l.quantity, 0);

  const addToCart = (item: MenuItemApi) => {
    setCart((prev) => {
      const existing = prev[item.id];
      return { ...prev, [item.id]: { item, quantity: (existing?.quantity || 0) + 1 } };
    });
  };

  const changeQty = (itemId: string, delta: number) => {
    setCart((prev) => {
      const existing = prev[itemId];
      if (!existing) return prev;
      const nextQty = existing.quantity + delta;
      if (nextQty <= 0) {
        const { [itemId]: _removed, ...rest } = prev;
        return rest;
      }
      return { ...prev, [itemId]: { ...existing, quantity: nextQty } };
    });
  };

  const submitOrder = async () => {
    if (!menu || cartLines.length === 0) return;
    setSubmitting(true);
    setSubmitError(null);
    try {
      const idempotencyKey = `qr-${menu.table.id}-${Date.now()}-${Math.random().toString(36).slice(2)}`;
      const res = await fetch(`${getApiBase()}/public/tables/${menu.table.id}/order`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          idempotencyKey,
          waiterId: waiterId || undefined,
          captainCode: captainCode || undefined,
          captainName: captainName || undefined,
          lines: cartLines.map((l) => ({
            menuItemId: l.item.id,
            quantity: l.quantity,
            modifierOptionIds: [],
            notes: notes || undefined,
          })),
        }),
      });
      const data = await res.json();
      if (!res.ok) {
        setSubmitError(data.error || "Failed to place order. Please try again or ask staff for help.");
        return;
      }
      setConfirmation({
        orderNumber: data.orderNumber,
        captainCode: data.captainCode || captainCode,
        captainName: data.captainName || captainName,
      });
      setCart({});
      setNotes("");
    } catch (err) {
      setSubmitError("Network error — please check your connection and try again.");
    } finally {
      setSubmitting(false);
    }
  };

  if (loading) {
    return (
      <Centered>
        <Spinner />
        <p className="text-slate-500 text-sm mt-3">Loading menu...</p>
      </Centered>
    );
  }

  if (loadError || !menu) {
    return (
      <Centered>
        <div className="text-4xl mb-3">⚠️</div>
        <p className="text-slate-700 font-semibold">{loadError || "Table not found"}</p>
        <p className="text-slate-500 text-sm mt-1">Please ask a staff member for assistance.</p>
      </Centered>
    );
  }

  if (confirmation) {
    const assignedStaff = confirmation.captainCode || confirmation.captainName || "Your Captain";
    return (
      <Centered>
        <div className="w-16 h-16 rounded-full bg-emerald-100 text-emerald-600 flex items-center justify-center text-3xl mb-4 shadow-inner">
          ✓
        </div>
        <h1 className="text-2xl font-black text-slate-900 mb-1">Order Sent to Kitchen!</h1>
        {confirmation.orderNumber && (
          <div className="bg-slate-100 border border-slate-200 px-4 py-2 rounded-xl my-3 inline-block">
            <span className="text-xs text-slate-500 uppercase tracking-wider font-semibold block">Order Reference</span>
            <span className="text-lg font-black text-slate-900">#{confirmation.orderNumber}</span>
          </div>
        )}
        <div className="bg-indigo-50 border border-indigo-200/80 rounded-2xl p-4 my-3 max-w-sm text-left">
          <div className="flex items-center gap-2 mb-1">
            <span className="text-xl">🧑‍🍳</span>
            <span className="text-xs font-bold text-indigo-900 uppercase tracking-wider">Assigned Staff</span>
          </div>
          <p className="text-sm font-extrabold text-indigo-950">
            {assignedStaff.toUpperCase()}
          </p>
          <p className="text-xs text-indigo-700 mt-1">
            Your captain has been notified on their tablet and will attend Table {menu.table.tableNumber}.
          </p>
        </div>
        <p className="text-slate-500 text-xs mb-6 max-w-xs">
          Your food is being freshly prepared in the kitchen. Enjoy your dining experience!
        </p>
        <button
          type="button"
          onClick={() => setConfirmation(null)}
          className="bg-indigo-600 hover:bg-indigo-700 text-white text-sm font-bold px-6 py-3 rounded-xl transition shadow-lg shadow-indigo-500/20 active:scale-95"
        >
          + Order Additional Items
        </button>
      </Centered>
    );
  }

  return (
    <div className="min-h-screen bg-slate-50 text-slate-900 font-sans pb-32">
      <Head>
        <title>Order — Table {menu.table.tableNumber}</title>
      </Head>

      <header className="bg-white border-b border-slate-200 px-4 py-3 sticky top-0 z-20 shadow-sm">
        <div className="max-w-3xl mx-auto flex items-center justify-between">
          <div>
            <h1 className="font-extrabold text-slate-900 text-base">{menu.outletName ?? "KapMeta POS"}</h1>
            <p className="text-xs text-slate-500">
              Table {menu.table.tableNumber}
              {menu.table.section ? ` · ${menu.table.section}` : ""}
            </p>
          </div>
          <span className="text-xs bg-emerald-50 text-emerald-700 border border-emerald-200 px-2.5 py-1 rounded-full font-bold">
            📱 Self Order
          </span>
        </div>
      </header>

      {/* Attending Captain Banner */}
      {(captainCode || captainName) && (
        <div className="bg-gradient-to-r from-indigo-900 via-indigo-950 to-slate-900 text-white px-4 py-2.5 shadow-inner">
          <div className="max-w-3xl mx-auto flex items-center justify-between">
            <div className="flex items-center gap-2.5">
              <span className="text-xl">🧑‍🍳</span>
              <div>
                <span className="text-[10px] uppercase font-extrabold tracking-wider text-indigo-300 block">Attending Captain</span>
                <span className="text-xs font-bold text-white">{captainName || `Captain ${captainCode}`}</span>
              </div>
            </div>
            <span className="text-[10px] bg-indigo-500/30 text-indigo-200 border border-indigo-400/40 px-2.5 py-0.5 rounded-full font-mono font-bold tracking-wider">
              {captainCode ? captainCode.toUpperCase() : "CAP"}
            </span>
          </div>
        </div>
      )}

      <div className="max-w-3xl mx-auto px-4">
        {/* Search Bar & Veg Filter */}
        <div className="mt-3 flex gap-2">
          <div className="relative flex-1">
            <span className="absolute left-3 top-2.5 text-slate-400 text-xs">🔍</span>
            <input
              type="text"
              placeholder="Search dishes (e.g. Dosa, Idly, Biryani)..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full bg-white border border-slate-200 rounded-xl pl-8 pr-3 py-2 text-xs focus:outline-none focus:border-indigo-500 shadow-sm text-slate-900"
            />
            {searchQuery && (
              <button
                type="button"
                onClick={() => setSearchQuery("")}
                className="absolute right-2.5 top-2 text-slate-400 hover:text-slate-600 text-xs font-bold"
              >
                ✕
              </button>
            )}
          </div>
          <button
            type="button"
            onClick={() => setVegOnly(!vegOnly)}
            className={`px-3 py-2 rounded-xl text-xs font-bold border transition flex items-center gap-1.5 shadow-sm whitespace-nowrap ${
              vegOnly
                ? "bg-emerald-600 text-white border-emerald-600"
                : "bg-white text-slate-700 border-slate-200 hover:border-emerald-500"
            }`}
          >
            <span className="w-2 h-2 rounded-full border border-current bg-emerald-500" />
            Veg Only
          </button>
        </div>
        {/* Category filter */}
        <div className="flex gap-2 overflow-x-auto py-3 -mx-1 px-1">
          {categories.map((c) => (
            <button
              key={c}
              type="button"
              onClick={() => setSelectedCategory(c)}
              className={`px-3.5 py-1.5 rounded-full text-xs font-bold whitespace-nowrap transition border ${
                selectedCategory === c
                  ? "bg-indigo-600 text-white border-indigo-600"
                  : "bg-white text-slate-600 border-slate-200 hover:border-slate-300"
              }`}
            >
              {c}
            </button>
          ))}
        </div>

        {/* Menu items */}
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 mt-1">
          {filteredItems.length === 0 && (
            <p className="text-slate-500 text-sm col-span-2 text-center py-10">No items in this category.</p>
          )}
          {filteredItems.map((item) => {
            const qty = cart[item.id]?.quantity || 0;
            return (
              <div
                key={item.id}
                className="bg-white border border-slate-200 rounded-2xl p-3.5 flex flex-col gap-2 shadow-sm"
              >
                <div className="flex items-start justify-between gap-2">
                  <div className="flex items-start gap-2 min-w-0">
                    <span
                      className={`mt-1 inline-block w-2.5 h-2.5 rounded-sm border-2 shrink-0 ${
                        item.isVeg ? "border-emerald-600" : "border-rose-600"
                      }`}
                      title={item.isVeg ? "Veg" : "Non-veg"}
                    />
                    <div className="min-w-0">
                      <p className="font-bold text-sm text-slate-900 truncate">{item.name}</p>
                      {item.description && (
                        <p className="text-xs text-slate-500 line-clamp-2">{item.description}</p>
                      )}
                    </div>
                  </div>
                </div>
                <div className="flex items-center justify-between mt-1">
                  <span className="font-extrabold text-sm text-slate-900">
                    ₹{(Number(item.priceMinor) / 100).toFixed(2)}
                  </span>
                  {qty === 0 ? (
                    <button
                      type="button"
                      onClick={() => addToCart(item)}
                      className="bg-indigo-600 hover:bg-indigo-700 text-white text-xs font-bold px-3.5 py-1.5 rounded-lg transition"
                    >
                      Add
                    </button>
                  ) : (
                    <div className="flex items-center gap-2 bg-indigo-50 border border-indigo-200 rounded-lg px-1">
                      <button
                        type="button"
                        onClick={() => changeQty(item.id, -1)}
                        className="w-6 h-6 flex items-center justify-center text-indigo-700 font-bold"
                      >
                        −
                      </button>
                      <span className="text-xs font-extrabold text-indigo-700 min-w-[16px] text-center">{qty}</span>
                      <button
                        type="button"
                        onClick={() => changeQty(item.id, 1)}
                        className="w-6 h-6 flex items-center justify-center text-indigo-700 font-bold"
                      >
                        +
                      </button>
                    </div>
                  )}
                </div>
              </div>
            );
          })}
        </div>

        {cartCount > 0 && (
          <div className="mt-4">
            <label className="text-xs font-semibold text-slate-600 mb-1 block">
              Any special instructions? (optional)
            </label>
            <textarea
              value={notes}
              onChange={(e) => setNotes(e.target.value)}
              rows={2}
              placeholder="e.g. less spicy, no onions..."
              className="w-full bg-white border border-slate-200 rounded-xl px-3 py-2 text-sm focus:outline-none focus:border-indigo-400"
            />
          </div>
        )}

        {submitError && (
          <p className="text-rose-600 text-xs font-semibold mt-3 bg-rose-50 border border-rose-200 rounded-lg px-3 py-2">
            {submitError}
          </p>
        )}
      </div>

      {/* Sticky cart bar */}
      {cartCount > 0 && (
        <div className="fixed bottom-0 left-0 right-0 bg-white border-t border-slate-200 shadow-2xl px-4 py-3 z-30">
          <div className="max-w-3xl mx-auto flex items-center justify-between gap-3">
            <div>
              <p className="text-xs text-slate-500">{cartCount} item{cartCount > 1 ? "s" : ""}</p>
              <p className="font-extrabold text-slate-900">₹{(cartTotalMinor / 100).toFixed(2)}</p>
            </div>
            <button
              type="button"
              disabled={submitting}
              onClick={submitOrder}
              className="bg-indigo-600 hover:bg-indigo-700 disabled:opacity-60 text-white font-bold text-sm px-6 py-2.5 rounded-xl transition"
            >
              {submitting ? "Placing order..." : "Place Order"}
            </button>
          </div>
        </div>
      )}
    </div>
  );
}

function Centered({ children }: { children: React.ReactNode }) {
  return (
    <div className="min-h-screen bg-slate-50 flex flex-col items-center justify-center text-center px-6">
      {children}
    </div>
  );
}

function Spinner() {
  return <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-indigo-500" />;
}
