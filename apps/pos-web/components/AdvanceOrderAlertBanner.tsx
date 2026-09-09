import React, { useState, useEffect, useCallback, useRef } from "react";
import Link from "next/link";
import { authedFetch } from "../lib/auth";
import { posAudio } from "../lib/posAudio";
import { useKapmetaSocket } from "../lib/useKapmetaSocket";

export interface DueAdvanceOrder {
  id: string;
  orderNumber: string;
  orderType: string;
  diningTableId?: string | null;
  diningTable?: { id: string; tableNumber: string } | null;
  scheduledFireAt?: string | null;
  promisedAt?: string | null;
  depositMinor?: string | null;
  grandTotal?: string | null;
  customerName?: string | null;
  customerPhone?: string | null;
  minutesUntilDue: number;
  isOverdue: boolean;
  orderItems: Array<{
    id: string;
    quantity: number;
    menuItem?: { name: string } | null;
  }>;
}

export default function AdvanceOrderAlertBanner() {
  const [dueOrders, setDueOrders] = useState<DueAdvanceOrder[]>([]);
  const [currentIndex, setCurrentIndex] = useState(0);
  const [snoozedMap, setSnoozedMap] = useState<Record<string, number>>({});
  const [firingId, setFiringId] = useState<string | null>(null);
  const [toastMessage, setToastMessage] = useState<string | null>(null);
  const alertedIdsRef = useRef<Set<string>>(new Set());

  // Fetch due advance orders from API
  const fetchDueOrders = useCallback(async () => {
    try {
      const res = await authedFetch("/orders/advance/due?leadMinutes=30");
      if (!res.ok) return;
      const data: DueAdvanceOrder[] = await res.json();
      if (Array.isArray(data)) {
        const now = Date.now();
        // Filter out snoozed orders that haven't expired
        const active = data.filter((o) => {
          const snoozeUntil = snoozedMap[o.id];
          return !snoozeUntil || now >= snoozeUntil;
        });

        // Check if there are newly due orders that haven't triggered audio alert
        let hasNewAlert = false;
        active.forEach((ord) => {
          if (!alertedIdsRef.current.has(ord.id)) {
            hasNewAlert = true;
            alertedIdsRef.current.add(ord.id);
          }
        });

        if (hasNewAlert && active.length > 0) {
          posAudio.playAdvanceOrderAlert();
        }

        setDueOrders(active);
        if (currentIndex >= active.length) {
          setCurrentIndex(0);
        }
      }
    } catch {
      // Quietly ignore network failures in background polling
    }
  }, [snoozedMap, currentIndex]);

  // Initial load and periodic polling every 20 seconds
  useEffect(() => {
    fetchDueOrders();
    const interval = setInterval(fetchDueOrders, 20000);
    return () => clearInterval(interval);
  }, [fetchDueOrders]);

  // Real-time WebSocket synchronization
  useKapmetaSocket(
    (payload) => {
      if (
        payload.topic === "advance_order.created" ||
        payload.topic === "advance_order.fired" ||
        payload.topic === "advance_order.due" ||
        payload.topic === "order.updated"
      ) {
        fetchDueOrders();
      }
    },
    true,
    "AdvanceOrderAlertBanner"
  );

  // 1-Click Fire to Kitchen KDS
  const handleFireToKitchen = async (order: DueAdvanceOrder) => {
    if (firingId) return;
    setFiringId(order.id);
    try {
      const res = await authedFetch(`/orders/${order.id}/fire-advance`, {
        method: "POST",
      });
      if (!res.ok) {
        const err = await res.json().catch(() => ({}));
        throw new Error(err.error || "Failed to fire advance order");
      }

      posAudio.playKotDispatched();
      showToast(`🔥 Order #${order.orderNumber} sent to Kitchen KDS!`);

      // Optimistically remove from due queue
      setDueOrders((prev) => prev.filter((o) => o.id !== order.id));
      alertedIdsRef.current.delete(order.id);
      fetchDueOrders();
    } catch (err: any) {
      alert(err.message || "Could not dispatch order to kitchen");
    } finally {
      setFiringId(null);
    }
  };

  // Snooze alert for 5 minutes
  const handleSnooze = (orderId: string) => {
    const unSnoozeAt = Date.now() + 5 * 60 * 1000;
    setSnoozedMap((prev) => ({ ...prev, [orderId]: unSnoozeAt }));
    setDueOrders((prev) => prev.filter((o) => o.id !== orderId));
    showToast("⏰ Alert snoozed for 5 minutes");
  };

  const showToast = (msg: string) => {
    setToastMessage(msg);
    setTimeout(() => setToastMessage(null), 3500);
  };

  if (dueOrders.length === 0 && !toastMessage) {
    return null;
  }

  const currentOrder = dueOrders[currentIndex] || dueOrders[0];

  return (
    <div className="advance-alert-wrapper">
      {toastMessage && (
        <div className="advance-toast-banner">
          <span>{toastMessage}</span>
        </div>
      )}

      {currentOrder && (
        <div
          className={`advance-alert-bar ${
            currentOrder.isOverdue ? "is-overdue" : "is-due-soon"
          }`}
        >
          {/* Left: Badge & Core Order Details */}
          <div className="alert-left-section">
            <div className="pulsing-badge">
              <span className="pulse-dot"></span>
              {currentOrder.isOverdue ? "🚨 OVERDUE" : "⏰ PREP DUE"}
            </div>

            <div className="order-identity">
              <span className="order-num">#{currentOrder.orderNumber}</span>
              <span className="order-type-chip">
                {currentOrder.orderType === "DELIVERY"
                  ? "🛵 Delivery"
                  : currentOrder.orderType === "PICKUP"
                  ? "🥡 Pickup"
                  : `🍽️ Table ${currentOrder.diningTable?.tableNumber || "Dine-In"}`}
              </span>
              {currentOrder.customerName && (
                <span className="customer-info">
                  👤 {currentOrder.customerName}
                </span>
              )}
            </div>

            <div className="countdown-pill">
              {currentOrder.isOverdue ? (
                <strong className="text-red">
                  Overdue by {Math.abs(currentOrder.minutesUntilDue)} mins
                </strong>
              ) : (
                <strong className="text-amber">
                  Prep due in {currentOrder.minutesUntilDue} mins
                </strong>
              )}
            </div>

            {/* Items Summary */}
            <div className="items-summary-strip" title="Order items">
              {currentOrder.orderItems
                .map((it) => `${it.quantity}x ${it.menuItem?.name || "Item"}`)
                .slice(0, 3)
                .join(", ")}
              {currentOrder.orderItems.length > 3 &&
                ` +${currentOrder.orderItems.length - 3} more`}
            </div>
          </div>

          {/* Right: Navigation (if multiple) & Action Buttons */}
          <div className="alert-right-section">
            {dueOrders.length > 1 && (
              <div className="orders-carousel-ctrl">
                <button
                  type="button"
                  className="carousel-arrow"
                  onClick={() =>
                    setCurrentIndex(
                      (prev) => (prev - 1 + dueOrders.length) % dueOrders.length
                    )
                  }
                  title="Previous Due Order"
                >
                  ◀
                </button>
                <span className="carousel-count">
                  {currentIndex + 1} of {dueOrders.length}
                </span>
                <button
                  type="button"
                  className="carousel-arrow"
                  onClick={() =>
                    setCurrentIndex((prev) => (prev + 1) % dueOrders.length)
                  }
                  title="Next Due Order"
                >
                  ▶
                </button>
              </div>
            )}

            <button
              type="button"
              className="btn-fire-kitchen"
              disabled={firingId === currentOrder.id}
              onClick={() => handleFireToKitchen(currentOrder)}
            >
              {firingId === currentOrder.id ? (
                <>⏳ Firing...</>
              ) : (
                <>🔥 Fire to Kitchen</>
              )}
            </button>

            <button
              type="button"
              className="btn-snooze"
              onClick={() => handleSnooze(currentOrder.id)}
              title="Snooze alert for 5 minutes"
            >
              ⏰ Snooze
            </button>

            <Link href="/orders?view=ADVANCE" className="btn-view-all" title="View all advance orders">
              📋 Registry
            </Link>
          </div>
        </div>
      )}

      <style jsx>{`
        .advance-alert-wrapper {
          width: 100%;
          position: sticky;
          top: 0;
          z-index: 999;
          font-family: inherit;
        }

        .advance-toast-banner {
          background: linear-gradient(90deg, #059669, #10b981);
          color: #ffffff;
          padding: 8px 16px;
          text-align: center;
          font-size: 13px;
          font-weight: 600;
          letter-spacing: 0.2px;
          box-shadow: 0 2px 8px rgba(5, 150, 105, 0.3);
          animation: slideDown 0.25s ease-out;
        }

        .advance-alert-bar {
          display: flex;
          align-items: center;
          justify-content: space-between;
          padding: 8px 16px;
          color: #ffffff;
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.25);
          animation: slideDown 0.3s cubic-bezier(0.16, 1, 0.3, 1);
          border-bottom: 2px solid rgba(255, 255, 255, 0.15);
        }

        .advance-alert-bar.is-due-soon {
          background: linear-gradient(90deg, #b45309 0%, #d97706 45%, #92400e 100%);
        }

        .advance-alert-bar.is-overdue {
          background: linear-gradient(90deg, #991b1b 0%, #dc2626 50%, #7f1d1d 100%);
        }

        .alert-left-section {
          display: flex;
          align-items: center;
          gap: 12px;
          flex-wrap: wrap;
        }

        .pulsing-badge {
          display: flex;
          align-items: center;
          gap: 6px;
          background: rgba(0, 0, 0, 0.35);
          padding: 4px 10px;
          border-radius: 999px;
          font-size: 11px;
          font-weight: 800;
          letter-spacing: 0.5px;
          text-transform: uppercase;
          border: 1px solid rgba(255, 255, 255, 0.3);
        }

        .pulse-dot {
          width: 8px;
          height: 8px;
          border-radius: 50%;
          background: #fbbf24;
          box-shadow: 0 0 8px #fbbf24;
          animation: pulse 1.2s infinite;
        }

        .is-overdue .pulse-dot {
          background: #f87171;
          box-shadow: 0 0 8px #f87171;
        }

        .order-identity {
          display: flex;
          align-items: center;
          gap: 8px;
        }

        .order-num {
          font-weight: 800;
          font-size: 14px;
          color: #ffffff;
          letter-spacing: 0.3px;
        }

        .order-type-chip {
          background: rgba(255, 255, 255, 0.2);
          padding: 2px 8px;
          border-radius: 4px;
          font-size: 11px;
          font-weight: 700;
        }

        .customer-info {
          font-size: 12px;
          opacity: 0.95;
          font-weight: 500;
        }

        .countdown-pill {
          background: rgba(0, 0, 0, 0.25);
          padding: 3px 9px;
          border-radius: 6px;
          font-size: 12px;
        }

        .text-amber {
          color: #fef08a;
        }

        .text-red {
          color: #fecaca;
        }

        .items-summary-strip {
          font-size: 12px;
          opacity: 0.9;
          max-width: 320px;
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
          background: rgba(0, 0, 0, 0.15);
          padding: 2px 8px;
          border-radius: 4px;
        }

        .alert-right-section {
          display: flex;
          align-items: center;
          gap: 10px;
        }

        .orders-carousel-ctrl {
          display: flex;
          align-items: center;
          gap: 4px;
          background: rgba(0, 0, 0, 0.25);
          padding: 3px 8px;
          border-radius: 6px;
          font-size: 11px;
          font-weight: 600;
        }

        .carousel-arrow {
          background: transparent;
          border: none;
          color: #ffffff;
          cursor: pointer;
          font-size: 11px;
          padding: 2px 4px;
          border-radius: 3px;
          transition: background 0.15s;
        }

        .carousel-arrow:hover {
          background: rgba(255, 255, 255, 0.2);
        }

        .carousel-count {
          font-size: 11px;
          padding: 0 4px;
        }

        .btn-fire-kitchen {
          background: #ffffff;
          color: #b91c1c;
          border: none;
          font-weight: 800;
          font-size: 12px;
          padding: 6px 14px;
          border-radius: 6px;
          cursor: pointer;
          display: flex;
          align-items: center;
          gap: 4px;
          box-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);
          transition: all 0.15s ease-in-out;
        }

        .btn-fire-kitchen:hover:not(:disabled) {
          background: #fef2f2;
          transform: translateY(-1px);
          box-shadow: 0 4px 10px rgba(0, 0, 0, 0.25);
        }

        .btn-fire-kitchen:disabled {
          opacity: 0.65;
          cursor: not-allowed;
        }

        .btn-snooze {
          background: rgba(255, 255, 255, 0.2);
          color: #ffffff;
          border: 1px solid rgba(255, 255, 255, 0.35);
          font-size: 11px;
          font-weight: 600;
          padding: 6px 10px;
          border-radius: 6px;
          cursor: pointer;
          transition: background 0.15s;
        }

        .btn-snooze:hover {
          background: rgba(255, 255, 255, 0.32);
        }

        .btn-view-all {
          color: #ffffff;
          text-decoration: underline;
          font-size: 11px;
          font-weight: 600;
          padding: 4px 6px;
          opacity: 0.9;
        }

        .btn-view-all:hover {
          opacity: 1;
        }

        @keyframes pulse {
          0% {
            transform: scale(0.95);
            opacity: 0.8;
          }
          50% {
            transform: scale(1.3);
            opacity: 1;
          }
          100% {
            transform: scale(0.95);
            opacity: 0.8;
          }
        }

        @keyframes slideDown {
          from {
            transform: translateY(-100%);
            opacity: 0;
          }
          to {
            transform: translateY(0);
            opacity: 1;
          }
        }

        @media (max-width: 900px) {
          .items-summary-strip {
            display: none;
          }
          .advance-alert-bar {
            padding: 6px 10px;
          }
        }
      `}</style>
    </div>
  );
}
