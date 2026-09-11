import React from "react";
import { render, screen, fireEvent, waitFor } from "@testing-library/react";
import { describe, expect, it, vi, beforeEach } from "vitest";
import QuickSearchModal from "../components/QuickSearchModal";
import * as authModule from "../lib/auth";

const mockPush = vi.fn();
vi.mock("next/router", () => ({
  useRouter: () => ({
    push: mockPush,
    pathname: "/",
    query: {},
  }),
}));

describe("QuickSearchModal Component", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("searches KOT with full ticket number preserving prefix without leading dash", async () => {
    const mockKotResponse = [
      {
        id: "00089db3-43f2-4348-bbff-da57724bc4eb",
        ticketNumber: "KOT-1788464996543-783",
        status: "QUEUED",
        tableNumber: "ll",
        kotItems: [
          { id: "item1", quantity: 1, menuItem: { name: "(S) Idly" } },
          { id: "item2", quantity: 1, menuItem: { name: "70 Mm Dosa" } }
        ]
      }
    ];

    const fetchSpy = vi.spyOn(authModule, "authedFetch").mockResolvedValue({
      ok: true,
      json: async () => mockKotResponse,
    } as any);

    render(<QuickSearchModal type="KOT" onClose={vi.fn()} />);

    const input = screen.getByPlaceholderText("Enter KOT number");
    fireEvent.change(input, { target: { value: "KOT-1788464996543-783" } });
    fireEvent.click(screen.getByRole("button", { name: "Search" }));

    await waitFor(() => {
      expect(fetchSpy).toHaveBeenCalledWith("/kitchen/kot?ticketNumber=KOT-1788464996543-783");
    });

    expect(await screen.findByText("KOT-1788464996543-783")).toBeInTheDocument();
    expect(screen.getByText("QUEUED")).toBeInTheDocument();
    expect(screen.getByText(/Table:\s*ll/)).toBeInTheDocument();
    expect(screen.getByText(/\(S\) Idly, 70 Mm Dosa/)).toBeInTheDocument();
  });

  it("searches KOT with suffix number 783 and navigates on click", async () => {
    const mockKotResponse = [
      {
        id: "00089db3-43f2-4348-bbff-da57724bc4eb",
        ticketNumber: "KOT-1788464996543-783",
        status: "QUEUED",
        tableNumber: "ll",
        kotItems: [{ id: "item1", quantity: 1, menuItem: { name: "(S) Idly" } }]
      }
    ];

    vi.spyOn(authModule, "authedFetch").mockResolvedValue({
      ok: true,
      json: async () => mockKotResponse,
    } as any);

    const onClose = vi.fn();
    render(<QuickSearchModal type="KOT" onClose={onClose} />);

    const input = screen.getByPlaceholderText("Enter KOT number");
    fireEvent.change(input, { target: { value: "783" } });
    fireEvent.click(screen.getByRole("button", { name: "Search" }));

    const resultButton = await screen.findByRole("button", { name: /KOT-1788464996543-783/i });
    fireEvent.click(resultButton);

    expect(onClose).toHaveBeenCalled();
    expect(mockPush).toHaveBeenCalledWith(
      expect.stringContaining("/kitchen?kot=KOT-1788464996543-783")
    );
  });

  it("searches BILL with unhyphenated date-sequence (e.g. 202609110003) and auto-formats", async () => {
    const mockOrderResponse = {
      orders: [
        {
          id: "order-uuid-123",
          orderNumber: "20260911-0003",
          status: "COMPLETED",
          grandTotalMinor: "12000",
          tableNumber: "T-03",
        },
      ],
    };

    const fetchSpy = vi.spyOn(authModule, "authedFetch").mockResolvedValue({
      ok: true,
      json: async () => mockOrderResponse,
    } as any);

    const onClose = vi.fn();
    render(<QuickSearchModal type="BILL" onClose={onClose} />);

    const input = screen.getByPlaceholderText("Enter bill / order number");
    fireEvent.change(input, { target: { value: "202609110003" } });
    fireEvent.click(screen.getByRole("button", { name: "Search" }));

    await waitFor(() => {
      expect(fetchSpy).toHaveBeenCalledWith(
        expect.stringContaining("/orders?orderNumber=20260911-0003")
      );
    });

    expect(await screen.findByText("20260911-0003")).toBeInTheDocument();
    expect(screen.getByText("COMPLETED")).toBeInTheDocument();
    expect(screen.getByText("₹120.00")).toBeInTheDocument();

    const resultButton = screen.getByRole("button", { name: /20260911-0003/i });
    fireEvent.click(resultButton);

    expect(onClose).toHaveBeenCalled();
    expect(mockPush).toHaveBeenCalledWith("/pending-order-detail?orderId=order-uuid-123");
  });
});
