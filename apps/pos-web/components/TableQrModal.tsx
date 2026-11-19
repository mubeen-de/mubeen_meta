import React, { useState } from "react";

interface TableQrModalProps {
  isOpen: boolean;
  onClose: () => void;
  tables: Array<{ id: string; tableNumber: string; section?: string | null }>;
  selectedTableId?: string | null;
}

export default function TableQrModal({
  isOpen,
  onClose,
  tables,
  selectedTableId: initialTableId,
}: TableQrModalProps) {
  const [selectedId, setSelectedId] = useState(initialTableId || tables[0]?.id || "");
  const [customHost, setCustomHost] = useState("");
  const [detectedIps, setDetectedIps] = useState<string[]>([]);
  const [copied, setCopied] = useState(false);

  React.useEffect(() => {
    if (initialTableId && tables.some((t) => t.id === initialTableId)) {
      setSelectedId(initialTableId);
    } else if (tables.length > 0 && (!selectedId || !tables.some((t) => t.id === selectedId))) {
      setSelectedId(tables[0].id);
    }
  }, [initialTableId, tables, selectedId]);

  React.useEffect(() => {
    if (typeof window !== "undefined") {
      const saved = localStorage.getItem("kapmeta_customer_qr_host");
      if (saved) setCustomHost(saved);

      const apiHost = `${window.location.protocol}//${window.location.hostname}:4001`;
      fetch(`${apiHost}/system/network-ip`)
        .then((res) => res.json())
        .then((data) => {
          if (data?.ips && Array.isArray(data.ips)) {
            setDetectedIps(data.ips);
            if ((!saved || saved.includes("localhost") || saved.includes("127.0.0.1")) && data.primaryIp) {
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

  const currentTable = tables.find((t) => t.id === selectedId) || tables[0];
  const origin = customHost.trim()
    ? customHost.trim().replace(/\/$/, "")
    : typeof window !== "undefined"
    ? window.location.origin
    : "http://localhost:4444";

  const isLocalhost = origin.includes("localhost") || origin.includes("127.0.0.1");
  const qrUrl = `${origin}/order/${encodeURIComponent(currentTable?.id || "")}`;
  const qrImageSrc = `https://api.qrserver.com/v1/create-qr-code/?size=240x240&data=${encodeURIComponent(qrUrl)}&margin=10`;

  const handleCopyLink = () => {
    navigator.clipboard.writeText(qrUrl);
    setCopied(true);
    setTimeout(() => setCopied(false), 3000);
  };

  const handlePrint = () => {
    const printWindow = window.open("", "_blank");
    if (!printWindow) return;
    printWindow.document.write(`
      <html>
        <head>
          <title>Table ${currentTable?.tableNumber} QR Code</title>
          <style>
            body { font-family: sans-serif; display: flex; flex-direction: column; align-items: center; justify-content: center; height: 100vh; margin: 0; }
            .card { border: 2px solid #000; border-radius: 16px; padding: 32px; text-align: center; max-width: 320px; }
            h1 { font-size: 28px; margin: 0 0 8px 0; }
            p { font-size: 14px; color: #555; margin: 0 0 20px 0; }
            img { width: 220px; height: 220px; }
            .footer { font-size: 12px; font-weight: bold; margin-top: 16px; letter-spacing: 1px; color: #333; }
          </style>
        </head>
        <body onload="window.print(); window.close();">
          <div class="card">
            <h1>Table ${currentTable?.tableNumber}</h1>
            <p>Scan to view digital menu & place your order directly</p>
            <img src="${qrImageSrc}" alt="Table QR" />
            <div class="footer">POWERED BY KAPMETA POS</div>
          </div>
        </body>
      </html>
    `);
    printWindow.document.close();
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm p-4">
      <div className="bg-slate-900 border border-emerald-500/30 rounded-2xl shadow-2xl w-full max-w-md overflow-hidden text-slate-100 animate-in fade-in zoom-in-95 duration-150">
        {/* Header */}
        <div className="px-6 py-4 bg-gradient-to-r from-emerald-950/40 via-slate-900 to-slate-900 border-b border-emerald-500/20 flex items-center justify-between">
          <div className="flex items-center space-x-3">
            <span className="flex h-9 w-9 items-center justify-center rounded-xl bg-emerald-500/10 text-emerald-400 border border-emerald-500/30 text-lg">
              📱
            </span>
            <div>
              <h3 className="text-lg font-bold text-emerald-200">Customer Self-Order QR</h3>
              <p className="text-xs text-slate-400">Direct patron digital ordering from table</p>
            </div>
          </div>
          <button
            type="button"
            onClick={onClose}
            className="text-slate-400 hover:text-white text-xl p-1 rounded-lg hover:bg-slate-800 transition"
          >
            ✕
          </button>
        </div>

        {/* Content */}
        <div className="p-6 flex flex-col items-center text-center space-y-4">
          <div className="w-full">
            <label className="block text-xs font-semibold uppercase tracking-wider text-slate-300 mb-1.5 text-left">
              Select Table
            </label>
            <select
              value={selectedId}
              onChange={(e) => setSelectedId(e.target.value)}
              className="w-full bg-slate-800/80 border border-slate-700 rounded-xl px-3.5 py-2.5 text-sm font-medium text-white focus:outline-none focus:border-emerald-400"
            >
              {tables.map((t) => (
                <option key={t.id} value={t.id}>
                  Table {t.tableNumber} ({t.section || "General"})
                </option>
              ))}
            </select>
          </div>

          {/* Localhost Prevention Warning */}
          {isLocalhost && (
            <div className="w-full bg-amber-950/90 border border-amber-500/50 rounded-2xl p-3 text-left flex items-start gap-2.5 shadow-lg">
              <span className="text-xl">⚠️</span>
              <div className="flex-1 min-w-0">
                <p className="text-xs font-bold text-amber-400">QR uses &quot;localhost&quot; (Phones will fail)</p>
                <p className="text-[11px] text-amber-200/90 mt-0.5">
                  Phones scanning via Google Lens cannot reach localhost. Use your computer Wi-Fi IP:
                </p>
                {detectedIps.length > 0 && (
                  <div className="flex gap-2 flex-wrap mt-2">
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
                        }}
                        className="bg-amber-400 hover:bg-amber-300 text-slate-950 text-xs font-mono font-bold px-2.5 py-1 rounded-lg"
                      >
                        📶 http://{ip}:4444
                      </button>
                    ))}
                  </div>
                )}
              </div>
            </div>
          )}

          {/* QR Code Container */}
          <div className="p-4 bg-white rounded-2xl shadow-inner border border-slate-200">
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img
              src={qrImageSrc}
              alt={`Table ${currentTable?.tableNumber} QR`}
              className="w-48 h-48 rounded-lg"
            />
            <div className="text-slate-800 font-extrabold text-sm mt-2 tracking-wide uppercase">
              Table {currentTable?.tableNumber}
            </div>
          </div>

          <p className="text-xs text-slate-400 max-w-xs">
            Guests can scan this QR code with their phone camera to browse the live menu and send KOTs.
          </p>

          {/* Action Buttons */}
          <div className="grid grid-cols-2 gap-3 w-full pt-2">
            <button
              type="button"
              onClick={handleCopyLink}
              className="px-4 py-2 text-xs font-semibold rounded-xl bg-slate-800 hover:bg-slate-700 border border-slate-700 text-slate-200 transition"
            >
              {copied ? "✓ Copied!" : "📋 Copy Web Link"}
            </button>
            <button
              type="button"
              onClick={handlePrint}
              className="px-4 py-2 text-xs font-bold rounded-xl bg-gradient-to-r from-emerald-500 to-emerald-600 hover:from-emerald-400 hover:to-emerald-500 text-slate-950 transition shadow-lg shadow-emerald-500/20"
            >
              🖨️ Print Table Stand
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
