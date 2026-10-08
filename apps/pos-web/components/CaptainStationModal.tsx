import React, { useState, useEffect } from "react";

export interface CaptainStationModalProps {
  isOpen: boolean;
  onClose: () => void;
  currentStation: string;
  autoStation: string;
  captainName?: string;
  onSelectStation: (stationCode: string) => void;
}

const PRESET_STATIONS = [
  { id: "cp1", label: "Station cp1", description: "Captain Handheld Tablet 1" },
  { id: "cp2", label: "Station cp2", description: "Captain Handheld Tablet 2" },
  { id: "cp3", label: "Station cp3", description: "Captain Handheld Tablet 3" },
  { id: "cp4", label: "Station cp4", description: "Captain Handheld Tablet 4" },
  { id: "cp5", label: "Station cp5", description: "Captain Handheld Tablet 5" },
  { id: "cp6", label: "Station cp6", description: "Captain Handheld Tablet 6" },
];

export default function CaptainStationModal({
  isOpen,
  onClose,
  currentStation,
  autoStation,
  captainName = "Captain",
  onSelectStation,
}: CaptainStationModalProps) {
  const [selected, setSelected] = useState(currentStation);
  const [customCode, setCustomCode] = useState("");
  const [isCustomMode, setIsCustomMode] = useState(false);

  useEffect(() => {
    setSelected(currentStation);
    const isPreset = PRESET_STATIONS.some((s) => s.id === currentStation);
    if (!isPreset && currentStation) {
      setCustomCode(currentStation);
      setIsCustomMode(true);
    } else {
      setIsCustomMode(false);
    }
  }, [currentStation, isOpen]);

  if (!isOpen) return null;

  const handleSelect = (code: string) => {
    setSelected(code);
    setIsCustomMode(false);
  };

  const handleSave = () => {
    const finalCode = isCustomMode && customCode.trim() ? customCode.trim().toLowerCase() : selected;
    if (finalCode) {
      onSelectStation(finalCode);
      onClose();
    }
  };

  const handleResetToAuto = () => {
    if (autoStation) {
      setSelected(autoStation);
      setIsCustomMode(false);
      onSelectStation(autoStation);
      onClose();
    }
  };

  return (
    <div
      style={{
        position: "fixed",
        inset: 0,
        backgroundColor: "rgba(15, 23, 42, 0.75)",
        backdropFilter: "blur(4px)",
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        zIndex: 9999,
        padding: "16px",
      }}
      onClick={onClose}
    >
      <div
        style={{
          backgroundColor: "#1e293b",
          border: "1px solid #334155",
          borderRadius: "16px",
          width: "100%",
          maxWidth: "460px",
          overflow: "hidden",
          boxShadow: "0 25px 50px -12px rgba(0, 0, 0, 0.5)",
          color: "#f8fafc",
        }}
        onClick={(e) => e.stopPropagation()}
      >
        {/* Header */}
        <div
          style={{
            padding: "16px 20px",
            borderBottom: "1px solid #334155",
            display: "flex",
            alignItems: "center",
            justifyContent: "space-between",
            background: "linear-gradient(to right, #0f172a, #1e293b)",
          }}
        >
          <div style={{ display: "flex", alignItems: "center", gap: "10px" }}>
            <span style={{ fontSize: "1.25rem" }}>📱</span>
            <div>
              <h3 style={{ margin: 0, fontSize: "1rem", fontWeight: 700, color: "#f8fafc" }}>
                Captain Station Selection
              </h3>
              <p style={{ margin: "2px 0 0 0", fontSize: "0.75rem", color: "#94a3b8" }}>
                Logged in as <strong style={{ color: "#38bdf8" }}>{captainName}</strong>
              </p>
            </div>
          </div>
          <button
            type="button"
            onClick={onClose}
            style={{
              background: "#334155",
              border: "none",
              color: "#cbd5e1",
              fontSize: "14px",
              width: "28px",
              height: "28px",
              borderRadius: "50%",
              cursor: "pointer",
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
            }}
          >
            ✕
          </button>
        </div>

        {/* Modal Body */}
        <div style={{ padding: "20px" }}>
          <p style={{ margin: "0 0 16px 0", fontSize: "0.8125rem", color: "#94a3b8", lineHeight: 1.4 }}>
            Select the device station code for this tablet. Each captain on the floor should operate on a distinct station (e.g. <code>cp1</code>, <code>cp2</code>, <code>cp3</code>, <code>cp4</code>).
          </p>

          {/* Current Selection Banner */}
          <div
            style={{
              background: "#0f172a",
              border: "1px solid #334155",
              borderRadius: "10px",
              padding: "10px 14px",
              marginBottom: "16px",
              display: "flex",
              alignItems: "center",
              justifyContent: "space-between",
            }}
          >
            <div style={{ fontSize: "0.75rem", color: "#94a3b8" }}>
              Active Terminal Code:
            </div>
            <div style={{ display: "flex", alignItems: "center", gap: "8px" }}>
              <span
                style={{
                  backgroundColor: "rgba(245, 158, 11, 0.2)",
                  color: "#fbbf24",
                  fontWeight: 800,
                  fontSize: "0.875rem",
                  padding: "3px 10px",
                  borderRadius: "6px",
                  border: "1px solid rgba(245, 158, 11, 0.3)",
                }}
              >
                {isCustomMode && customCode ? customCode.trim().toLowerCase() : selected}
              </span>
              {autoStation && selected === autoStation && (
                <span
                  style={{
                    fontSize: "0.6875rem",
                    backgroundColor: "rgba(34, 197, 94, 0.2)",
                    color: "#4ade80",
                    padding: "2px 6px",
                    borderRadius: "4px",
                    fontWeight: 600,
                  }}
                >
                  Auto-Assigned
                </span>
              )}
            </div>
          </div>

          {/* Station Selection Grid */}
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "10px", marginBottom: "16px" }}>
            {PRESET_STATIONS.map((st) => {
              const isSelected = !isCustomMode && selected === st.id;
              const isAuto = autoStation === st.id;
              return (
                <button
                  key={st.id}
                  type="button"
                  onClick={() => handleSelect(st.id)}
                  style={{
                    textAlign: "left",
                    padding: "10px 12px",
                    borderRadius: "10px",
                    border: isSelected ? "2px solid #3b82f6" : "1px solid #334155",
                    backgroundColor: isSelected ? "rgba(59, 130, 246, 0.15)" : "#0f172a",
                    cursor: "pointer",
                    transition: "all 0.15s ease",
                  }}
                >
                  <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: "2px" }}>
                    <span
                      style={{
                        fontWeight: 700,
                        fontSize: "0.875rem",
                        color: isSelected ? "#60a5fa" : "#f1f5f9",
                      }}
                    >
                      {st.id}
                    </span>
                    {isAuto && (
                      <span
                        style={{
                          fontSize: "0.625rem",
                          backgroundColor: "#166534",
                          color: "#86efac",
                          padding: "1px 5px",
                          borderRadius: "4px",
                          fontWeight: 600,
                        }}
                      >
                        Default
                      </span>
                    )}
                  </div>
                  <div style={{ fontSize: "0.6875rem", color: "#64748b" }}>
                    {st.description}
                  </div>
                </button>
              );
            })}
          </div>

          {/* Custom Station Option */}
          <div style={{ marginBottom: "16px" }}>
            <button
              type="button"
              onClick={() => setIsCustomMode(!isCustomMode)}
              style={{
                background: "none",
                border: "none",
                color: "#38bdf8",
                fontSize: "0.75rem",
                fontWeight: 600,
                cursor: "pointer",
                padding: "4px 0",
                display: "flex",
                alignItems: "center",
                gap: "4px",
              }}
            >
              <span>{isCustomMode ? "− Hide custom code" : "+ Custom station identifier"}</span>
            </button>
            {isCustomMode && (
              <div style={{ marginTop: "8px" }}>
                <input
                  type="text"
                  value={customCode}
                  onChange={(e) => setCustomCode(e.target.value)}
                  placeholder="e.g. cp7, bar1, terrace"
                  style={{
                    width: "100%",
                    boxSizing: "border-box",
                    backgroundColor: "#0f172a",
                    border: "1px solid #475569",
                    borderRadius: "8px",
                    color: "#f8fafc",
                    padding: "8px 12px",
                    fontSize: "0.875rem",
                    outline: "none",
                  }}
                />
              </div>
            )}
          </div>
        </div>

        {/* Footer Actions */}
        <div
          style={{
            padding: "14px 20px",
            borderTop: "1px solid #334155",
            display: "flex",
            alignItems: "center",
            justifyContent: "space-between",
            backgroundColor: "#0f172a",
          }}
        >
          {autoStation && (
            <button
              type="button"
              onClick={handleResetToAuto}
              style={{
                background: "transparent",
                border: "1px solid #475569",
                borderRadius: "8px",
                color: "#94a3b8",
                fontSize: "0.75rem",
                fontWeight: 600,
                padding: "8px 12px",
                cursor: "pointer",
              }}
              title={`Reset to profile default (${autoStation})`}
            >
              Reset to Auto ({autoStation})
            </button>
          )}
          <div style={{ display: "flex", gap: "8px", marginLeft: "auto" }}>
            <button
              type="button"
              onClick={onClose}
              style={{
                background: "#334155",
                border: "none",
                borderRadius: "8px",
                color: "#cbd5e1",
                fontSize: "0.8125rem",
                fontWeight: 600,
                padding: "8px 16px",
                cursor: "pointer",
              }}
            >
              Cancel
            </button>
            <button
              type="button"
              onClick={handleSave}
              style={{
                background: "#2563eb",
                border: "none",
                borderRadius: "8px",
                color: "#ffffff",
                fontSize: "0.8125rem",
                fontWeight: 700,
                padding: "8px 18px",
                cursor: "pointer",
                boxShadow: "0 2px 4px rgba(37, 99, 235, 0.4)",
              }}
            >
              Apply Station
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
