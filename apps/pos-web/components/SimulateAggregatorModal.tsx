import React, { useEffect, useState, useMemo } from "react";
import { getApiBase, authedFetch } from "../lib/auth";

export interface SimulateAggregatorModalProps {
  isOpen: boolean;
  initialChannel?: "SWIGGY" | "ZOMATO";
  outletId?: string;
  onClose: () => void;
  onOrderCreated?: (orderData: any) => void;
}

interface SimulatedItem {
  id?: string;
  name: string;
  priceMinor: number;
  quantity: number;
}

const DEFAULT_PRESET_ITEMS: SimulatedItem[] = [
  { name: "Butter Chicken", priceMinor: 35000, quantity: 1 },
  { name: "Paneer Butter Masala", priceMinor: 28000, quantity: 1 },
  { name: "Butter Naan", priceMinor: 6000, quantity: 2 },
  { name: "Chicken Dum Biryani", priceMinor: 32000, quantity: 0 },
  { name: "Dal Makhani", priceMinor: 24000, quantity: 0 },
  { name: "Gulab Jamun (2 Pcs)", priceMinor: 12000, quantity: 0 },
];

export default function SimulateAggregatorModal({
  isOpen,
  initialChannel = "SWIGGY",
  outletId,
  onClose,
  onOrderCreated,
}: SimulateAggregatorModalProps) {
  const [channel, setChannel] = useState<"SWIGGY" | "ZOMATO">(initialChannel);
  const [customerName, setCustomerName] = useState("Rahul Sharma");
  const [customerPhone, setCustomerPhone] = useState("9876543210");
  const [deliveryAddress, setDeliveryAddress] = useState("Flat 402, Green Glen Heights, Bengaluru");
  const [riderName, setRiderName] = useState("Amit Kumar (Delivery Partner)");
  const [riderPhone, setRiderPhone] = useState("9812345678");
  const [otp, setOtp] = useState(() => String(Math.floor(1000 + Math.random() * 9000)));

  const [items, setItems] = useState<SimulatedItem[]>(DEFAULT_PRESET_ITEMS);
  const [loadingMenu, setLoadingMenu] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [successResult, setSuccessResult] = useState<{
    orderId: string;
    orderNumber: string;
    channel: string;
  } | null>(null);

  // Sync initial channel if prop changes
  useEffect(() => {
    if (initialChannel) {
      setChannel(initialChannel);
      updateRiderForChannel(initialChannel);
    }
  }, [initialChannel]);

  const updateRiderForChannel = (ch: "SWIGGY" | "ZOMATO") => {
    if (ch === "SWIGGY") {
      setRiderName("Amit Kumar (Swiggy Delivery Exec)");
      setCustomerName((prev) => (prev === "Priya Patel" ? "Rahul Sharma" : prev));
    } else {
      setRiderName("Suresh Verma (Zomato Valet)");
      setCustomerName((prev) => (prev === "Rahul Sharma" ? "Priya Patel" : prev));
    }
  };

  const handleChannelSwitch = (nextChannel: "SWIGGY" | "ZOMATO") => {
    setChannel(nextChannel);
    updateRiderForChannel(nextChannel);
    setOtp(String(Math.floor(1000 + Math.random() * 9000)));
  };

  // Optionally load real active menu items from the database
  useEffect(() => {
    if (!isOpen) return;
    let cancelled = false;

    async function loadCatalog() {
      try {
        setLoadingMenu(true);
        const res = await authedFetch("/menu/items");
        if (res.ok && !cancelled) {
          const menuData = await res.json();
          if (Array.isArray(menuData) && menuData.length > 0) {
            const mapped: SimulatedItem[] = menuData.slice(0, 8).map((m: any, idx: number) => ({
              id: m.id,
              name: m.name,
              priceMinor: Number(m.priceMinor || 25000),
              quantity: idx < 2 ? 1 : 0,
            }));
            setItems(mapped);
          }
        }
      } catch {
        // Fallback to presets on network/auth error
      } finally {
        if (!cancelled) setLoadingMenu(false);
      }
    }

    loadCatalog();
    return () => {
      cancelled = true;
    };
  }, [isOpen]);

  const changeQty = (idx: number, delta: number) => {
    setItems((prev) =>
      prev.map((it, i) => {
        if (i !== idx) return it;
        const nextQty = Math.max(0, it.quantity + delta);
        return { ...it, quantity: nextQty };
      })
    );
  };

  const selectedLines = useMemo(() => items.filter((it) => it.quantity > 0), [items]);

  const subtotalMinor = useMemo(
    () => selectedLines.reduce((acc, it) => acc + it.priceMinor * it.quantity, 0),
    [selectedLines]
  );
  const taxMinor = Math.round(subtotalMinor * 0.05);
  const grandTotalMinor = subtotalMinor + taxMinor;

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);

    if (selectedLines.length === 0) {
      setError("Please select at least 1 item to simulate a customer order.");
      return;
    }
    if (!customerName.trim() || !customerPhone.trim()) {
      setError("Customer name and phone are required.");
      return;
    }

    setSubmitting(true);
    try {
      const externalOrderId = `${channel}-${Math.floor(100000 + Math.random() * 900000)}`;
      const payload: any = {
        channel,
        externalOrderId,
        externalEventId: `evt-${Date.now()}-${Math.random().toString(36).substring(2, 7)}`,
        customer: {
          name: customerName.trim(),
          phone: customerPhone.trim(),
          address: deliveryAddress.trim() || undefined,
        },
        items: selectedLines.map((line) => ({
          name: line.name,
          quantity: line.quantity,
          priceMinor: line.priceMinor,
        })),
        rider: {
          name: riderName.trim() || `${channel} Rider`,
          phone: riderPhone.trim() || "9800000000",
          otp: otp.trim() || "1234",
        },
        otp: otp.trim() || "1234",
      };

      if (outletId) {
        payload.outletId = outletId;
      }

      const apiBase = getApiBase();
      const endpoint = `${apiBase}/webhooks/${channel.toLowerCase()}`;

      const res = await fetch(endpoint, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      });

      const data = await res.json();
      if (!res.ok) {
        throw new Error(data.error || `HTTP error ${res.status}`);
      }

      setSuccessResult({
        orderId: data.orderId,
        orderNumber: data.orderNumber || `${channel}-${externalOrderId}`,
        channel,
      });

      if (onOrderCreated) {
        onOrderCreated(data);
      }
    } catch (err: any) {
      console.error("Simulation error:", err);
      setError(err.message || "Failed to trigger aggregator webhook order.");
    } finally {
      setSubmitting(false);
    }
  };

  const handleResetForNew = () => {
    setSuccessResult(null);
    setError(null);
    setOtp(String(Math.floor(1000 + Math.random() * 9000)));
  };

  if (!isOpen) return null;

  const isSwiggy = channel === "SWIGGY";
  const brandColor = isSwiggy ? "#fc8019" : "#e23744";
  const brandBg = isSwiggy ? "rgba(252, 128, 25, 0.1)" : "rgba(226, 55, 68, 0.1)";

  return (
    <div className="sim-backdrop" id="sim-aggregator-backdrop" onClick={onClose}>
      <div
        className="sim-modal-container"
        id="sim-aggregator-modal"
        onClick={(e) => e.stopPropagation()}
        role="dialog"
        aria-modal="true"
        aria-labelledby="sim-modal-title"
      >
        {/* Modal Header */}
        <div className="sim-modal-header" style={{ borderBottomColor: brandBg }}>
          <div className="sim-title-group">
            <span className="sim-brand-badge" style={{ background: brandColor }}>
              {isSwiggy ? "🧡 SWIGGY" : "❤️ ZOMATO"}
            </span>
            <h2 id="sim-modal-title" className="sim-title">
              Simulate Customer Order
            </h2>
          </div>
          <button
            type="button"
            className="sim-close-btn"
            id="sim-modal-close-btn"
            onClick={onClose}
            aria-label="Close"
          >
            ✕
          </button>
        </div>

        {/* Success Confirmation View */}
        {successResult ? (
          <div className="sim-success-view">
            <div className="sim-success-icon" style={{ background: brandBg, color: brandColor }}>
              ✓
            </div>
            <h3 className="sim-success-title">Order Placed Successfully!</h3>
            <p className="sim-success-subtitle">
              The {successResult.channel} webhook was ingested and fired into the system.
            </p>

            <div className="sim-success-card">
              <div className="sim-success-row">
                <span className="sim-success-label">Order Number:</span>
                <span className="sim-success-value highlight">{successResult.orderNumber}</span>
              </div>
              <div className="sim-success-row">
                <span className="sim-success-label">Customer:</span>
                <span className="sim-success-value">{customerName} ({customerPhone})</span>
              </div>
              <div className="sim-success-row">
                <span className="sim-success-label">Delivery OTP:</span>
                <span className="sim-success-value badge">{otp}</span>
              </div>
              <div className="sim-success-row">
                <span className="sim-success-label">Rider Assigned:</span>
                <span className="sim-success-value">{riderName}</span>
              </div>
              <div className="sim-success-row">
                <span className="sim-success-label">Kitchen Status:</span>
                <span className="sim-success-value status-tag">Station KOTs Created</span>
              </div>
            </div>

            <div className="sim-success-actions">
              <button
                type="button"
                className="sim-btn-primary"
                id="sim-new-order-btn"
                style={{ background: brandColor }}
                onClick={handleResetForNew}
              >
                Place Another Order
              </button>
              <button
                type="button"
                className="sim-btn-secondary"
                id="sim-done-btn"
                onClick={onClose}
              >
                Done & View Online Orders
              </button>
            </div>
          </div>
        ) : (
          /* Main Order Simulation Form */
          <form onSubmit={handleSubmit} className="sim-form">
            {/* Channel Switcher */}
            <div className="sim-section">
              <label className="sim-label">Select Delivery Platform</label>
              <div className="sim-channel-toggle-group">
                <button
                  type="button"
                  id="sim-switch-swiggy"
                  className={`sim-channel-btn ${isSwiggy ? "is-active" : ""}`}
                  style={{
                    borderColor: isSwiggy ? "#fc8019" : "var(--border, #e2e8f0)",
                    background: isSwiggy ? "rgba(252, 128, 25, 0.08)" : "var(--bg-card, #fff)",
                    color: isSwiggy ? "#fc8019" : "var(--text-secondary, #64748b)",
                  }}
                  onClick={() => handleChannelSwitch("SWIGGY")}
                >
                  <span className="sim-channel-icon">🧡</span>
                  <div>
                    <strong style={{ display: "block" }}>Swiggy</strong>
                    <small>Consumer App Webhook</small>
                  </div>
                </button>
                <button
                  type="button"
                  id="sim-switch-zomato"
                  className={`sim-channel-btn ${!isSwiggy ? "is-active" : ""}`}
                  style={{
                    borderColor: !isSwiggy ? "#e23744" : "var(--border, #e2e8f0)",
                    background: !isSwiggy ? "rgba(226, 55, 68, 0.08)" : "var(--bg-card, #fff)",
                    color: !isSwiggy ? "#e23744" : "var(--text-secondary, #64748b)",
                  }}
                  onClick={() => handleChannelSwitch("ZOMATO")}
                >
                  <span className="sim-channel-icon">❤️</span>
                  <div>
                    <strong style={{ display: "block" }}>Zomato</strong>
                    <small>Live Webhook API</small>
                  </div>
                </button>
              </div>
            </div>

            {/* Customer Details */}
            <div className="sim-section">
              <label className="sim-label">Customer Profile (Ordering)</label>
              <div className="sim-grid-2">
                <div>
                  <label className="sim-sublabel">Full Name</label>
                  <input
                    type="text"
                    id="sim-cust-name"
                    required
                    className="sim-input"
                    value={customerName}
                    onChange={(e) => setCustomerName(e.target.value)}
                    placeholder="e.g. Rahul Sharma"
                  />
                </div>
                <div>
                  <label className="sim-sublabel">Mobile Number</label>
                  <input
                    type="tel"
                    id="sim-cust-phone"
                    required
                    className="sim-input"
                    value={customerPhone}
                    onChange={(e) => setCustomerPhone(e.target.value)}
                    placeholder="e.g. 9876543210"
                  />
                </div>
              </div>
              <div style={{ marginTop: 8 }}>
                <label className="sim-sublabel">Delivery Address</label>
                <input
                  type="text"
                  id="sim-cust-address"
                  className="sim-input"
                  value={deliveryAddress}
                  onChange={(e) => setDeliveryAddress(e.target.value)}
                  placeholder="Street / Apt / City"
                />
              </div>
            </div>

            {/* Menu Items Basket */}
            <div className="sim-section">
              <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 6 }}>
                <label className="sim-label" style={{ margin: 0 }}>
                  Order Basket ({selectedLines.length} items selected)
                </label>
                {loadingMenu && <span style={{ fontSize: "0.72rem", color: "var(--text-muted, #94a3b8)" }}>Loading menu...</span>}
              </div>

              <div className="sim-items-list" id="sim-items-container">
                {items.map((it, idx) => (
                  <div
                    key={it.name + idx}
                    className={`sim-item-row ${it.quantity > 0 ? "is-selected" : ""}`}
                  >
                    <div className="sim-item-info">
                      <span className="sim-item-name">{it.name}</span>
                      <span className="sim-item-price">₹{(it.priceMinor / 100).toFixed(0)}</span>
                    </div>
                    <div className="sim-item-stepper">
                      <button
                        type="button"
                        className="sim-step-btn"
                        id={`sim-item-dec-${idx}`}
                        onClick={() => changeQty(idx, -1)}
                        disabled={it.quantity === 0}
                      >
                        −
                      </button>
                      <span className="sim-item-qty">{it.quantity}</span>
                      <button
                        type="button"
                        className="sim-step-btn add"
                        id={`sim-item-inc-${idx}`}
                        onClick={() => changeQty(idx, 1)}
                      >
                        +
                      </button>
                    </div>
                  </div>
                ))}
              </div>
            </div>

            {/* Rider & OTP Section */}
            <div className="sim-section sim-rider-section">
              <label className="sim-label">Assigned Delivery Partner & OTP</label>
              <div className="sim-grid-3">
                <div style={{ gridColumn: "span 2" }}>
                  <label className="sim-sublabel">Delivery Rider Name</label>
                  <input
                    type="text"
                    id="sim-rider-name"
                    className="sim-input"
                    value={riderName}
                    onChange={(e) => setRiderName(e.target.value)}
                  />
                </div>
                <div>
                  <label className="sim-sublabel">Pickup/Delivery OTP</label>
                  <input
                    type="text"
                    id="sim-otp"
                    maxLength={6}
                    className="sim-input sim-otp-input"
                    value={otp}
                    onChange={(e) => setOtp(e.target.value)}
                  />
                </div>
              </div>
            </div>

            {/* Price Summary */}
            <div className="sim-summary-box">
              <div className="sim-sum-row">
                <span>Items Subtotal:</span>
                <span>₹{(subtotalMinor / 100).toFixed(2)}</span>
              </div>
              <div className="sim-sum-row">
                <span>GST / Taxes (5%):</span>
                <span>₹{(taxMinor / 100).toFixed(2)}</span>
              </div>
              <div className="sim-sum-row total">
                <span>Grand Total:</span>
                <span className="sim-sum-highlight">₹{(grandTotalMinor / 100).toFixed(2)}</span>
              </div>
            </div>

            {error && (
              <div className="sim-error-alert" role="alert">
                ⚠️ {error}
              </div>
            )}

            {/* Submit Action */}
            <div className="sim-actions">
              <button
                type="button"
                className="sim-btn-cancel"
                onClick={onClose}
                disabled={submitting}
              >
                Cancel
              </button>
              <button
                type="submit"
                id="sim-submit-order-btn"
                className="sim-btn-submit"
                style={{ background: brandColor }}
                disabled={submitting || selectedLines.length === 0}
              >
                {submitting ? (
                  <span>Sending Webhook...</span>
                ) : (
                  <span>🚀 Place {channel} Customer Order</span>
                )}
              </button>
            </div>
          </form>
        )}
      </div>

      <style jsx>{`
        .sim-backdrop {
          position: fixed;
          inset: 0;
          z-index: 9999;
          background: rgba(15, 23, 42, 0.65);
          backdrop-filter: blur(4px);
          display: flex;
          align-items: center;
          justify-content: center;
          padding: 16px;
          animation: fadeIn 0.15s ease-out;
        }
        @keyframes fadeIn {
          from { opacity: 0; }
          to { opacity: 1; }
        }
        .sim-modal-container {
          background: var(--bg-card, #111c38);
          border: 1px solid var(--border-strong, #334155);
          border-radius: 16px;
          width: 100%;
          max-width: 580px;
          max-height: 92vh;
          display: flex;
          flex-direction: column;
          box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.5), 0 10px 10px -5px rgba(0, 0, 0, 0.2);
          overflow: hidden;
          animation: slideUp 0.2s cubic-bezier(0.16, 1, 0.3, 1);
        }
        @keyframes slideUp {
          from { transform: translateY(16px) scale(0.98); opacity: 0; }
          to { transform: translateY(0) scale(1); opacity: 1; }
        }
        .sim-modal-header {
          display: flex;
          align-items: center;
          justify-content: space-between;
          padding: 16px 20px;
          border-bottom: 2px solid transparent;
        }
        .sim-title-group {
          display: flex;
          align-items: center;
          gap: 10px;
        }
        .sim-brand-badge {
          color: #fff;
          font-size: 0.72rem;
          font-weight: 800;
          letter-spacing: 0.05em;
          padding: 3px 8px;
          border-radius: 6px;
        }
        .sim-title {
          font-size: 1.15rem;
          font-weight: 800;
          margin: 0;
          color: var(--text-primary, #f8fafc);
        }
        .sim-close-btn {
          background: transparent;
          border: none;
          font-size: 1.1rem;
          color: var(--text-muted, #94a3b8);
          cursor: pointer;
          width: 32px;
          height: 32px;
          display: flex;
          align-items: center;
          justify-content: center;
          border-radius: 50%;
          transition: background 0.15s ease, color 0.15s ease;
        }
        .sim-close-btn:hover {
          background: var(--bg-elevated, #1e293b);
          color: var(--text-primary, #f8fafc);
        }
        .sim-form {
          padding: 18px 20px;
          overflow-y: auto;
          display: flex;
          flex-direction: column;
          gap: 16px;
        }
        .sim-section {
          display: flex;
          flex-direction: column;
          gap: 6px;
        }
        .sim-label {
          font-size: 0.8rem;
          font-weight: 700;
          color: var(--text-secondary, #94a3b8);
          text-transform: uppercase;
          letter-spacing: 0.03em;
        }
        .sim-sublabel {
          font-size: 0.73rem;
          font-weight: 600;
          color: var(--text-muted, #64748b);
          margin-bottom: 2px;
          display: block;
        }
        .sim-channel-toggle-group {
          display: grid;
          grid-template-columns: 1fr 1fr;
          gap: 10px;
        }
        .sim-channel-btn {
          border: 2px solid;
          border-radius: 10px;
          padding: 10px 12px;
          display: flex;
          align-items: center;
          gap: 10px;
          text-align: left;
          cursor: pointer;
          transition: all 0.15s ease;
        }
        .sim-channel-btn.is-active {
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.25);
        }
        .sim-channel-icon {
          font-size: 1.5rem;
        }
        .sim-channel-btn small {
          font-size: 0.68rem;
          opacity: 0.8;
          display: block;
        }
        .sim-grid-2 {
          display: grid;
          grid-template-columns: 1fr 1fr;
          gap: 10px;
        }
        .sim-grid-3 {
          display: grid;
          grid-template-columns: 2fr 1fr;
          gap: 10px;
        }
        .sim-input {
          width: 100%;
          border: 1px solid var(--border-strong, #334155);
          border-radius: 8px;
          padding: 7px 10px;
          font-size: 0.82rem;
          color: var(--text-primary, #f8fafc);
          background: var(--bg-subtle, #070d1e);
          outline: none;
          transition: border-color 0.15s ease;
        }
        .sim-input:focus {
          border-color: var(--accent, #3b82f6);
        }
        .sim-otp-input {
          font-weight: 800;
          letter-spacing: 0.15em;
          text-align: center;
          font-family: monospace;
          color: #34d399;
          background: rgba(16, 185, 129, 0.15);
          border-color: #059669;
        }
        .sim-items-list {
          max-height: 170px;
          overflow-y: auto;
          border: 1px solid var(--border, #1e293b);
          border-radius: 10px;
          background: var(--bg-subtle, #070d1e);
          padding: 6px;
          display: flex;
          flex-direction: column;
          gap: 4px;
        }
        .sim-item-row {
          display: flex;
          align-items: center;
          justify-content: space-between;
          padding: 6px 10px;
          background: var(--bg-elevated, #1e293b);
          border: 1px solid var(--border, #1e293b);
          border-radius: 8px;
          transition: background 0.1s ease;
        }
        .sim-item-row.is-selected {
          border-color: #3b82f6;
          background: rgba(37, 99, 235, 0.18);
        }
        .sim-item-info {
          display: flex;
          flex-direction: column;
        }
        .sim-item-name {
          font-size: 0.82rem;
          font-weight: 700;
          color: var(--text-primary, #f8fafc);
        }
        .sim-item-price {
          font-size: 0.72rem;
          color: var(--text-muted, #94a3b8);
        }
        .sim-item-stepper {
          display: flex;
          align-items: center;
          gap: 8px;
        }
        .sim-step-btn {
          width: 26px;
          height: 26px;
          border-radius: 6px;
          border: 1px solid var(--border-strong, #334155);
          background: var(--bg-subtle, #070d1e);
          font-size: 0.88rem;
          font-weight: 700;
          color: var(--text-primary, #f8fafc);
          cursor: pointer;
          display: flex;
          align-items: center;
          justify-content: center;
          transition: all 0.1s ease;
        }
        .sim-step-btn:hover:not(:disabled) {
          background: var(--bg-elevated, #1e293b);
        }
        .sim-step-btn.add {
          background: var(--btn-primary-bg, #2563eb);
          color: #fff;
          border-color: var(--btn-primary-border, #3b82f6);
        }
        .sim-step-btn.add:hover {
          background: var(--btn-primary-hover, #1d4ed8);
        }
        .sim-step-btn:disabled {
          opacity: 0.4;
          cursor: not-allowed;
        }
        .sim-item-qty {
          font-size: 0.82rem;
          font-weight: 800;
          min-width: 16px;
          text-align: center;
        }
        .sim-rider-section {
          background: var(--bg-elevated, #1e293b);
          padding: 10px 12px;
          border-radius: 10px;
          border: 1px dashed var(--border-strong, #334155);
        }
        .sim-summary-box {
          background: var(--bg-subtle, #070d1e);
          border-radius: 10px;
          padding: 10px 14px;
          display: flex;
          flex-direction: column;
          gap: 4px;
        }
        .sim-sum-row {
          display: flex;
          justify-content: space-between;
          font-size: 0.78rem;
          color: var(--text-secondary, #94a3b8);
        }
        .sim-sum-row.total {
          font-size: 0.95rem;
          font-weight: 800;
          color: var(--text-primary, #f8fafc);
          border-top: 1px solid var(--border-strong, #334155);
          padding-top: 6px;
          margin-top: 4px;
        }
        .sim-sum-highlight {
          color: #34d399;
        }
        .sim-error-alert {
          background: rgba(220, 38, 38, 0.15);
          border: 1px solid #ef4444;
          color: #f87171;
          padding: 8px 12px;
          border-radius: 8px;
          font-size: 0.78rem;
          font-weight: 600;
        }
        .sim-actions {
          display: flex;
          gap: 10px;
          margin-top: 4px;
        }
        .sim-btn-cancel {
          flex: 1;
          padding: 10px 16px;
          border-radius: 10px;
          border: 1px solid var(--btn-cancel-border, #475569);
          background: var(--btn-cancel-bg, #334155);
          color: var(--btn-cancel-text, #cbd5e1);
          font-size: 0.82rem;
          font-weight: 700;
          cursor: pointer;
          transition: background 0.15s;
        }
        .sim-btn-cancel:hover {
          background: var(--btn-cancel-hover, #475569);
          color: #f8fafc;
        }
        .sim-btn-submit {
          flex: 2;
          padding: 10px 16px;
          border-radius: 10px;
          border: none;
          color: #fff;
          font-size: 0.88rem;
          font-weight: 800;
          cursor: pointer;
          display: flex;
          align-items: center;
          justify-content: center;
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
          transition: transform 0.1s ease, filter 0.1s ease;
        }
        .sim-btn-submit:hover:not(:disabled) {
          transform: translateY(-1px);
          filter: brightness(1.08);
        }
        .sim-btn-submit:disabled {
          opacity: 0.6;
          cursor: not-allowed;
        }
        .sim-success-view {
          padding: 32px 24px;
          display: flex;
          flex-direction: column;
          align-items: center;
          text-align: center;
        }
        .sim-success-icon {
          width: 54px;
          height: 54px;
          border-radius: 50%;
          display: flex;
          align-items: center;
          justify-content: center;
          font-size: 1.75rem;
          font-weight: 900;
          margin-bottom: 12px;
        }
        .sim-success-title {
          font-size: 1.25rem;
          font-weight: 800;
          color: var(--text-primary, #f8fafc);
          margin: 0 0 4px 0;
        }
        .sim-success-subtitle {
          font-size: 0.82rem;
          color: var(--text-muted, #94a3b8);
          margin: 0 0 18px 0;
        }
        .sim-success-card {
          width: 100%;
          background: var(--bg-subtle, #070d1e);
          border: 1px solid var(--border, #1e293b);
          border-radius: 12px;
          padding: 14px 16px;
          display: flex;
          flex-direction: column;
          gap: 8px;
          margin-bottom: 20px;
        }
        .sim-success-row {
          display: flex;
          justify-content: space-between;
          align-items: center;
          font-size: 0.8rem;
        }
        .sim-success-label {
          color: var(--text-muted, #94a3b8);
        }
        .sim-success-value {
          font-weight: 700;
          color: var(--text-primary, #f8fafc);
        }
        .sim-success-value.highlight {
          color: #38bdf8;
          font-family: monospace;
          font-size: 0.88rem;
        }
        .sim-success-value.badge {
          background: rgba(16, 185, 129, 0.2);
          color: #34d399;
          padding: 2px 8px;
          border-radius: 4px;
          font-family: monospace;
          font-weight: 800;
        }
        .sim-success-value.status-tag {
          background: rgba(56, 189, 248, 0.2);
          color: #38bdf8;
          padding: 2px 8px;
          border-radius: 4px;
          font-size: 0.75rem;
        }
        .sim-success-actions {
          display: flex;
          flex-direction: column;
          gap: 8px;
          width: 100%;
        }
        .sim-btn-primary {
          width: 100%;
          padding: 10px 16px;
          border-radius: 10px;
          border: none;
          background: var(--btn-primary-bg, #2563eb);
          color: var(--btn-primary-text, #ffffff);
          font-size: 0.88rem;
          font-weight: 800;
          cursor: pointer;
          transition: background 0.15s;
        }
        .sim-btn-primary:hover {
          background: var(--btn-primary-hover, #1d4ed8);
        }
        .sim-btn-secondary {
          width: 100%;
          padding: 10px 16px;
          border-radius: 10px;
          border: 1px solid var(--btn-secondary-border, #475569);
          background: var(--btn-secondary-bg, #334155);
          color: var(--btn-secondary-text, #f8fafc);
          font-size: 0.82rem;
          font-weight: 700;
          cursor: pointer;
          transition: background 0.15s;
        }
        .sim-btn-secondary:hover {
          background: var(--btn-secondary-hover, #475569);
        }
      `}</style>
    </div>
  );
}
