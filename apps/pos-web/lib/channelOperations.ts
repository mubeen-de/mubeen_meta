import { useEffect, useState, useCallback } from "react";
import { authedFetch } from "./auth";

export const CHANNEL_STORAGE_KEY = "kapmeta_channel_operations";
export const CHANNEL_EVENT_KEY = "kapmeta_channel_status_updated";

export interface ChannelOperationsState {
  isOnline: boolean;
  dineInActive: boolean;
  deliveryActive: boolean;
  takeawayActive: boolean;
}

const DEFAULT_STATE: ChannelOperationsState = {
  isOnline: true,
  dineInActive: true,
  deliveryActive: true,
  takeawayActive: true,
};

export function getStoredChannelOperations(): ChannelOperationsState {
  if (typeof window === "undefined") return DEFAULT_STATE;
  try {
    const raw = localStorage.getItem(CHANNEL_STORAGE_KEY);
    if (!raw) return DEFAULT_STATE;
    const parsed = JSON.parse(raw);
    return {
      isOnline: typeof parsed.isOnline === "boolean" ? parsed.isOnline : true,
      dineInActive: typeof parsed.dineInActive === "boolean" ? parsed.dineInActive : true,
      deliveryActive: typeof parsed.deliveryActive === "boolean" ? parsed.deliveryActive : true,
      takeawayActive: typeof parsed.takeawayActive === "boolean" ? parsed.takeawayActive : true,
    };
  } catch {
    return DEFAULT_STATE;
  }
}

export function saveStoredChannelOperations(state: Partial<ChannelOperationsState>): ChannelOperationsState {
  const current = getStoredChannelOperations();
  const next: ChannelOperationsState = { ...current, ...state };
  if (typeof window !== "undefined") {
    try {
      localStorage.setItem(CHANNEL_STORAGE_KEY, JSON.stringify(next));
      window.dispatchEvent(new CustomEvent(CHANNEL_EVENT_KEY, { detail: next }));
    } catch {}
  }
  return next;
}

export function useChannelOperations() {
  const [channels, setChannels] = useState<ChannelOperationsState>(getStoredChannelOperations);

  const refreshFromStorage = useCallback(() => {
    setChannels(getStoredChannelOperations());
  }, []);

  const fetchRemote = useCallback(async () => {
    try {
      const res = await authedFetch("/settings/store-status");
      if (res.ok) {
        const data = await res.json();
        const next: ChannelOperationsState = {
          isOnline: typeof data.isOnline === "boolean" ? data.isOnline : true,
          dineInActive: typeof data.dineInActive === "boolean" ? data.dineInActive : true,
          deliveryActive: typeof data.deliveryActive === "boolean" ? data.deliveryActive : true,
          takeawayActive: typeof data.takeawayActive === "boolean" ? data.takeawayActive : true,
        };
        saveStoredChannelOperations(next);
        setChannels(next);
      }
    } catch {}
  }, []);

  useEffect(() => {
    refreshFromStorage();
    fetchRemote();

    const handleCustomEvent = (e: Event) => {
      const custom = e as CustomEvent<ChannelOperationsState>;
      if (custom.detail) {
        setChannels(custom.detail);
      } else {
        refreshFromStorage();
      }
    };

    window.addEventListener(CHANNEL_EVENT_KEY, handleCustomEvent);
    window.addEventListener("storage", refreshFromStorage);

    return () => {
      window.removeEventListener(CHANNEL_EVENT_KEY, handleCustomEvent);
      window.removeEventListener("storage", refreshFromStorage);
    };
  }, [refreshFromStorage, fetchRemote]);

  const updateChannels = useCallback(async (patch: Partial<ChannelOperationsState>) => {
    // 1. Instantly update local state and localStorage
    const next = saveStoredChannelOperations(patch);
    setChannels(next);

    // 2. Persist to API
    try {
      await authedFetch("/settings/store-status", {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(patch),
      });
    } catch (err) {
      console.error("Failed to sync channel operations to API:", err);
    }
  }, []);

  const toggleStore = useCallback(() => {
    updateChannels({ isOnline: !channels.isOnline });
  }, [channels.isOnline, updateChannels]);

  const toggleDineIn = useCallback(() => {
    updateChannels({ dineInActive: !channels.dineInActive });
  }, [channels.dineInActive, updateChannels]);

  const toggleDelivery = useCallback(() => {
    updateChannels({ deliveryActive: !channels.deliveryActive });
  }, [channels.deliveryActive, updateChannels]);

  const toggleTakeaway = useCallback(() => {
    updateChannels({ takeawayActive: !channels.takeawayActive });
  }, [channels.takeawayActive, updateChannels]);

  return {
    ...channels,
    updateChannels,
    toggleStore,
    toggleDineIn,
    toggleDelivery,
    toggleTakeaway,
  };
}
