import React, { useState, useEffect } from "react";

export interface DiningTable {
  id: string;
  tableNumber: string;
  section: string;
  status: any;
  capacity?: number;
  isActive?: boolean;
  [key: string]: any;
}

interface CaptainMenuQrModalProps {
  isOpen: boolean;
  onClose: () => void;
  tables: any[];
  selectedTable: any;
  captainCode: string;
  waiterId?: string | null;
  waiterName?: string | null;
  onTableChange?: (table: any) => void;
  lastCustomerOrder?: {
    orderId: string;
    orderNumber: string | null;
    tableId: string;
    tableNumber: string;
    itemsCount?: number;
    captainCode?: string | null;
  } | null;
}

export default function CaptainMenuQrModal({
  isOpen,
  onClose,
  tables,
  selectedTable: initialTable,
  captainCode,
  waiterId,
  waiterName,
  onTableChange,
  lastCustomerOrder,
}: CaptainMenuQrModalProps) {
  const [currentTableId, setCurrentTableId] = useState<string>(
    initialTable?.id || tables[0]?.id || ""
  );
  const [activeCaptainCode, setActiveCaptainCode] = useState<string>(captainCode || "cap");
  const [isFullscreen, setIsFullscreen] = useState<boolean>(false);
  const [customHost, setCustomHost] = useState<string>("");
  const [detectedIps, setDetectedIps] = useState<string[]>([]);
  const [showHostInput, setShowHostInput] = useState<boolean>(false);
  const [copied, setCopied] = useState<boolean>(false);

  useEffect(() => {
    if (initialTable?.id && tables.some((t) => t.id === initialTable.id)) {
      setCurrentTableId(initialTable.id);
    } else if (tables.length > 0) {
      if (!currentTableId || !tables.some((t) => t.id === currentTableId)) {
        setCurrentTableId(tables[0].id);
      }
    }
  }, [initialTable, tables, currentTableId]);

  useEffect(() => {
    if (captainCode) {
      setActiveCaptainCode(captainCode);
    }
  }, [captainCode]);

  useEffect(() => {
    if (typeof window !== "undefined") {
      const savedHost = localStorage.getItem("kapmeta_customer_qr_host");
      if (savedHost) {
        setCustomHost(savedHost);
      }

      // Auto-detect local Wi-Fi IP from backend API
      const apiHost = `${window.location.protocol}//${window.location.hostname}:4001`;
      fetch(`${apiHost}/system/network-ip`)
        .then((res) => res.json())
        .then((data) => {
          if (data?.ips && Array.isArray(data.ips)) {
            setDetectedIps(data.ips);
            // If current saved host is localhost or missing, and a real LAN IP is found, auto-suggest it
            if ((!savedHost || savedHost.includes("localhost") || savedHost.includes("127.0.0.1")) && data.primaryIp) {
              const autoHost = `http://${data.primaryIp}:4444`;
              setCustomHost(autoHost);
              localStorage.setItem("kapmeta_customer_qr_host", autoHost);
            }
          }
        })
        .catch(() => {});
    }
  }, []);

  if (!isOpen) return null;

  const currentTable = tables.find((t) => t.id === currentTableId) || (tables.length > 0 ? tables[0] : initialTable);
  const origin = customHost.trim()
    ? customHost.trim().replace(/\/$/, "")
    : typeof window !== "undefined"
    ? window.location.origin
    : "http://localhost:4444";

  const isLocalhost = origin.includes("localhost") || origin.includes("127.0.0.1");

  const customerOrderUrl = `${origin}/order/${encodeURIComponent(currentTable?.id || "")}?waiterId=${encodeURIComponent(
    waiterId || ""
  )}&captainCode=${encodeURIComponent(activeCaptainCode)}&captainName=${encodeURIComponent(
    waiterName || activeCaptainCode
  )}`;

  const qrImageSrc = `https://api.qrserver.com/v1/create-qr-code/?size=${
    isFullscreen ? "400x400" : "280x280"
  }&data=${encodeURIComponent(customerOrderUrl)}&margin=12&color=050510`;

  const handleCopy = () => {
    navigator.clipboard.writeText(customerOrderUrl);
    setCopied(true);
    setTimeout(() => setCopied(false), 2500);
  };

  const handleSaveHost = () => {
    if (typeof window !== "undefined") {
      if (customHost.trim()) {
        localStorage.setItem("kapmeta_customer_qr_host", customHost.trim());
      } else {
        localStorage.removeItem("kapmeta_customer_qr_host");
      }
    }
    setShowHostInput(false);
  };

  const isOrderForThisTable =
    lastCustomerOrder &&
    currentTable &&
    (lastCustomerOrder.tableId === currentTable.id ||
      lastCustomerOrder.tableNumber.trim().toLowerCase() === currentTable.tableNumber.trim().toLowerCase());

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/80 backdrop-blur-md p-4 animate-in fade-in duration-150">
      <div
        className={`bg-slate-900 border border-slate-700/80 rounded-3xl shadow-2xl overflow-hidden flex flex-col text-slate-100 transition-all ${
          isFullscreen ? "w-full max-w-xl p-6" : "w-full max-w-md"
        }`}
      >
        {/* Header */}
        <div className="px-6 py-4 bg-gradient-to-r from-indigo-950 via-slate-900 to-slate-900 border-b border-indigo-500/20 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <span className="flex h-10 w-10 items-center justify-center rounded-2xl bg-indigo-500/10 text-indigo-400 border border-indigo-500/30 text-xl shadow-inner">
              📱
            </span>
            <div>
              <div className="flex items-center gap-2">
                <h3 className="text-base font-extrabold text-white">Customer Menu QR</h3>
                <span className="bg-indigo-500/20 text-indigo-300 text-[10px] font-mono font-bold px-2 py-0.5 rounded-full border border-indigo-500/30">
                  {activeCaptainCode.toUpperCase()}
                </span>
              </div>
              <p className="text-xs text-slate-400">Show tablet to customer to scan & self-order</p>
            </div>
          </div>
          <div className="flex items-center gap-2">
            <button
              type="button"
              onClick={() => setIsFullscreen(!isFullscreen)}
              className="text-slate-400 hover:text-white p-1.5 rounded-xl hover:bg-slate-800 transition text-sm"
              title={isFullscreen ? "Exit Fullscreen" : "Fullscreen Kiosk View"}
            >
              {isFullscreen ? "🗗" : "⛶"}
            </button>
            <button
              type="button"
              onClick={onClose}
              className="text-slate-400 hover:text-white p-1.5 rounded-xl hover:bg-slate-800 transition text-lg"
              title="Close"
            >
              ✕
            </button>
          </div>
        </div>

        {/* Modal Body */}
        <div className="p-6 flex flex-col items-center text-center space-y-4 max-h-[85vh] overflow-y-auto">
          {/* Recent Live Order Banner */}
          {isOrderForThisTable && (
            <div className="w-full bg-emerald-950/80 border border-emerald-500/40 rounded-2xl p-3.5 text-left flex items-start gap-3 shadow-lg shadow-emerald-950/30 animate-in zoom-in-95 duration-200">
              <span className="text-2xl mt-0.5">🎉</span>
              <div className="flex-1 min-w-0">
                <p className="text-xs font-bold uppercase tracking-wider text-emerald-400">
                  New Order Received from Customer!
                </p>
                <p className="text-sm font-extrabold text-white">
                  Table {currentTable?.tableNumber} · Order #{lastCustomerOrder.orderNumber || "NEW"}
                </p>
                <p className="text-xs text-emerald-300/80 mt-0.5">
                  Assigned to Captain <span className="font-bold">{activeCaptainCode.toUpperCase()}</span>. KOT sent to kitchen!
                </p>
              </div>
            </div>
          )}

          {/* Localhost Prevention Warning */}
          {isLocalhost && (
            <div className="w-full bg-amber-950/90 border border-amber-500/50 rounded-2xl p-3.5 text-left flex items-start gap-3 shadow-lg shadow-amber-950/40 animate-in fade-in duration-200">
              <span className="text-2xl mt-0.5">⚠️</span>
              <div className="flex-1 min-w-0">
                <p className="text-xs font-bold uppercase tracking-wider text-amber-400">
                  QR Contains &quot;localhost&quot; (Will Refuse Connection)
                </p>
                <p className="text-xs text-amber-200/90 mt-0.5 leading-relaxed">
                  Phones scanning with Google Lens see <em>&quot;localhost refused to connect&quot;</em> because localhost looks at the phone, not this PC.
                </p>
                {detectedIps.length > 0 ? (
                  <div className="mt-2.5 flex flex-col gap-1.5">
                    <span className="text-[11px] text-amber-300 font-bold">1-Click: Use PC Wi-Fi IP for QR:</span>
                    <div className="flex gap-2 flex-wrap">
                      {detectedIps.map((ip) => (
                        <button
                          key={ip}
                          type="button"
                          onClick={() => {
                            const target = `http://${ip}:4444`;
                            setCustomHost(target);
                            if (typeof window !== "undefined") {
                              localStorage.setItem("kapmeta_customer_qr_host", target);
                            }
                            setShowHostInput(false);
                          }}
                          className="bg-amber-400 hover:bg-amber-300 text-slate-950 text-xs font-mono font-extrabold px-3 py-1.5 rounded-xl shadow transition active:scale-95 flex items-center gap-1.5"
                        >
                          <span>📶</span>
                          <span>http://{ip}:4444</span>
                        </button>
                      ))}
                    </div>
                  </div>
                ) : (
                  <button
                    type="button"
                    onClick={() => setShowHostInput(true)}
                    className="mt-2 inline-flex items-center gap-1 text-xs font-bold bg-amber-400 hover:bg-amber-300 text-slate-950 px-3 py-1.5 rounded-xl transition"
                  >
                    Enter Wi-Fi IP Address →
                  </button>
                )}
              </div>
            </div>
          )}

          {/* Table Selector & Captain Bar */}
          <div className="grid grid-cols-2 gap-2.5 w-full">
            <div className="text-left">
              <label className="block text-[11px] font-semibold text-slate-400 mb-1">Select Table</label>
              <select
                value={currentTableId}
                onChange={(e) => {
                  setCurrentTableId(e.target.value);
                  const found = tables.find((t) => t.id === e.target.value);
                  if (found && onTableChange) onTableChange(found);
                }}
                className="w-full bg-slate-800 border border-slate-700 rounded-xl px-3 py-2 text-xs font-bold text-white focus:outline-none focus:border-indigo-400"
              >
                {tables.map((t) => (
                  <option key={t.id} value={t.id}>
                    Table {t.tableNumber} ({t.section || "General"})
                  </option>
                ))}
              </select>
            </div>

            <div className="text-left">
              <label className="block text-[11px] font-semibold text-slate-400 mb-1">Order Goes To</label>
              <div className="flex items-center gap-1.5 bg-slate-800 border border-slate-700 rounded-xl px-3 py-2">
                <span className="text-xs">🧑‍🍳</span>
                <input
                  type="text"
                  value={activeCaptainCode}
                  onChange={(e) => setActiveCaptainCode(e.target.value)}
                  placeholder="cap, cap2..."
                  className="w-full bg-transparent text-xs font-mono font-bold text-indigo-300 focus:outline-none"
                  title="Captain Station Code (orders will be attributed to this captain)"
                />
              </div>
            </div>
          </div>

          {/* Scannable QR Code Card */}
          <div className="relative p-5 bg-white rounded-3xl shadow-2xl border-4 border-indigo-500/30 flex flex-col items-center">
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img
              src={qrImageSrc}
              alt={`Table ${currentTable?.tableNumber} Menu QR Code`}
              className={`rounded-xl transition-all ${
                isFullscreen ? "w-72 h-72 sm:w-80 sm:h-80" : "w-52 h-52 sm:w-56 sm:h-56"
              }`}
            />
            <div className="mt-3 flex items-center justify-between w-full px-2">
              <div className="text-left">
                <span className="text-[10px] uppercase font-bold text-slate-500 block">Table Number</span>
                <span className="text-base font-black text-slate-900 tracking-tight">
                  Table {currentTable?.tableNumber}
                </span>
              </div>
              <div className="text-right">
                <span className="text-[10px] uppercase font-bold text-slate-500 block">Attending</span>
                <span className="text-xs font-mono font-bold bg-indigo-50 text-indigo-700 border border-indigo-200 px-2 py-0.5 rounded-md">
                  {activeCaptainCode.toUpperCase()}
                </span>
              </div>
            </div>
          </div>

          {/* Instruction Pill */}
          <div className="flex items-center gap-2 bg-slate-800/80 border border-slate-700/60 px-4 py-2 rounded-2xl">
            <span className="flex h-2 w-2 rounded-full bg-emerald-400 animate-ping" />
            <p className="text-xs text-slate-300 font-medium">
              Customer points camera at QR code to open menu & place order
            </p>
          </div>

          {/* Action Row */}
          <div className="grid grid-cols-2 gap-2.5 w-full pt-1">
            <button
              type="button"
              onClick={handleCopy}
              className="flex items-center justify-center gap-1.5 py-2.5 px-3 rounded-xl bg-slate-800 hover:bg-slate-700 border border-slate-700 text-slate-200 text-xs font-bold transition active:scale-95"
            >
              {copied ? "✓ Copied!" : "📋 Copy Order Link"}
            </button>

            <button
              type="button"
              onClick={() => setShowHostInput(!showHostInput)}
              className="flex items-center justify-center gap-1.5 py-2.5 px-3 rounded-xl bg-slate-800 hover:bg-slate-700 border border-slate-700 text-slate-200 text-xs font-bold transition active:scale-95"
            >
              🌐 {showHostInput ? "Hide IP Config" : "WiFi / LAN IP"}
            </button>
          </div>

          {/* Optional Host/IP Override for Local Wi-Fi Tablet Deployments */}
          {showHostInput && (
            <div className="w-full bg-slate-950/70 border border-slate-800 rounded-2xl p-3 text-left space-y-2">
              <label className="text-[11px] font-semibold text-slate-300 block">
                Local POS Server Host / IP (for customer phones on restaurant Wi-Fi)
              </label>
              {detectedIps.length > 0 && (
                <div className="flex items-center gap-1.5 flex-wrap pb-1">
                  <span className="text-[10px] text-slate-400">Detected:</span>
                  {detectedIps.map((ip) => (
                    <button
                      key={ip}
                      type="button"
                      onClick={() => setCustomHost(`http://${ip}:4444`)}
                      className="text-[10px] bg-slate-800 hover:bg-slate-700 text-indigo-300 px-2 py-0.5 rounded-md font-mono border border-slate-700"
                    >
                      {ip}:4444
                    </button>
                  ))}
                </div>
              )}
              <div className="flex gap-2">
                <input
                  type="text"
                  placeholder="e.g. http://192.168.1.50:4444"
                  value={customHost}
                  onChange={(e) => setCustomHost(e.target.value)}
                  className="flex-1 bg-slate-900 border border-slate-700 rounded-xl px-3 py-1.5 text-xs text-white focus:outline-none focus:border-indigo-400 font-mono"
                />
                <button
                  type="button"
                  onClick={handleSaveHost}
                  className="bg-indigo-600 hover:bg-indigo-700 text-white text-xs font-bold px-3 py-1.5 rounded-xl transition"
                >
                  Save
                </button>
              </div>
              <p className="text-[10px] text-slate-500">
                Current URL: <span className="font-mono text-slate-400">{customerOrderUrl}</span>
              </p>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
