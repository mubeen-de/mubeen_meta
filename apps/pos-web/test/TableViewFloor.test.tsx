import React from "react";
import { render, screen, fireEvent, waitFor } from "@testing-library/react";
import { describe, expect, it, vi, beforeEach } from "vitest";
import TableViewFloor from "../components/TableViewFloor";

const mockTables = [
  { id: "tbl-a1", tableNumber: "A1", capacity: 4, section: "AC", status: "VACANT" },
  { id: "tbl-a2", tableNumber: "A2", capacity: 4, section: "AC", status: "VACANT" },
  { id: "tbl-a8", tableNumber: "A8", capacity: 4, section: "AC", status: "PRINTED", elapsedMinutes: 26, totalMinor: 23800 },
  { id: "tbl-a15", tableNumber: "A15", capacity: 4, section: "AC", status: "VACANT" },
  { id: "tbl-b1", tableNumber: "B1", capacity: 4, section: "Non AC", status: "VACANT" },
  { id: "tbl-b4", tableNumber: "B4", capacity: 4, section: "Non AC", status: "RUNNING_KOT", elapsedMinutes: 31, totalMinor: 74381 },
  { id: "tbl-b7", tableNumber: "B7", capacity: 4, section: "Non AC", status: "RUNNING_KOT", elapsedMinutes: 3, totalMinor: 4286 },
  { id: "tbl-b11", tableNumber: "B11", capacity: 4, section: "Non AC", status: "RUNNING_KOT", elapsedMinutes: 11, totalMinor: 19810 },
  { id: "tbl-b15", tableNumber: "B15", capacity: 4, section: "Non AC", status: "VACANT" },
  { id: "tbl-b18", tableNumber: "B18", capacity: 4, section: "Non AC", status: "VACANT" },
  { id: "tbl-b19", tableNumber: "B19", capacity: 4, section: "Non AC", status: "VACANT" },
  { id: "tbl-b21", tableNumber: "B21", capacity: 4, section: "Non AC", status: "VACANT" },
  { id: "tbl-b22", tableNumber: "B22", capacity: 4, section: "Non AC", status: "VACANT" },
  { id: "tbl-b23", tableNumber: "B23", capacity: 4, section: "Non AC", status: "VACANT" },
  { id: "tbl-b26", tableNumber: "B26", capacity: 4, section: "Non AC", status: "VACANT" },
  {
    id: "tbl-r1",
    tableNumber: "R1",
    capacity: 6,
    section: "Rooftop",
    status: "RESERVED",
    reservation: {
      id: "resv-1",
      customerName: "Vikram Malhotra",
      guestCount: 6,
      reservationTime: new Date().toISOString(),
    },
  },
];

vi.mock("../lib/auth", () => ({
  authedFetch: vi.fn(async (url: string) => {
    if (url === "/tables") {
      return {
        ok: true,
        json: async () => mockTables,
      };
    }
    return { ok: true, json: async () => ({}) };
  }),
}));

vi.mock("../lib/useKapmetaSocket", () => ({
  useKapmetaSocket: vi.fn(),
}));

