import React from "react";
import { render, screen, fireEvent, waitFor } from "@testing-library/react";
import { describe, expect, it, vi, beforeEach } from "vitest";
import ItemToggleModal from "../components/ItemToggleModal";
import * as authLib from "../lib/auth";

describe("ItemToggleModal Component (Timed 86 Stock On/Off)", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    localStorage.clear();
    vi.spyOn(authLib, "authedFetch").mockImplementation((url: string, opts?: any) => {
      if (url === "/menu/availability") {
        return Promise.resolve({
          ok: true,
          json: async () => [
            {
              id: "item_test_1",
              name: "Masala Dosa",
              categoryName: "Breakfast",
              priceMinor: 8000,
              isStocked: true,
              stockQty: 100,
              isVeg: true,
              autoResumeAt: null,
            },
            {
              id: "item_test_2",
              name: "Cold Coffee",
              categoryName: "Cold Beverage",
              priceMinor: 9000,
              isStocked: false,
              stockQty: 0,
              isVeg: true,
              autoResumeAt: new Date(Date.now() + 3600 * 1000).toISOString(),
            },
          ],
        } as any);
      }
      return Promise.resolve({
        ok: true,
        json: async () => ({ newVersion: 2, isStocked: true }),
      } as any);
    });
  });

  it("renders modal header with 86 stock title and subtitle", async () => {
    render(<ItemToggleModal onClose={vi.fn()} />);

    expect(screen.getByText("Item On/Off (86 Stock Control)")).toBeInTheDocument();
    expect(screen.getByText(/1hr, 2hr, 6hr, or Next Day/)).toBeInTheDocument();

    await waitFor(() => {
      expect(screen.getByText("Masala Dosa")).toBeInTheDocument();
      expect(screen.getByText("Cold Coffee")).toBeInTheDocument();
    });
  });

  it("shows Turn OFF options including 1hr, 2hr, 6hr, and Next Day when clicking Turn OFF", async () => {
    render(<ItemToggleModal onClose={vi.fn()} />);

    await waitFor(() => {
      expect(screen.getByText("Masala Dosa")).toBeInTheDocument();
    });

    const turnOffBtn = screen.getByRole("button", { name: /Turn OFF/i });
    fireEvent.click(turnOffBtn);

    // Verify duration preset buttons appear
    expect(screen.getByText("1 Hour")).toBeInTheDocument();
    expect(screen.getByText("2 Hours")).toBeInTheDocument();
    expect(screen.getByText("6 Hours")).toBeInTheDocument();
    expect(screen.getByText("Next Day")).toBeInTheDocument();
    expect(screen.getByText("Indefinite")).toBeInTheDocument();
  });

  it("turns OFF item with selected duration (e.g. 1 Hour)", async () => {
    const fetchSpy = vi.spyOn(authLib, "authedFetch");
    render(<ItemToggleModal onClose={vi.fn()} />);

    await waitFor(() => {
      expect(screen.getByText("Masala Dosa")).toBeInTheDocument();
    });

    fireEvent.click(screen.getByRole("button", { name: /Turn OFF/i }));
    fireEvent.click(screen.getByText("1 Hour"));

    await waitFor(() => {
      expect(fetchSpy).toHaveBeenCalledWith(
        expect.stringContaining("/menu/items/item_test_1/availability"),
        expect.objectContaining({
          method: "PATCH",
          body: expect.stringContaining('"durationOption":"1hr"'),
        })
      );
    });
  });

  it("allows immediate ON for an OFF item and supports changing duration", async () => {
    const fetchSpy = vi.spyOn(authLib, "authedFetch");
    render(<ItemToggleModal onClose={vi.fn()} />);

    await waitFor(() => {
      expect(screen.getByText("Cold Coffee")).toBeInTheDocument();
    });

    // Immediate Turn ON button must exist for off item
    const turnOnBtn = screen.getByRole("button", { name: /Turn ON Now/i });
    expect(turnOnBtn).toBeInTheDocument();

    fireEvent.click(turnOnBtn);

    await waitFor(() => {
      expect(fetchSpy).toHaveBeenCalledWith(
        expect.stringContaining("/menu/items/item_test_2/availability"),
        expect.objectContaining({
          method: "PATCH",
          body: expect.stringContaining('"isStocked":true'),
        })
      );
    });
  });
});
