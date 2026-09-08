import React, { useState, useEffect } from "react";

export interface OrderCommentsModalProps {
  isOpen: boolean;
  onClose: () => void;
  initialComment?: string;
  onSave: (comment: string) => void;
}

export default function OrderCommentsModal({
  isOpen,
  onClose,
  initialComment = "",
  onSave,
}: OrderCommentsModalProps) {
  const [comment, setComment] = useState(initialComment);

  useEffect(() => {
    setComment(initialComment);
  }, [initialComment, isOpen]);

  if (!isOpen) return null;

  const handleSave = (e: React.FormEvent) => {
    e.preventDefault();
    onSave(comment.trim());
    onClose();
  };

  return (
    <div className="petpooja-modal-overlay" onClick={onClose}>
      <div
        className="petpooja-modal-container"
        style={{ width: "500px", maxWidth: "95vw" }}
        onClick={(e) => e.stopPropagation()}
      >
        {/* Header */}
        <div className="petpooja-modal-header">
          <h3 style={{ margin: 0, fontSize: "16px", fontWeight: 600, color: "#1e293b" }}>
            Order Wise Comments
          </h3>
          <button
            type="button"
            className="petpooja-close-btn"
            onClick={onClose}
            aria-label="Close"
          >
            ✕
          </button>
        </div>

        {/* Form Body */}
        <form onSubmit={handleSave}>
          <div style={{ padding: "18px 22px" }}>
            <label
              htmlFor="order-comment-input"
              style={{
                display: "block",
                marginBottom: "8px",
                fontSize: "13px",
                fontWeight: 600,
                color: "#334155",
              }}
            >
              Comment:
            </label>
            <textarea
              id="order-comment-input"
              rows={5}
              value={comment}
              onChange={(e) => setComment(e.target.value)}
              placeholder="e.g. Less spicy, pack extra sambar, fast delivery..."
              style={{
                width: "100%",
                padding: "10px 12px",
                fontSize: "14px",
                border: "1px solid #cbd5e1",
                borderRadius: "6px",
                outline: "none",
                resize: "vertical",
                fontFamily: "inherit",
                boxSizing: "border-box",
              }}
              autoFocus
            />
          </div>

          {/* Footer Actions */}
          <div
            style={{
              display: "flex",
              justifyContent: "flex-end",
              gap: "10px",
              padding: "12px 22px 18px",
              borderTop: "1px solid #f1f5f9",
            }}
          >
            <button
              type="button"
              onClick={onClose}
              style={{
                padding: "7px 20px",
                backgroundColor: "#fff",
                border: "1px solid #cbd5e1",
                borderRadius: "4px",
                fontSize: "13px",
                fontWeight: 600,
                color: "#475569",
                cursor: "pointer",
              }}
            >
              Cancel
            </button>
            <button
              type="submit"
              style={{
                padding: "7px 24px",
                backgroundColor: "#b91c1c",
                border: "none",
                borderRadius: "4px",
                fontSize: "13px",
                fontWeight: 600,
                color: "#ffffff",
                cursor: "pointer",
              }}
            >
              Save
            </button>
          </div>
        </form>
      </div>

      <style jsx>{`
        .petpooja-modal-overlay {
          position: fixed;
          top: 0;
          left: 0;
          right: 0;
          bottom: 0;
          background: rgba(15, 23, 42, 0.45);
          display: flex;
          align-items: center;
          justify-content: center;
          z-index: 9999;
          backdrop-filter: blur(1px);
        }
        .petpooja-modal-container {
          background: #ffffff;
          border-radius: 8px;
          box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.2);
          overflow: hidden;
          animation: modalPop 0.15s ease-out;
        }
        .petpooja-modal-header {
          display: flex;
          justify-content: space-between;
          align-items: center;
          padding: 14px 22px;
          border-bottom: 1px solid #f1f5f9;
        }
        .petpooja-close-btn {
          background: transparent;
          border: none;
          font-size: 16px;
          color: #94a3b8;
          cursor: pointer;
          padding: 2px 6px;
        }
        .petpooja-close-btn:hover {
          color: #1e293b;
        }
        @keyframes modalPop {
          from {
            opacity: 0;
            transform: scale(0.97);
          }
          to {
            opacity: 1;
            transform: scale(1);
          }
        }
      `}</style>
    </div>
  );
}