describe("TableViewFloor Component", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("renders the top toolbar with Table View title, refresh, Add Table, Delivery, and Pick Up buttons", () => {
    const handleDelivery = vi.fn();
    const handlePickup = vi.fn();

    render(
      <TableViewFloor
        onNavigateDelivery={handleDelivery}
        onNavigatePickup={handlePickup}
      />
    );

    expect(screen.getByText("Table View")).toBeInTheDocument();
    expect(screen.getByTitle("Refresh Tables Status")).toBeInTheDocument();

    const addTableBtn = screen.getByText("Add Table");
    expect(addTableBtn).toBeInTheDocument();

    const deliveryBtn = screen.getByText("Delivery");
    expect(deliveryBtn).toBeInTheDocument();
    fireEvent.click(deliveryBtn);
    expect(handleDelivery).toHaveBeenCalledTimes(1);

    const pickupBtn = screen.getByText("Pick Up");
    expect(pickupBtn).toBeInTheDocument();
    fireEvent.click(pickupBtn);
    expect(handlePickup).toHaveBeenCalledTimes(1);
  });

  it("renders the Move KOT / Items toggle and all status legend indicators including Reserved", () => {
    render(<TableViewFloor />);

    expect(screen.getByText("Move KOT / Items")).toBeInTheDocument();
    expect(screen.getByText("Blank Table")).toBeInTheDocument();
    expect(screen.getByText("Running Table")).toBeInTheDocument();
    expect(screen.getByText("Printed Table")).toBeInTheDocument();
    expect(screen.getByText("Paid Table")).toBeInTheDocument();
    expect(screen.getByText("Running KOT Table")).toBeInTheDocument();
    expect(screen.getAllByText(/Reserved/i).length).toBeGreaterThanOrEqual(1);
  });

  it("renders the AC section with A1 to A15 including printed table A8 with ₹238.00 and 26 Min", async () => {
    render(<TableViewFloor />);

    await waitFor(() => {
      expect(screen.getByText("AC")).toBeInTheDocument();
    });

    // Table labels
    expect(screen.getByText("A1")).toBeInTheDocument();
    expect(screen.getByText("A2")).toBeInTheDocument();
    expect(screen.getByText("A8")).toBeInTheDocument();
    expect(screen.getByText("A15")).toBeInTheDocument();

    // A8 Printed status values
    expect(screen.getByText("26 Min")).toBeInTheDocument();
    expect(screen.getByText("₹238.00")).toBeInTheDocument();
  });

  it("renders the Non AC section with B1 to B26 including occupied running KOT tables", async () => {
    render(<TableViewFloor />);

    await waitFor(() => {
      expect(screen.getByText("Non AC")).toBeInTheDocument();
    });

    // Table labels
    expect(screen.getByText("B1")).toBeInTheDocument();
    expect(screen.getByText("B4")).toBeInTheDocument();
    expect(screen.getByText("B7")).toBeInTheDocument();
    expect(screen.getByText("B11")).toBeInTheDocument();
    expect(screen.getByText("B15")).toBeInTheDocument();
    expect(screen.getByText("B18")).toBeInTheDocument();
    expect(screen.getByText("B19")).toBeInTheDocument();
    expect(screen.getByText("B21")).toBeInTheDocument();
    expect(screen.getByText("B22")).toBeInTheDocument();
    expect(screen.getByText("B23")).toBeInTheDocument();
    expect(screen.getByText("B26")).toBeInTheDocument();

    // B4 values: 31 Min, ₹743.81
    expect(screen.getByText("31 Min")).toBeInTheDocument();
    expect(screen.getByText("₹743.81")).toBeInTheDocument();

    // B7 values: 3 Min, ₹42.86
    expect(screen.getByText("3 Min")).toBeInTheDocument();
    expect(screen.getByText("₹42.86")).toBeInTheDocument();

    // B11 values: 11 Min, ₹198.10
    expect(screen.getByText("11 Min")).toBeInTheDocument();
    expect(screen.getByText("₹198.10")).toBeInTheDocument();
  });

  it("triggers onSelectTable when a table card is clicked", async () => {
    const handleSelect = vi.fn();
    render(<TableViewFloor onSelectTable={handleSelect} />);

    await waitFor(() => {
      expect(screen.getByText("A1")).toBeInTheDocument();
    });

    const tableA1 = screen.getByText("A1");
    fireEvent.click(tableA1);

    expect(handleSelect).toHaveBeenCalledWith(
      expect.objectContaining({ tableNumber: "A1" })
    );
  });

  it("opens Add Table modal when Add Table button is clicked", () => {
    render(<TableViewFloor />);

    const addTableBtn = screen.getByText("Add Table");
    fireEvent.click(addTableBtn);

    expect(screen.getByText("Add New Dining Table")).toBeInTheDocument();
    expect(screen.getByText("Table Number / Code")).toBeInTheDocument();
  });

  it("opens Reserve Table modal and Table QRs modal from toolbar buttons", () => {
    render(<TableViewFloor />);

    const reserveBtn = screen.getByText("📅 Reservations");
    expect(reserveBtn).toBeInTheDocument();
    fireEvent.click(reserveBtn);
    expect(screen.getByText("Reserve Dining Table")).toBeInTheDocument();

    const qrBtn = screen.getByText("📱 Table QRs");
    expect(qrBtn).toBeInTheDocument();
    fireEvent.click(qrBtn);
    expect(screen.getByText("Customer Self-Order QR")).toBeInTheDocument();
  });
});
