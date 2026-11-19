import React, { useState, useEffect } from "react";
import { authedFetch } from "../lib/auth";

interface TableReservationData {
  id?: string;
  customerName?: string;
  phone?: string;
  guestCount?: number;
  reservationTime?: string;
  notes?: string;
}

interface TableOption {
  id: string;
  tableNumber: string;
  capacity: number;
  section?: string | null;
  status: string;
  reservation?: TableReservationData | null;
}

interface ReserveTableModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSuccess: () => void;
  tables: TableOption[];
  selectedTableId?: string | null;
}

export default function ReserveTableModal({
  isOpen,
  onClose,
  onSuccess,
  tables,
  selectedTableId: initialTableId,
}: ReserveTableModalProps) {
  const getTodayStr = () => {
    const d = new Date();
    const year = d.getFullYear();
    const month = String(d.getMonth() + 1).padStart(2, "0");
    const day = String(d.getDate()).padStart(2, "0");
    return `${year}-${month}-${day}`;
  };

  const getTomorrowStr = () => {
    const d = new Date();
    d.setDate(d.getDate() + 1);
    const year = d.getFullYear();
    const month = String(d.getMonth() + 1).padStart(2, "0");
    const day = String(d.getDate()).padStart(2, "0");
    return `${year}-${month}-${day}`;
  };

  const [tableId, setTableId] = useState(initialTableId || (tables[0]?.id ?? ""));
  const [customerName, setCustomerName] = useState("");
  const [customerPhone, setCustomerPhone] = useState("");
  const [guestCount, setGuestCount] = useState(2);
  const [reservationDate, setReservationDate] = useState(getTodayStr);
  const [reservationTime, setReservationTime] = useState(() => {
    const now = new Date();
    now.setMinutes(now.getMinutes() + 30);
    return now.toTimeString().slice(0, 5);
  });
  const [specialNotes, setSpecialNotes] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const [cancelling, setCancelling] = useState(false);
  const [errorMsg, setErrorMsg] = useState<string | null>(null);

  // Sync selected table on modal open or table selection
  useEffect(() => {
    if (initialTableId) {
      setTableId(initialTableId);
    } else if (tables.length > 0 && !tableId) {
      setTableId(tables[0].id);
    }
  }, [initialTableId, tables, tableId]);

  const selectedTable = tables.find((t) => t.id === tableId);
  const isTableCurrentlyReserved =
    selectedTable?.status === "RESERVED" || Boolean(selectedTable?.reservation);

  // Auto populate existing reservation info when switching table
  useEffect(() => {
    if (selectedTable?.reservation) {
      const res = selectedTable.reservation;
      if (res.customerName) setCustomerName(res.customerName);
      if (res.phone) setCustomerPhone(res.phone);
      if (res.guestCount) setGuestCount(res.guestCount);
      if (res.notes) setSpecialNotes(res.notes);
      if (res.reservationTime) {
        try {
          const d = new Date(res.reservationTime);
          if (!isNaN(d.getTime())) {
            const year = d.getFullYear();
            const month = String(d.getMonth() + 1).padStart(2, "0");
            const day = String(d.getDate()).padStart(2, "0");
            setReservationDate(`${year}-${month}-${day}`);
            setReservationTime(d.toTimeString().slice(0, 5));
          }
        } catch (_) {}
      }
    }
  }, [tableId, selectedTable]);

  if (!isOpen) return null;

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!customerName.trim()) {
      setErrorMsg("Please enter guest/customer name");
      return;
    }
    if (!tableId) {
      setErrorMsg("Please select a table to reserve");
      return;
    }
    if (!reservationDate) {
      setErrorMsg("Please select a reservation date");
      return;
    }
    if (!reservationTime) {
      setErrorMsg("Please select an arrival slot time");
      return;
    }

    try {
      setSubmitting(true);
      setErrorMsg(null);

      // Combine local Date + Time into ISO timestamp
      const [hours, minutes] = (reservationTime || "19:00").split(":").map(Number);
      const dateParts = reservationDate.split("-").map(Number);
      const scheduledDateTime = new Date(
        dateParts[0],
        dateParts[1] - 1,
        dateParts[2],
        hours || 19,
        minutes || 0,
        0,
        0
      );

      const res = await authedFetch(`/tables/${tableId}/reserve`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          customerName: customerName.trim(),
          customerPhone: customerPhone.trim() || undefined,
          guestCount: Number(guestCount) || 2,
          reservationTime: scheduledDateTime.toISOString(),
          specialNotes: specialNotes.trim() || undefined,
        }),
      });

      if (res.ok) {
        onSuccess();
        onClose();
      } else {
        const err = await res.json().catch(() => ({}));
        setErrorMsg(err.error || "Failed to confirm reservation");
      }
    } catch (err: any) {
      setErrorMsg(err.message || "Network error reserving table");
    } finally {
      setSubmitting(false);
    }
  };

  const handleCancelReservation = async () => {
    if (!tableId) return;
    const confirmText = `Are you sure you want to cancel the reservation for Table ${
      selectedTable?.tableNumber || ""
    }? This table will be released and marked Vacant.`;
    if (!window.confirm(confirmText)) {
      return;
    }

    try {
      setCancelling(true);
      setErrorMsg(null);
      const res = await authedFetch(`/tables/${tableId}/cancel-reservation`, {
        method: "POST",
      });

      if (res.ok) {
        onSuccess();
        onClose();
      } else {
        const err = await res.json().catch(() => ({}));
        setErrorMsg(err.error || "Failed to cancel reservation");
      }
    } catch (err: any) {
      setErrorMsg(err.message || "Network error cancelling reservation");
    } finally {
      setCancelling(false);
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm p-4">
      <div className="bg-slate-900 border border-amber-500/30 rounded-2xl shadow-2xl w-full max-w-lg overflow-hidden text-slate-100 animate-in fade-in zoom-in-95 duration-150">
        {/* Modal Header */}
        <div className="px-6 py-4 bg-gradient-to-r from-amber-950/40 via-slate-900 to-slate-900 border-b border-amber-500/20 flex items-center justify-between">
          <div className="flex items-center space-x-3">
            <span className="flex h-9 w-9 items-center justify-center rounded-xl bg-amber-500/10 text-amber-400 border border-amber-500/30 text-lg">
              📅
            </span>
            <div>
              <h3 className="text-lg font-bold text-amber-200">Reserve Dining Table</h3>
              <p className="text-xs text-slate-400">Lock table slot for arriving guests & parties</p>
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

        {/* Modal Body */}
        <form onSubmit={handleSubmit} className="p-6 space-y-4">
          {errorMsg && (
            <div className="p-3 bg-red-950/60 border border-red-500/40 text-red-300 text-xs rounded-xl flex items-center gap-2">
              <span>⚠️</span>
              <span>{errorMsg}</span>
            </div>
          )}

          {/* If table is currently reserved, show details banner & quick cancel button */}
          {isTableCurrentlyReserved && (
            <div className="p-3 bg-amber-950/40 border border-amber-500/30 rounded-xl flex items-center justify-between text-xs">
              <div>
                <span className="font-bold text-amber-200">Table Currently Reserved:</span>
                <span className="text-amber-300 ml-1">
                  {selectedTable?.reservation?.customerName || customerName || "Active Guest"} (
                  {selectedTable?.reservation?.guestCount || guestCount} Pax)
                </span>
                {selectedTable?.reservation?.reservationTime && (
                  <span className="text-amber-400/80 block mt-0.5 text-[11px]">
                    🕒 Reserved for:{" "}
                    {new Date(selectedTable.reservation.reservationTime).toLocaleString([], {
                      dateStyle: "medium",
                      timeStyle: "short",
                    })}
                  </span>
                )}
              </div>
              <button
                type="button"
                onClick={handleCancelReservation}
                disabled={submitting || cancelling}
                className="px-3 py-1.5 rounded-lg bg-red-600 hover:bg-red-500 text-white text-xs font-bold transition shadow-sm flex items-center gap-1 active:scale-95 disabled:opacity-50"
              >
                <span>✕</span>
                <span>{cancelling ? "Cancelling..." : "Cancel Reservation"}</span>
              </button>
            </div>
          )}

          {/* Table Selector */}
          <div>
            <label className="block text-xs font-semibold uppercase tracking-wider text-slate-300 mb-1.5">
              Select Dining Table
            </label>
            <select
              value={tableId}
              onChange={(e) => setTableId(e.target.value)}
              className="w-full bg-slate-800/80 border border-slate-700 rounded-xl px-3.5 py-2.5 text-sm font-medium text-white focus:outline-none focus:border-amber-400"
            >
              {tables.map((t) => (
                <option key={t.id} value={t.id} disabled={t.status === "RUNNING" || t.status === "PRINTED"}>
                  Table {t.tableNumber} ({t.section || "General"}) — {t.capacity} Pax [{t.status}]
                </option>
              ))}
            </select>
            {selectedTable && (
              <span className="text-[11px] text-amber-400/80 mt-1 block">
                Standard Capacity: {selectedTable.capacity} guests | Section: {selectedTable.section || "General"}
              </span>
            )}
          </div>

          {/* Guest Name & Phone */}
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            <div>
              <label className="block text-xs font-semibold uppercase tracking-wider text-slate-300 mb-1.5">
                Guest / Host Name *
              </label>
              <input
                type="text"
                placeholder="e.g. Rahul Sharma"
                value={customerName}
                onChange={(e) => setCustomerName(e.target.value)}
                required
                className="w-full bg-slate-800/80 border border-slate-700 rounded-xl px-3.5 py-2 text-sm text-white focus:outline-none focus:border-amber-400"
              />
            </div>
            <div>
              <label className="block text-xs font-semibold uppercase tracking-wider text-slate-300 mb-1.5">
                Contact Phone
              </label>
              <input
                type="tel"
                placeholder="e.g. 9876543210"
                value={customerPhone}
                onChange={(e) => setCustomerPhone(e.target.value)}
                className="w-full bg-slate-800/80 border border-slate-700 rounded-xl px-3.5 py-2 text-sm text-white focus:outline-none focus:border-amber-400"
              />
            </div>
          </div>

          {/* Number of Guests (Pax) */}
          <div>
            <label className="block text-xs font-semibold uppercase tracking-wider text-slate-300 mb-1.5">
              Number of Guests (Pax)
            </label>
            <div className="flex items-center gap-2 max-w-xs">
              <button
                type="button"
                onClick={() => setGuestCount((p) => Math.max(1, p - 1))}
                className="h-9 w-9 flex items-center justify-center rounded-lg bg-slate-800 border border-slate-700 text-slate-200 hover:bg-slate-700 font-bold active:scale-95 transition"
              >
                -
              </button>
              <div className="flex-1 text-center font-bold text-amber-300 bg-slate-800/80 border border-slate-700 rounded-lg py-1.5 text-sm">
                {guestCount} Pax
              </div>
              <button
                type="button"
                onClick={() => setGuestCount((p) => p + 1)}
                className="h-9 w-9 flex items-center justify-center rounded-lg bg-slate-800 border border-slate-700 text-slate-200 hover:bg-slate-700 font-bold active:scale-95 transition"
              >
                +
              </button>
            </div>
          </div>

          {/* Date & Time Selector */}
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            <div>
              <div className="flex items-center justify-between mb-1.5">
                <label className="block text-xs font-semibold uppercase tracking-wider text-slate-300">
                  Reservation Date *
                </label>
                <div className="flex gap-1">
                  <button
                    type="button"
                    onClick={() => setReservationDate(getTodayStr())}
                    className={`text-[10px] px-2 py-0.5 rounded font-semibold border transition ${
                      reservationDate === getTodayStr()
                        ? "bg-amber-500/20 border-amber-500 text-amber-300 font-bold"
                        : "bg-slate-800 border-slate-700 text-slate-400 hover:text-white"
                    }`}
                  >
                    Today
                  </button>
                  <button
                    type="button"
                    onClick={() => setReservationDate(getTomorrowStr())}
                    className={`text-[10px] px-2 py-0.5 rounded font-semibold border transition ${
                      reservationDate === getTomorrowStr()
                        ? "bg-amber-500/20 border-amber-500 text-amber-300 font-bold"
                        : "bg-slate-800 border-slate-700 text-slate-400 hover:text-white"
                    }`}
                  >
                    Tomorrow
                  </button>
                </div>
              </div>
              <input
                type="date"
                min={getTodayStr()}
                value={reservationDate}
                onChange={(e) => setReservationDate(e.target.value)}
                required
                className="w-full bg-slate-800/80 border border-slate-700 rounded-xl px-3.5 py-2 text-sm text-white focus:outline-none focus:border-amber-400"
              />
            </div>

            <div>
              <label className="block text-xs font-semibold uppercase tracking-wider text-slate-300 mb-1.5">
                Arrival Slot Time *
              </label>
              <input
                type="time"
                value={reservationTime}
                onChange={(e) => setReservationTime(e.target.value)}
                required
                className="w-full bg-slate-800/80 border border-slate-700 rounded-xl px-3.5 py-2 text-sm text-white focus:outline-none focus:border-amber-400"
              />
            </div>
          </div>

          {/* Quick Slot Presets */}
          <div className="flex flex-wrap items-center gap-1.5 pt-1">
            <span className="text-[11px] text-slate-400 mr-1">Quick Slots:</span>
            {["12:30", "13:00", "19:00", "19:30", "20:00", "20:30", "21:00", "21:30"].map((t) => (
              <button
                key={t}
                type="button"
                onClick={() => setReservationTime(t)}
                className={`text-xs px-2.5 py-1 rounded-md border transition ${
                  reservationTime === t
                    ? "bg-amber-500/20 border-amber-500 text-amber-200 font-bold"
                    : "bg-slate-800/60 border-slate-700/80 text-slate-400 hover:text-slate-200"
                }`}
              >
                {t}
              </button>
            ))}
          </div>

          {/* Special Notes */}
          <div>
            <label className="block text-xs font-semibold uppercase tracking-wider text-slate-300 mb-1.5">
              Special Requests / Occasion
            </label>
            <input
              type="text"
              placeholder="e.g. Birthday decoration, High chair, Window corner"
              value={specialNotes}
              onChange={(e) => setSpecialNotes(e.target.value)}
              className="w-full bg-slate-800/80 border border-slate-700 rounded-xl px-3.5 py-2 text-sm text-white focus:outline-none focus:border-amber-400"
            />
          </div>

          {/* Modal Footer */}
          <div className="flex items-center justify-between gap-3 pt-3 border-t border-slate-800">
            <div>
              {isTableCurrentlyReserved && (
                <button
                  type="button"
                  onClick={handleCancelReservation}
                  disabled={submitting || cancelling}
                  className="px-3.5 py-2 text-xs font-bold rounded-xl bg-red-950/70 border border-red-500/40 hover:bg-red-600 text-red-200 hover:text-white transition active:scale-95"
                >
                  {cancelling ? "Cancelling..." : "✕ Cancel Reservation"}
                </button>
              )}
            </div>

            <div className="flex items-center gap-3">
              <button
                type="button"
                onClick={onClose}
                disabled={submitting || cancelling}
                className="px-4 py-2 text-sm rounded-xl text-slate-300 hover:bg-slate-800 transition"
              >
                Close
              </button>
              <button
                type="submit"
                disabled={submitting || cancelling}
                className="px-5 py-2 text-sm font-bold rounded-xl bg-gradient-to-r from-amber-500 to-amber-600 hover:from-amber-400 hover:to-amber-500 text-slate-950 shadow-lg shadow-amber-500/20 transition disabled:opacity-50"
              >
                {submitting
                  ? "Confirming..."
                  : isTableCurrentlyReserved
                  ? "Update Reservation"
                  : "Confirm Reservation"}
              </button>
            </div>
          </div>
        </form>
      </div>
    </div>
  );
}
