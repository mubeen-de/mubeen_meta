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
          <h3 style={{ margin: 0, fontSize: "16px", fontWeight: 600, color: "var(--text-primary, #f8fafc)" }}>
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
                color: "var(--text-secondary, #94a3b8)",
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
                border: "1px solid var(--border-strong, #334155)",
                background: "var(--bg-subtle, #070d1e)",
                color: "var(--text-primary, #f8fafc)",
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
              borderTop: "1px solid var(--border, #1e293b)",
              background: "var(--bg-subtle, #070d1e)",
            }}
          >
            <button
              type="button"
              onClick={onClose}
              style={{
                padding: "7px 20px",
                backgroundColor: "var(--btn-cancel-bg, #334155)",
                border: "1px solid var(--btn-cancel-border, #475569)",
                borderRadius: "6px",
                fontSize: "13px",
                fontWeight: 600,
                color: "var(--btn-cancel-text, #cbd5e1)",
                cursor: "pointer",
              }}
            >
              Cancel
            </button>
            <button
              type="submit"
              style={{
                padding: "7px 24px",
                backgroundColor: "var(--btn-primary-bg, #2563eb)",
                border: "1px solid var(--btn-primary-border, #3b82f6)",
                borderRadius: "6px",
                fontSize: "13px",
                fontWeight: 600,
                color: "var(--btn-primary-text, #ffffff)",
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
          background: rgba(11, 19, 43, 0.8);
          display: flex;
          align-items: center;
          justify-content: center;
          z-index: 9999;
          backdrop-filter: blur(4px);
        }
        .petpooja-modal-container {
          background: var(--bg-card, #111c38);
          border: 1px solid var(--border-strong, #334155);
          color: var(--text-primary, #f8fafc);
          border-radius: 8px;
          box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.5);
          overflow: hidden;
          animation: modalPop 0.15s ease-out;
        }
        .petpooja-modal-header {
          display: flex;
          justify-content: space-between;
          align-items: center;
          padding: 14px 22px;
          border-bottom: 1px solid var(--border, #1e293b);
          background: var(--bg-subtle, #070d1e);
        }
        .petpooja-close-btn {
          background: transparent;
          border: none;
          font-size: 16px;
          color: var(--text-secondary, #94a3b8);
          cursor: pointer;
          padding: 2px 6px;
        }
        .petpooja-close-btn:hover {
          color: #ffffff;
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
