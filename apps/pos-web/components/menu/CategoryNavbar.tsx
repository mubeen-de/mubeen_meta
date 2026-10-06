import React from "react";
import { getCategoryEmoji } from "./AttractiveMenuItemCard";

export type DietaryFilter = "ALL" | "VEG_ONLY" | "NON_VEG_ONLY" | "BESTSELLERS_ONLY";

interface CategoryNavbarProps {
  categories: string[];
  selectedCategory: string;
  onSelectCategory: (category: string) => void;
  dietaryFilter: DietaryFilter;
  onChangeDietaryFilter: (filter: DietaryFilter) => void;
  searchQuery: string;
  onSearchChange: (query: string) => void;
  categoryItemCounts?: Record<string, number>;
  layout?: "horizontal" | "vertical";
}

export default function CategoryNavbar({
  categories,
  selectedCategory,
  onSelectCategory,
  dietaryFilter,
  onChangeDietaryFilter,
  searchQuery,
  onSearchChange,
  categoryItemCounts,
  layout = "horizontal",
}: CategoryNavbarProps) {
  return (
    <div className={`category-nav-container layout-${layout}`}>
      {/* Search & Dietary Filters Row */}
      <div className="search-filter-toolbar">
        <div className="search-input-wrapper">
          <span className="search-icon">🔍</span>
          <input
            type="text"
            placeholder="Search items by name, code, or category..."
            value={searchQuery}
            onChange={(e) => onSearchChange(e.target.value)}
            className="search-field"
          />
          {searchQuery && (
            <button
              type="button"
              className="clear-search-btn"
              onClick={() => onSearchChange("")}
            >
              ✕
            </button>
          )}
        </div>

        {/* Dietary Quick Filter Pills */}
        <div className="dietary-pills-row">
          <button
            type="button"
            className={`dietary-pill ${dietaryFilter === "ALL" ? "active" : ""}`}
            onClick={() => onChangeDietaryFilter("ALL")}
          >
            All
          </button>
          <button
            type="button"
            className={`dietary-pill veg-pill ${dietaryFilter === "VEG_ONLY" ? "active" : ""}`}
            onClick={() => onChangeDietaryFilter("VEG_ONLY")}
          >
            <span className="pill-dot veg">●</span> Pure Veg
          </button>
          <button
            type="button"
            className={`dietary-pill non-veg-pill ${dietaryFilter === "NON_VEG_ONLY" ? "active" : ""}`}
            onClick={() => onChangeDietaryFilter("NON_VEG_ONLY")}
          >
            <span className="pill-dot non-veg">●</span> Non-Veg
          </button>
          <button
            type="button"
            className={`dietary-pill star-pill ${dietaryFilter === "BESTSELLERS_ONLY" ? "active" : ""}`}
            onClick={() => onChangeDietaryFilter("BESTSELLERS_ONLY")}
          >
            ⭐ Bestsellers
          </button>
        </div>
      </div>

      {/* Category List / Scrollbar */}
      <div className="categories-list-box">
        {layout === "vertical" && <div className="vertical-header">Categories</div>}
        <div className={`categories-scroll ${layout}`}>
          {categories.map((cat) => {
            const isSelected = selectedCategory === cat;
            const emoji = cat === "All" ? "🍽️" : getCategoryEmoji(cat);
            const count = categoryItemCounts ? categoryItemCounts[cat] : null;

            return (
              <button
                key={cat}
                type="button"
                className={`category-chip-btn ${isSelected ? "active" : ""}`}
                onClick={() => onSelectCategory(cat)}
              >
                <span className="cat-emoji">{emoji}</span>
                <span className="cat-name">{cat}</span>
                {count !== null && count !== undefined && (
                  <span className="cat-count-badge">{count}</span>
                )}
              </button>
            );
          })}
        </div>
      </div>

      <style jsx>{`
        .category-nav-container {
          display: flex;
          flex-direction: column;
          gap: 10px;
          font-family: inherit;
        }

        .search-filter-toolbar {
          display: flex;
          flex-direction: column;
          gap: 8px;
        }

        .search-input-wrapper {
          position: relative;
          display: flex;
          align-items: center;
          background: var(--bg-subtle, #070d1e);
          border: 1.5px solid var(--border-strong, #334155);
          border-radius: 10px;
          padding: 0 12px;
          box-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);
        }
        .search-input-wrapper:focus-within {
          border-color: #3b82f6;
          box-shadow: 0 0 0 2px rgba(59, 130, 246, 0.25);
        }
        .search-icon {
          font-size: 0.875rem;
          color: var(--text-secondary, #94a3b8);
          margin-right: 8px;
        }
        .search-field {
          flex: 1;
          border: none;
          outline: none;
          padding: 9px 0;
          font-size: 0.875rem;
          font-weight: 500;
          color: var(--text-primary, #f8fafc);
          background: transparent;
        }
        .clear-search-btn {
          background: transparent;
          border: none;
          color: var(--text-muted, #64748b);
          font-size: 0.875rem;
          cursor: pointer;
          padding: 4px;
        }
        .clear-search-btn:hover {
          color: var(--text-primary, #f8fafc);
        }

        .dietary-pills-row {
          display: flex;
          align-items: center;
          gap: 6px;
          overflow-x: auto;
          padding-bottom: 2px;
        }
        .dietary-pill {
          background: var(--bg-elevated, #1e293b);
          border: 1px solid var(--border, #1e293b);
          padding: 4px 10px;
          border-radius: 999px;
          font-size: 0.6875rem;
          font-weight: 700;
          color: var(--text-secondary, #94a3b8);
          cursor: pointer;
          white-space: nowrap;
          display: flex;
          align-items: center;
          gap: 4px;
          transition: all 0.15s;
        }
        .dietary-pill:hover {
          background: var(--bg-card, #111c38);
          color: var(--text-primary, #f8fafc);
        }
        .dietary-pill.active {
          background: #2563eb;
          color: #ffffff;
          border-color: #3b82f6;
        }
        .veg-pill.active {
          background: #16a34a;
          color: #ffffff;
          border-color: #16a34a;
        }
        .non-veg-pill.active {
          background: #dc2626;
          color: #ffffff;
          border-color: #dc2626;
        }
        .star-pill.active {
          background: #d97706;
          color: #ffffff;
          border-color: #d97706;
        }
        .pill-dot {
          font-size: 0.625rem;
        }
        .pill-dot.veg { color: #16a34a; }
        .pill-dot.non-veg { color: #dc2626; }
        .dietary-pill.active .pill-dot { color: #ffffff; }

        .categories-list-box {
          display: flex;
          flex-direction: column;
        }
        .vertical-header {
          font-size: 0.6875rem;
          font-weight: 800;
          text-transform: uppercase;
          color: var(--text-muted, #64748b);
          padding: 6px 8px;
          letter-spacing: 0.5px;
        }

        .categories-scroll.horizontal {
          display: flex;
          gap: 8px;
          overflow-x: auto;
          padding-bottom: 6px;
        }

        .categories-scroll.vertical {
          display: flex;
          flex-direction: column;
          gap: 4px;
          overflow-y: auto;
        }

        .category-chip-btn {
          display: flex;
          align-items: center;
          gap: 8px;
          padding: 8px 12px;
          background: var(--bg-card, #111c38);
          border: 1px solid var(--border, #1e293b);
          border-radius: 10px;
          font-size: 0.8125rem;
          font-weight: 700;
          color: var(--text-secondary, #94a3b8);
          cursor: pointer;
          white-space: nowrap;
          text-align: left;
          transition: all 0.15s;
        }
        .category-chip-btn:hover {
          background: var(--bg-elevated, #1e293b);
          color: var(--text-primary, #f8fafc);
        }
        .category-chip-btn.active {
          background: var(--btn-primary-bg, #2563eb);
          color: #ffffff;
          border-color: var(--btn-primary-bg, #2563eb);
          box-shadow: 0 2px 6px rgba(37, 99, 235, 0.3);
        }
        .cat-emoji {
          font-size: 1rem;
        }
        .cat-name {
          flex: 1;
        }
        .cat-count-badge {
          background: rgba(255, 255, 255, 0.12);
          color: var(--text-secondary, #94a3b8);
          font-size: 0.6875rem;
          padding: 1px 6px;
          border-radius: 999px;
          font-weight: 800;
        }
        .category-chip-btn.active .cat-count-badge {
          background: rgba(255, 255, 255, 0.25);
          color: #ffffff;
        }
      `}</style>
    </div>
  );
}
