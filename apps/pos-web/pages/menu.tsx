// Dedicated Menu Management console. Real category + item CRUD against
// apps/api/src/routes/menu.ts (GET/POST /menu/categories, GET /menu/items,
// GET /menu/categories/:id/items, POST /menu/items). No hardcoded catalog
// data per repo CLAUDE.md — everything below comes from those endpoints.
// The "Add Category"/"Add Menu Item" logic here mirrors the working modal
// handlers in pages/index.tsx (same authedFetch calls, same field names)
// but lives on its own page instead of being buried in the POS terminal.
import React, { useEffect, useMemo, useRef, useState } from "react";
import Head from "next/head";
import { authedFetch, useAuthGuard } from "../lib/auth";
import Nav from "../components/Nav";

interface Category {
  id: string;
  outletId: string;
  name: string;
  description: string | null;
  sortOrder: number;
  isActive: boolean;
}

interface MenuItemRow {
  id: string;
  outletId: string;
  categoryId: string;
  name: string;
  description: string | null;
  shortCode?: string | null;
  onlineDisplayName?: string | null;
  priceMinor: string; // Dine-In base price (paise)
  parcelPriceMinor?: string | null;
  parcelAvailable?: boolean;
  zomatoPriceMinor?: string | null;
  zomatoAvailable?: boolean;
  swiggyPriceMinor?: string | null;
  swiggyAvailable?: boolean;
  isVeg: boolean;
  taxRate: string;
  isActive: boolean;
  imageUrl?: string | null;
  availability: { isStocked: boolean; stockQty: number; version: number } | null;
}

function formatPriceMinor(priceMinor?: string | null): string {
  if (priceMinor == null || priceMinor === "") return "—";
  const rupees = Number(BigInt(priceMinor)) / 100;
  return `₹${rupees.toFixed(2)}`;
}

export default function MenuManagement() {
  const { me, loading: authLoading } = useAuthGuard("menu.category.manage");

  const [categories, setCategories] = useState<Category[]>([]);
  const [itemsByCategory, setItemsByCategory] = useState<Record<string, MenuItemRow[]>>({});
  const [loading, setLoading] = useState(true);
  const [loadError, setLoadError] = useState<string | null>(null);
  const [expandedCategoryId, setExpandedCategoryId] = useState<string | null>(null);
  const [toastMessage, setToastMessage] = useState<string | null>(null);

  const [isAddCategoryOpen, setIsAddCategoryOpen] = useState(false);
  const [newCategoryName, setNewCategoryName] = useState("");
  const [newCategoryDescription, setNewCategoryDescription] = useState("");
  const [savingCategory, setSavingCategory] = useState(false);

  const [isAddItemOpen, setIsAddItemOpen] = useState(false);
  const [newItemCategoryId, setNewItemCategoryId] = useState("");
  const [newItemName, setNewItemName] = useState("");
  const [newItemShortCode, setNewItemShortCode] = useState("");
  const [newItemDescription, setNewItemDescription] = useState("");
  const [newItemPrice, setNewItemPrice] = useState("");
  const [newItemParcelPrice, setNewItemParcelPrice] = useState("");
  const [newItemParcelAvailable, setNewItemParcelAvailable] = useState(true);
  const [newItemZomatoPrice, setNewItemZomatoPrice] = useState("");
  const [newItemZomatoAvailable, setNewItemZomatoAvailable] = useState(true);
  const [newItemSwiggyPrice, setNewItemSwiggyPrice] = useState("");
  const [newItemSwiggyAvailable, setNewItemSwiggyAvailable] = useState(true);
  const [newItemIsVeg, setNewItemIsVeg] = useState(true);
  const [newItemTaxRate, setNewItemTaxRate] = useState("5");
  const [newItemImageUrl, setNewItemImageUrl] = useState("");
  const [showAddUrlInput, setShowAddUrlInput] = useState(false);
  const [isAddDragging, setIsAddDragging] = useState(false);
  const addItemFileInputRef = useRef<HTMLInputElement>(null);
  const [savingItem, setSavingItem] = useState(false);

  const [isEditItemOpen, setIsEditItemOpen] = useState(false);
  const [editItemId, setEditItemId] = useState("");
  const [editItemCategoryId, setEditItemCategoryId] = useState("");
  const [editItemName, setEditItemName] = useState("");
  const [editItemShortCode, setEditItemShortCode] = useState("");
  const [editItemDescription, setEditItemDescription] = useState("");
  const [editItemPrice, setEditItemPrice] = useState("");
  const [editItemParcelPrice, setEditItemParcelPrice] = useState("");
  const [editItemParcelAvailable, setEditItemParcelAvailable] = useState(true);
  const [editItemZomatoPrice, setEditItemZomatoPrice] = useState("");
  const [editItemZomatoAvailable, setEditItemZomatoAvailable] = useState(true);
  const [editItemSwiggyPrice, setEditItemSwiggyPrice] = useState("");
  const [editItemSwiggyAvailable, setEditItemSwiggyAvailable] = useState(true);
  const [editItemIsVeg, setEditItemIsVeg] = useState(true);
  const [editItemTaxRate, setEditItemTaxRate] = useState("5");
  const [editItemImageUrl, setEditItemImageUrl] = useState("");
  const [showEditUrlInput, setShowEditUrlInput] = useState(false);
  const [isEditDragging, setIsEditDragging] = useState(false);
  const editItemFileInputRef = useRef<HTMLInputElement>(null);
  const [savingEditItem, setSavingEditItem] = useState(false);

  const [isEditCategoryOpen, setIsEditCategoryOpen] = useState(false);
  const [editCategoryId, setEditCategoryId] = useState("");
  const [editCategoryName, setEditCategoryName] = useState("");
  const [editCategoryDescription, setEditCategoryDescription] = useState("");
  const [savingEditCategory, setSavingEditCategory] = useState(false);

  const [togglingItemId, setTogglingItemId] = useState<string | null>(null);
  const [deletingItemId, setDeletingItemId] = useState<string | null>(null);
  const [deletingCategoryId, setDeletingCategoryId] = useState<string | null>(null);

  const [isBulkImportOpen, setIsBulkImportOpen] = useState(false);
  const [bulkCsvText, setBulkCsvText] = useState("");
  const [isImporting, setIsImporting] = useState(false);
  const [bulkImportResult, setBulkImportResult] = useState<{
    success?: boolean;
    totalProcessed: number;
    categoriesCreated: number;
    itemsCreated: number;
    itemsUpdated: number;
    errors: string[];
  } | null>(null);

  const showToast = (msg: string) => {
    setToastMessage(msg);
    setTimeout(() => setToastMessage(null), 3500);
  };

  const processImageFile = (file: File, setImage: (url: string) => void) => {
    if (!file.type.startsWith("image/")) {
      showToast("⚠️ Please select a valid image file (PNG, JPG, WebP)");
      return;
    }
    if (file.size > 10 * 1024 * 1024) {
      showToast("⚠️ Image is too large. Please select an image under 10MB");
      return;
    }

    const reader = new FileReader();
    reader.onload = (e) => {
      const rawDataUrl = e.target?.result as string;
      const img = new Image();
      img.onload = () => {
        try {
          const maxDim = 800;
          let { width, height } = img;
          if (width > maxDim || height > maxDim) {
            if (width > height) {
              height = Math.round((height * maxDim) / width);
              width = maxDim;
            } else {
              width = Math.round((width * maxDim) / height);
              height = maxDim;
            }
          }
          const canvas = document.createElement("canvas");
          canvas.width = width;
          canvas.height = height;
          const ctx = canvas.getContext("2d");
          if (ctx) {
            ctx.drawImage(img, 0, 0, width, height);
            const optimized = canvas.toDataURL("image/jpeg", 0.85);
            setImage(optimized);
          } else {
            setImage(rawDataUrl);
          }
        } catch {
          setImage(rawDataUrl);
        }
      };
      img.onerror = () => {
        setImage(rawDataUrl);
      };
      img.src = rawDataUrl;
    };
    reader.readAsDataURL(file);
  };

  const fetchCategoriesAndItems = () => {
    setLoading(true);
    setLoadError(null);
    authedFetch("/menu/categories")
      .then((res) => {
        if (!res.ok) throw new Error("HTTP error " + res.status);
        return res.json();
      })
      .then(async (cats: Category[]) => {
        setCategories(Array.isArray(cats) ? cats : []);
        const entries = await Promise.all(
          (Array.isArray(cats) ? cats : []).map(async (cat) => {
            const itemsRes = await authedFetch(`/menu/categories/${cat.id}/items`);
            if (itemsRes.ok) {
              const items = await itemsRes.json();
              return [cat.id, Array.isArray(items) ? items : []] as const;
            }
            return [cat.id, []] as const;
          })
        );
        setItemsByCategory(Object.fromEntries(entries));
      })
      .catch((err) => {
        setLoadError(err instanceof Error ? err.message : "Failed to load categories");
      })
      .finally(() => setLoading(false));
  };

  useEffect(() => {
    if (authLoading) return;
    fetchCategoriesAndItems();
  }, [authLoading]);

  const totalItems = useMemo(
    () => Object.values(itemsByCategory).reduce((sum, list) => sum + list.length, 0),
    [itemsByCategory]
  );

  const handleAddCategory = async (e: React.FormEvent) => {
    e.preventDefault();
    const trimmed = newCategoryName.trim();
    if (!trimmed) {
      showToast("⚠️ Category name cannot be empty");
      return;
    }
    setSavingCategory(true);
    try {
      const res = await authedFetch("/menu/categories", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          name: trimmed,
          description: newCategoryDescription.trim() || undefined,
        }),
      });
      if (!res.ok) {
        const data = await res.json().catch(() => ({}));
        throw new Error(data.error || "Failed to create category");
      }
      setIsAddCategoryOpen(false);
      setNewCategoryName("");
      setNewCategoryDescription("");
      showToast(`✅ Category "${trimmed}" created`);
      fetchCategoriesAndItems();
    } catch (err: any) {
      showToast(`❌ Error: ${err.message}`);
    } finally {
      setSavingCategory(false);
    }
  };

  const openAddItem = (categoryId?: string) => {
    setNewItemCategoryId(categoryId || categories[0]?.id || "");
    setNewItemName("");
    setNewItemShortCode("");
    setNewItemDescription("");
    setNewItemPrice("");
    setNewItemParcelPrice("");
    setNewItemParcelAvailable(true);
    setNewItemZomatoPrice("");
    setNewItemZomatoAvailable(true);
    setNewItemSwiggyPrice("");
    setNewItemSwiggyAvailable(true);
    setNewItemIsVeg(true);
    setNewItemTaxRate("5");
    setNewItemImageUrl("");
    setShowAddUrlInput(false);
    setIsAddDragging(false);
    setIsAddItemOpen(true);
  };

  const handleAddItem = async (e: React.FormEvent) => {
    e.preventDefault();
    const nameTrimmed = newItemName.trim();
    const priceNum = parseFloat(newItemPrice);
    const parcelNum = parseFloat(newItemParcelPrice);
    const zomatoNum = parseFloat(newItemZomatoPrice);
    const swiggyNum = parseFloat(newItemSwiggyPrice);
    const taxNum = parseFloat(newItemTaxRate);

    if (!newItemCategoryId) {
      showToast("⚠️ Please select a category");
      return;
    }
    if (!nameTrimmed) {
      showToast("⚠️ Item name is required");
      return;
    }
    if (isNaN(priceNum) || priceNum < 0) {
      showToast("⚠️ Please enter a valid Dine-In price in Rupees");
      return;
    }

    setSavingItem(true);
    try {
      const res = await authedFetch("/menu/items", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          categoryId: newItemCategoryId,
          name: nameTrimmed,
          shortCode: newItemShortCode.trim() || undefined,
          description: newItemDescription.trim() || undefined,
          priceMinor: Math.round(priceNum * 100),
          parcelPriceMinor: !isNaN(parcelNum) ? Math.round(parcelNum * 100) : Math.round(priceNum * 100),
          parcelAvailable: newItemParcelAvailable,
          zomatoPriceMinor: !isNaN(zomatoNum) ? Math.round(zomatoNum * 100) : Math.round(priceNum * 100),
          zomatoAvailable: newItemZomatoAvailable,
          swiggyPriceMinor: !isNaN(swiggyNum) ? Math.round(swiggyNum * 100) : Math.round(priceNum * 100),
          swiggyAvailable: newItemSwiggyAvailable,
          isVeg: newItemIsVeg,
          taxRate: isNaN(taxNum) ? undefined : taxNum,
          imageUrl: newItemImageUrl.trim() || undefined,
        }),
      });
      if (!res.ok) {
        const data = await res.json().catch(() => ({}));
        throw new Error(data.error || "Failed to create menu item");
      }
      setIsAddItemOpen(false);
      showToast(`✅ Dish "${nameTrimmed}" created`);
      fetchCategoriesAndItems();
    } catch (err: any) {
      showToast(`❌ Error: ${err.message}`);
    } finally {
      setSavingItem(false);
    }
  };

  const openEditItem = (item: MenuItemRow) => {
    const baseStr = (Number(BigInt(item.priceMinor)) / 100).toString();
    setEditItemId(item.id);
    setEditItemCategoryId(item.categoryId);
    setEditItemName(item.name);
    setEditItemShortCode(item.shortCode || "");
    setEditItemDescription(item.description || "");
    setEditItemPrice(baseStr);
    setEditItemParcelPrice(
      item.parcelPriceMinor != null ? (Number(BigInt(item.parcelPriceMinor)) / 100).toString() : baseStr
    );
    setEditItemParcelAvailable(item.parcelAvailable ?? true);
    setEditItemZomatoPrice(
      item.zomatoPriceMinor != null ? (Number(BigInt(item.zomatoPriceMinor)) / 100).toString() : baseStr
    );
    setEditItemZomatoAvailable(item.zomatoAvailable ?? true);
    setEditItemSwiggyPrice(
      item.swiggyPriceMinor != null ? (Number(BigInt(item.swiggyPriceMinor)) / 100).toString() : baseStr
    );
    setEditItemSwiggyAvailable(item.swiggyAvailable ?? true);
    setEditItemIsVeg(item.isVeg);
    setEditItemTaxRate(item.taxRate);
    setEditItemImageUrl(item.imageUrl || "");
    setShowEditUrlInput(Boolean(item.imageUrl && item.imageUrl.startsWith("http")));
    setIsEditDragging(false);
    setIsEditItemOpen(true);
  };

  const handleEditItem = async (e: React.FormEvent) => {
    e.preventDefault();
    const nameTrimmed = editItemName.trim();
    const priceNum = parseFloat(editItemPrice);
    const parcelNum = parseFloat(editItemParcelPrice);
    const zomatoNum = parseFloat(editItemZomatoPrice);
    const swiggyNum = parseFloat(editItemSwiggyPrice);
    const taxNum = parseFloat(editItemTaxRate);

    if (!nameTrimmed) {
      showToast("⚠️ Item name is required");
      return;
    }
    if (isNaN(priceNum) || priceNum < 0) {
      showToast("⚠️ Please enter a valid Dine-In price in Rupees");
      return;
    }

    setSavingEditItem(true);
    try {
      const res = await authedFetch(`/menu/items/${editItemId}`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          categoryId: editItemCategoryId,
          name: nameTrimmed,
          shortCode: editItemShortCode.trim() || null,
          description: editItemDescription.trim() || undefined,
          priceMinor: Math.round(priceNum * 100),
          parcelPriceMinor: !isNaN(parcelNum) ? Math.round(parcelNum * 100) : Math.round(priceNum * 100),
          parcelAvailable: editItemParcelAvailable,
          zomatoPriceMinor: !isNaN(zomatoNum) ? Math.round(zomatoNum * 100) : Math.round(priceNum * 100),
          zomatoAvailable: editItemZomatoAvailable,
          swiggyPriceMinor: !isNaN(swiggyNum) ? Math.round(swiggyNum * 100) : Math.round(priceNum * 100),
          swiggyAvailable: editItemSwiggyAvailable,
          isVeg: editItemIsVeg,
          taxRate: isNaN(taxNum) ? undefined : taxNum,
          imageUrl: editItemImageUrl.trim() || null,
        }),
      });
      if (!res.ok) {
        const data = await res.json().catch(() => ({}));
        throw new Error(data.error || "Failed to update menu item");
      }
      setIsEditItemOpen(false);
      showToast(`✅ Dish "${nameTrimmed}" updated`);
      fetchCategoriesAndItems();
    } catch (err: any) {
      showToast(`❌ Error: ${err.message}`);
    } finally {
      setSavingEditItem(false);
    }
  };

  const handleDeleteItem = async (item: MenuItemRow) => {
    if (!window.confirm(`Delete "${item.name}"? This cannot be undone.`)) return;
    setDeletingItemId(item.id);
    try {
      const res = await authedFetch(`/menu/items/${item.id}`, { method: "DELETE" });
      if (!res.ok && res.status !== 204) {
        const data = await res.json().catch(() => ({}));
        throw new Error(data.error || "Failed to delete menu item");
      }
      showToast(`✅ Dish "${item.name}" deleted`);
      fetchCategoriesAndItems();
    } catch (err: any) {
      showToast(`❌ Error: ${err.message}`);
    } finally {
      setDeletingItemId(null);
    }
  };

  const handleToggleAvailability = async (item: MenuItemRow) => {
    const nextStocked = !item.isActive;
    setTogglingItemId(item.id);
    try {
      const res = await authedFetch(`/menu/items/${item.id}/availability`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          isStocked: nextStocked,
          expectedVersion: item.availability?.version,
        }),
      });
      if (!res.ok) {
        const data = await res.json().catch(() => ({}));
        throw new Error(data.error || "Failed to update availability");
      }
      showToast(`✅ "${item.name}" marked ${nextStocked ? "Active" : "Inactive"}`);
      fetchCategoriesAndItems();
    } catch (err: any) {
      showToast(`❌ Error: ${err.message}`);
    } finally {
      setTogglingItemId(null);
    }
  };

  const openEditCategory = (cat: Category) => {
    setEditCategoryId(cat.id);
    setEditCategoryName(cat.name);
    setEditCategoryDescription(cat.description || "");
    setIsEditCategoryOpen(true);
  };

  const handleEditCategory = async (e: React.FormEvent) => {
    e.preventDefault();
    const trimmed = editCategoryName.trim();
    if (!trimmed) {
      showToast("⚠️ Category name cannot be empty");
      return;
    }
    setSavingEditCategory(true);
    try {
      const res = await authedFetch(`/menu/categories/${editCategoryId}`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          name: trimmed,
          description: editCategoryDescription.trim() || undefined,
        }),
      });
      if (!res.ok) {
        const data = await res.json().catch(() => ({}));
        throw new Error(data.error || "Failed to update category");
      }
      setIsEditCategoryOpen(false);
      showToast(`✅ Category "${trimmed}" updated`);
      fetchCategoriesAndItems();
    } catch (err: any) {
      showToast(`❌ Error: ${err.message}`);
    } finally {
      setSavingEditCategory(false);
    }
  };

  const handleDeleteCategory = async (cat: Category) => {
    if (!window.confirm(`Delete category "${cat.name}"? Items in it will remain but the category will be hidden.`)) return;
    setDeletingCategoryId(cat.id);
    try {
      const res = await authedFetch(`/menu/categories/${cat.id}`, { method: "DELETE" });
      if (!res.ok && res.status !== 204) {
        const data = await res.json().catch(() => ({}));
        throw new Error(data.error || "Failed to delete category");
      }
      showToast(`✅ Category "${cat.name}" deleted`);
      fetchCategoriesAndItems();
    } catch (err: any) {
      showToast(`❌ Error: ${err.message}`);
    } finally {
      setDeletingCategoryId(null);
    }
  };

  const downloadSampleCsv = () => {
    const sample = `category,name,price,is_veg,tax_rate,description,code
Starters,Paneer Tikka,249,true,5,Charcoal grilled cottage cheese,SKU-001
Starters,Chicken Malai Tikka,299,false,5,Creamy cardamom infused chicken,SKU-002
Main Course,Dal Makhani,220,true,5,Slow cooked black lentils,SKU-003
Main Course,Butter Chicken,360,false,5,Tandoori chicken in makhani gravy,SKU-004
Breads,Butter Naan,55,true,5,Tandoor baked refined flour bread,SKU-005
Desserts,Gulab Jamun,90,true,5,Fried milk dumplings in rose syrup,SKU-006`;
    const blob = new Blob([sample], { type: "text/csv;charset=utf-8;" });
    const url = URL.createObjectURL(blob);
    const link = document.createElement("a");
    link.setAttribute("href", url);
    link.setAttribute("download", "menu_import_sample_template.csv");
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  const handleFileUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    const reader = new FileReader();
    reader.onload = (event) => {
      const content = event.target?.result as string;
      setBulkCsvText(content || "");
      setBulkImportResult(null);
    };
    reader.readAsText(file);
  };

  const handleBulkImportSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!bulkCsvText.trim()) {
      showToast("⚠️ Please paste or upload CSV data first");
      return;
    }
    setIsImporting(true);
    setBulkImportResult(null);
    try {
      const res = await authedFetch("/menu/items/bulk-upload", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ csvText: bulkCsvText }),
      });
      const data = await res.json();
      if (!res.ok) {
        throw new Error(data.error || "Bulk upload failed");
      }
      setBulkImportResult(data);
      showToast(`✅ Bulk import complete: ${data.totalProcessed} processed!`);
      fetchCategoriesAndItems();
    } catch (err: any) {
      showToast(`❌ Error: ${err.message}`);
    } finally {
      setIsImporting(false);
    }
  };

  return (
    <div className="menu-app">
      <Head>
        <title>KapMeta POS — Menu Management</title>
        <meta name="description" content="Category and menu item catalog management console." />
      </Head>

      <div style={{ display: "flex", flex: 1, minHeight: 0 }}>
      <Nav variant="sidebar" />
      <div style={{ flex: 1, display: "flex", flexDirection: "column", minWidth: 0 }}>
      <header className="topbar">
        <div className="topbar-left">
          <div className="brand-badge">
            <span className="brand-icon">🍽️</span>
            <span className="brand-name">KapMeta POS</span>
          </div>
          <div className="outlet-pill">
            <span className="outlet-dot"></span>
            <span>Menu Management Console</span>
          </div>
        </div>

        <div className="topbar-right">
          <div className="user-profile-badge">
            <div className="avatar-circle">{me?.name ? me.name.charAt(0).toUpperCase() : "?"}</div>
            <span className="user-name">{me?.name ?? "Loading..."}</span>
          </div>
        </div>
      </header>

      <main className="menu-content">
        {authLoading && (
          <div className="empty-state">
            <span className="empty-icon">🔐</span>
            <h3>Checking access...</h3>
          </div>
        )}

        {!authLoading && (
          <>
            <section className="kpi-grid">
              <div className="kpi-card">
                <div className="kpi-icon-square green">📁</div>
                <div className="kpi-info">
                  <span className="kpi-label">CATEGORIES</span>
                  <h3 className="kpi-value">{categories.length}</h3>
                </div>
              </div>
              <div className="kpi-card">
                <div className="kpi-icon-square blue">🍲</div>
                <div className="kpi-info">
                  <span className="kpi-label">MENU ITEMS</span>
                  <h3 className="kpi-value">{totalItems}</h3>
                </div>
              </div>
            </section>

            <section className="toolbar">
              <h2>Categories & Items</h2>
              <div className="toolbar-actions">
                <button
                  type="button"
                  className="btn-normal"
                  style={{ display: "inline-flex", alignItems: "center", gap: "6px" }}
                  onClick={() => {
                    setIsBulkImportOpen(true);
                    setBulkImportResult(null);
                  }}
                >
                  📥 Bulk Import (CSV)
                </button>
                <button type="button" className="btn-secondary" onClick={() => setIsAddCategoryOpen(true)}>
                  + Add Category
                </button>
                <button
                  type="button"
                  className="btn-primary"
                  onClick={() => openAddItem()}
                  disabled={categories.length === 0}
                >
                  + Add Menu Item
                </button>
              </div>
            </section>

            {loading && (
              <div className="empty-state">
                <span className="empty-icon">⏳</span>
                <h3>Loading menu...</h3>
              </div>
            )}

            {!loading && loadError && (
              <div className="empty-state">
                <span className="empty-icon">⚠️</span>
                <h3>Could not load menu</h3>
                <p>{loadError}. Check that the API is running and you are signed in.</p>
              </div>
            )}

            {!loading && !loadError && categories.length === 0 && (
              <div className="empty-state">
                <span className="empty-icon">📁</span>
                <h3>No categories yet</h3>
                <p>Add your first category to start building the menu.</p>
              </div>
            )}

            {!loading && !loadError && categories.length > 0 && (
              <section className="category-list">
                {categories.map((cat) => {
                  const items = itemsByCategory[cat.id] || [];
                  const expanded = expandedCategoryId === cat.id;
                  return (
                    <div key={cat.id} className="category-card">
                      <div className="category-header-row">
                        <button
                          type="button"
                          className="category-header"
                          onClick={() => setExpandedCategoryId(expanded ? null : cat.id)}
                        >
                          <div className="category-header-left">
                            <span className={`chevron ${expanded ? "open" : ""}`}>▶</span>
                            <span className="category-name">{cat.name}</span>
                            <span className="category-count">{items.length} items</span>
                          </div>
                          {cat.description && <span className="category-desc">{cat.description}</span>}
                        </button>
                        <div className="category-actions">
                          <button
                            type="button"
                            className="btn-secondary small"
                            onClick={() => openEditCategory(cat)}
                          >
                            Edit
                          </button>
                          <button
                            type="button"
                            className="btn-alert small"
                            disabled={deletingCategoryId === cat.id}
                            onClick={() => handleDeleteCategory(cat)}
                          >
                            {deletingCategoryId === cat.id ? "Deleting..." : "Delete"}
                          </button>
                        </div>
                      </div>

                      {expanded && (
                        <div className="category-body">
                          <div className="category-body-actions">
                            <button
                              type="button"
                              className="btn-secondary small"
                              onClick={() => openAddItem(cat.id)}
                            >
                              + Add Item to {cat.name}
                            </button>
                          </div>
                          {items.length === 0 && (
                            <p className="no-items-msg">No items in this category yet.</p>
                          )}
                          {items.length > 0 && (
                            <table className="items-table">
                              <thead>
                                <tr>
                                  <th>Name</th>
                                  <th>Dine-In</th>
                                  <th>Parcel</th>
                                  <th>Zomato</th>
                                  <th>Swiggy</th>
                                  <th>Diet</th>
                                  <th>Status</th>
                                  <th>Actions</th>
                                </tr>
                              </thead>
                              <tbody>
                                {items.map((item) => (
                                  <tr key={item.id}>
                                    <td>
                                      <div className="item-name-cell">
                                        {item.imageUrl ? (
                                          <img
                                            src={item.imageUrl}
                                            alt={item.name}
                                            className="item-row-thumb"
                                          />
                                        ) : (
                                          <div className="item-row-avatar">
                                            {item.isVeg ? "🌱" : "🍗"}
                                          </div>
                                        )}
                                        <div style={{ display: "flex", flexDirection: "column" }}>
                                          <span className="item-row-title">
                                            {item.name}
                                            {item.shortCode && (
                                              <span style={{ marginLeft: "6px", fontSize: "10px", fontWeight: 700, padding: "1px 5px", borderRadius: "4px", background: "var(--bg-subtle)", border: "1px solid var(--border)", color: "var(--text-secondary)" }}>
                                                #{item.shortCode}
                                              </span>
                                            )}
                                          </span>
                                          {item.description && (
                                            <span style={{ fontSize: "11px", color: "var(--text-muted)", maxWidth: "260px", overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>
                                              {item.description}
                                            </span>
                                          )}
                                        </div>
                                      </div>
                                    </td>
                                    <td style={{ fontWeight: 700 }}>{formatPriceMinor(item.priceMinor)}</td>
                                    <td>
                                      <span style={{ fontWeight: 600 }}>{formatPriceMinor(item.parcelPriceMinor ?? item.priceMinor)}</span>
                                      {item.parcelAvailable === false && (
                                        <span style={{ marginLeft: "4px", fontSize: "10px", color: "#ef4444", fontWeight: 700 }}>Off</span>
                                      )}
                                    </td>
                                    <td>
                                      <span style={{ fontWeight: 600, color: "#e11d48" }}>{formatPriceMinor(item.zomatoPriceMinor ?? item.priceMinor)}</span>
                                      {item.zomatoAvailable === false && (
                                        <span style={{ marginLeft: "4px", fontSize: "10px", color: "#ef4444", fontWeight: 700 }}>Off</span>
                                      )}
                                    </td>
                                    <td>
                                      <span style={{ fontWeight: 600, color: "#ea580c" }}>{formatPriceMinor(item.swiggyPriceMinor ?? item.priceMinor)}</span>
                                      {item.swiggyAvailable === false && (
                                        <span style={{ marginLeft: "4px", fontSize: "10px", color: "#ef4444", fontWeight: 700 }}>Off</span>
                                      )}
                                    </td>
                                    <td>{item.isVeg ? "🟢 Veg" : "🔴 Non-Veg"}</td>
                                    <td>
                                      <button
                                        type="button"
                                        className={`status-pill ${item.isActive ? "active" : "inactive"} status-toggle`}
                                        disabled={togglingItemId === item.id}
                                        onClick={() => handleToggleAvailability(item)}
                                        title="Click to toggle 86 / availability"
                                      >
                                        {togglingItemId === item.id ? "..." : item.isActive ? "Active" : "Inactive"}
                                      </button>
                                    </td>
                                    <td>
                                      <div className="row-actions">
                                        <button
                                          type="button"
                                          className="btn-secondary small"
                                          onClick={() => openEditItem(item)}
                                        >
                                          Edit
                                        </button>
                                        <button
                                          type="button"
                                          className="btn-alert small"
                                          disabled={deletingItemId === item.id}
                                          onClick={() => handleDeleteItem(item)}
                                        >
                                          {deletingItemId === item.id ? "Deleting..." : "Delete"}
                                        </button>
                                      </div>
                                    </td>
                                  </tr>
                                ))}
                              </tbody>
                            </table>
                          )}
                        </div>
                      )}
                    </div>
                  );
                })}
              </section>
            )}
          </>
        )}
      </main>

      {isAddCategoryOpen && (
        <div className="modal-overlay" onClick={() => setIsAddCategoryOpen(false)}>
          <div className="modal" onClick={(e) => e.stopPropagation()}>
            <h3>Add Category</h3>
            <form onSubmit={handleAddCategory}>
              <label>
                Category Name
                <input
                  type="text"
                  value={newCategoryName}
                  onChange={(e) => setNewCategoryName(e.target.value)}
                  placeholder="e.g. Cold Beverages"
                  autoFocus
                />
              </label>
              <label>
                Description (optional)
                <textarea
                  value={newCategoryDescription}
                  onChange={(e) => setNewCategoryDescription(e.target.value)}
                  placeholder="Short description"
                />
              </label>
              <div className="modal-actions">
                <button type="button" className="btn-cancel" onClick={() => setIsAddCategoryOpen(false)}>
                  Cancel
                </button>
                <button type="submit" className="btn-primary" disabled={savingCategory}>
                  {savingCategory ? "Saving..." : "Save Category"}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {isAddItemOpen && (
        <div className="modal-overlay" onClick={() => setIsAddItemOpen(false)}>
          <div className="modal" onClick={(e) => e.stopPropagation()}>
            <h3>Add Menu Item</h3>
            <form onSubmit={handleAddItem}>
              <label>
                Category
                <select value={newItemCategoryId} onChange={(e) => setNewItemCategoryId(e.target.value)}>
                  {categories.map((cat) => (
                    <option key={cat.id} value={cat.id}>
                      {cat.name}
                    </option>
                  ))}
                </select>
              </label>
              <label>
                Item Name
                <input
                  type="text"
                  value={newItemName}
                  onChange={(e) => setNewItemName(e.target.value)}
                  placeholder="e.g. Paneer Tikka"
                  autoFocus
                />
              </label>
              <label>
                Description (optional)
                <textarea
                  value={newItemDescription}
                  onChange={(e) => setNewItemDescription(e.target.value)}
                  placeholder="Short description"
                />
              </label>
              <div className="image-field-container">
                <span className="field-title">Dish Image (optional)</span>
                {newItemImageUrl ? (
                  <div className="image-preview-wrapper">
                    <img src={newItemImageUrl} alt="Preview" className="image-preview-img" />
                    <div className="image-preview-info">
                      <span className="image-status-badge">✓ Image Attached</span>
                      <div className="image-preview-btns">
                        <button
                          type="button"
                          className="btn-replace-img"
                          onClick={() => addItemFileInputRef.current?.click()}
                        >
                          Change Photo
                        </button>
                        <button
                          type="button"
                          className="btn-remove-img"
                          onClick={() => setNewItemImageUrl("")}
                        >
                          Remove
                        </button>
                      </div>
                    </div>
                  </div>
                ) : (
                  <div
                    className={`image-dropzone ${isAddDragging ? "dropzone-active" : ""}`}
                    onClick={() => addItemFileInputRef.current?.click()}
                    onDragOver={(e) => {
                      e.preventDefault();
                      setIsAddDragging(true);
                    }}
                    onDragLeave={() => setIsAddDragging(false)}
                    onDrop={(e) => {
                      e.preventDefault();
                      setIsAddDragging(false);
                      if (e.dataTransfer.files?.[0]) {
                        processImageFile(e.dataTransfer.files[0], setNewItemImageUrl);
                      }
                    }}
                  >
                    <div className="dropzone-icon">📷</div>
                    <div className="dropzone-copy">
                      <span className="dropzone-title">Upload Image</span>
                      <span className="dropzone-sub">Click to browse or drag & drop</span>
                    </div>
                  </div>
                )}
                <input
                  type="file"
                  ref={addItemFileInputRef}
                  accept="image/*"
                  style={{ display: "none" }}
                  onChange={(e) => {
                    if (e.target.files?.[0]) {
                      processImageFile(e.target.files[0], setNewItemImageUrl);
                    }
                  }}
                />
                {!showAddUrlInput ? (
                  <button
                    type="button"
                    className="btn-link-toggle"
                    onClick={() => setShowAddUrlInput(true)}
                  >
                    🔗 Or paste image URL
                  </button>
                ) : (
                  <div className="url-input-container">
                    <input
                      type="url"
                      value={newItemImageUrl}
                      onChange={(e) => setNewItemImageUrl(e.target.value)}
                      placeholder="https://images.unsplash.com/... or web URL"
                    />
                    <button
                      type="button"
                      className="btn-url-close"
                      onClick={() => setShowAddUrlInput(false)}
                    >
                      ✕
                    </button>
                  </div>
                )}
              </div>
              <div className="field-row">
                <label>
                  Dine-In Price (₹)
                  <input
                    type="number"
                    min="0"
                    step="0.01"
                    value={newItemPrice}
                    onChange={(e) => setNewItemPrice(e.target.value)}
                    placeholder="179"
                  />
                </label>
                <label>
                  Short Code (optional)
                  <input
                    type="text"
                    value={newItemShortCode}
                    onChange={(e) => setNewItemShortCode(e.target.value)}
                    placeholder="e.g. 250"
                  />
                </label>
              </div>
              <div className="field-row">
                <label>
                  Parcel Price (₹)
                  <input
                    type="number"
                    min="0"
                    step="0.01"
                    value={newItemParcelPrice}
                    onChange={(e) => setNewItemParcelPrice(e.target.value)}
                    placeholder={newItemPrice || "189"}
                  />
                </label>
                <label>
                  Tax Rate (%)
                  <input
                    type="number"
                    min="0"
                    step="0.1"
                    value={newItemTaxRate}
                    onChange={(e) => setNewItemTaxRate(e.target.value)}
                  />
                </label>
              </div>
              <div className="field-row">
                <label>
                  Zomato Price (₹)
                  <input
                    type="number"
                    min="0"
                    step="0.01"
                    value={newItemZomatoPrice}
                    onChange={(e) => setNewItemZomatoPrice(e.target.value)}
                    placeholder={newItemPrice || "235.75"}
                  />
                </label>
                <label>
                  Swiggy Price (₹)
                  <input
                    type="number"
                    min="0"
                    step="0.01"
                    value={newItemSwiggyPrice}
                    onChange={(e) => setNewItemSwiggyPrice(e.target.value)}
                    placeholder={newItemPrice || "235.75"}
                  />
                </label>
              </div>
              <div style={{ display: "flex", flexWrap: "wrap", gap: "14px", marginBottom: "10px" }}>
                <label className="checkbox-row" style={{ marginBottom: 0 }}>
                  <input
                    type="checkbox"
                    checked={newItemIsVeg}
                    onChange={(e) => setNewItemIsVeg(e.target.checked)}
                  />
                  Vegetarian
                </label>
                <label className="checkbox-row" style={{ marginBottom: 0 }}>
                  <input
                    type="checkbox"
                    checked={newItemParcelAvailable}
                    onChange={(e) => setNewItemParcelAvailable(e.target.checked)}
                  />
                  Parcel
                </label>
                <label className="checkbox-row" style={{ marginBottom: 0 }}>
                  <input
                    type="checkbox"
                    checked={newItemZomatoAvailable}
                    onChange={(e) => setNewItemZomatoAvailable(e.target.checked)}
                  />
                  Zomato
                </label>
                <label className="checkbox-row" style={{ marginBottom: 0 }}>
                  <input
                    type="checkbox"
                    checked={newItemSwiggyAvailable}
                    onChange={(e) => setNewItemSwiggyAvailable(e.target.checked)}
                  />
                  Swiggy
                </label>
              </div>
              <div className="modal-actions">
                <button type="button" className="btn-cancel" onClick={() => setIsAddItemOpen(false)}>
                  Cancel
                </button>
                <button type="submit" className="btn-primary" disabled={savingItem}>
                  {savingItem ? "Saving..." : "Save Item"}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {isEditItemOpen && (
        <div className="modal-overlay" onClick={() => setIsEditItemOpen(false)}>
          <div className="modal" onClick={(e) => e.stopPropagation()}>
            <h3>Edit Menu Item</h3>
            <form onSubmit={handleEditItem}>
              <label>
                Category
                <select value={editItemCategoryId} onChange={(e) => setEditItemCategoryId(e.target.value)}>
                  {categories.map((cat) => (
                    <option key={cat.id} value={cat.id}>
                      {cat.name}
                    </option>
                  ))}
                </select>
              </label>
              <label>
                Item Name
                <input
                  type="text"
                  value={editItemName}
                  onChange={(e) => setEditItemName(e.target.value)}
                  autoFocus
                />
              </label>
              <label>
                Description (optional)
                <textarea
                  value={editItemDescription}
                  onChange={(e) => setEditItemDescription(e.target.value)}
                  placeholder="Short description"
                />
              </label>
              <div className="image-field-container">
                <span className="field-title">Dish Image (optional)</span>
                {editItemImageUrl ? (
                  <div className="image-preview-wrapper">
                    <img src={editItemImageUrl} alt="Preview" className="image-preview-img" />
                    <div className="image-preview-info">
                      <span className="image-status-badge">✓ Image Attached</span>
                      <div className="image-preview-btns">
                        <button
                          type="button"
                          className="btn-replace-img"
                          onClick={() => editItemFileInputRef.current?.click()}
                        >
                          Change Photo
                        </button>
                        <button
                          type="button"
                          className="btn-remove-img"
                          onClick={() => setEditItemImageUrl("")}
                        >
                          Remove
                        </button>
                      </div>
                    </div>
                  </div>
                ) : (
                  <div
                    className={`image-dropzone ${isEditDragging ? "dropzone-active" : ""}`}
                    onClick={() => editItemFileInputRef.current?.click()}
                    onDragOver={(e) => {
                      e.preventDefault();
                      setIsEditDragging(true);
                    }}
                    onDragLeave={() => setIsEditDragging(false)}
                    onDrop={(e) => {
                      e.preventDefault();
                      setIsEditDragging(false);
                      if (e.dataTransfer.files?.[0]) {
                        processImageFile(e.dataTransfer.files[0], setEditItemImageUrl);
                      }
                    }}
                  >
                    <div className="dropzone-icon">📷</div>
                    <div className="dropzone-copy">
                      <span className="dropzone-title">Upload Image</span>
                      <span className="dropzone-sub">Click to browse or drag & drop</span>
                    </div>
                  </div>
                )}
                <input
                  type="file"
                  ref={editItemFileInputRef}
                  accept="image/*"
                  style={{ display: "none" }}
                  onChange={(e) => {
                    if (e.target.files?.[0]) {
                      processImageFile(e.target.files[0], setEditItemImageUrl);
                    }
                  }}
                />
                {!showEditUrlInput ? (
                  <button
                    type="button"
                    className="btn-link-toggle"
                    onClick={() => setShowEditUrlInput(true)}
                  >
                    🔗 Or paste image URL
                  </button>
                ) : (
                  <div className="url-input-container">
                    <input
                      type="url"
                      value={editItemImageUrl}
                      onChange={(e) => setEditItemImageUrl(e.target.value)}
                      placeholder="https://images.unsplash.com/... or web URL"
                    />
                    <button
                      type="button"
                      className="btn-url-close"
                      onClick={() => setShowEditUrlInput(false)}
                    >
                      ✕
                    </button>
                  </div>
                )}
              </div>
              <div className="field-row">
                <label>
                  Dine-In Price (₹)
                  <input
                    type="number"
                    min="0"
                    step="0.01"
                    value={editItemPrice}
                    onChange={(e) => setEditItemPrice(e.target.value)}
                  />
                </label>
                <label>
                  Short Code (optional)
                  <input
                    type="text"
                    value={editItemShortCode}
                    onChange={(e) => setEditItemShortCode(e.target.value)}
                    placeholder="e.g. 250"
                  />
                </label>
              </div>
              <div className="field-row">
                <label>
                  Parcel Price (₹)
                  <input
                    type="number"
                    min="0"
                    step="0.01"
                    value={editItemParcelPrice}
                    onChange={(e) => setEditItemParcelPrice(e.target.value)}
                  />
                </label>
                <label>
                  Tax Rate (%)
                  <input
                    type="number"
                    min="0"
                    step="0.1"
                    value={editItemTaxRate}
                    onChange={(e) => setEditItemTaxRate(e.target.value)}
                  />
                </label>
              </div>
              <div className="field-row">
                <label>
                  Zomato Price (₹)
                  <input
                    type="number"
                    min="0"
                    step="0.01"
                    value={editItemZomatoPrice}
                    onChange={(e) => setEditItemZomatoPrice(e.target.value)}
                  />
                </label>
                <label>
                  Swiggy Price (₹)
                  <input
                    type="number"
                    min="0"
                    step="0.01"
                    value={editItemSwiggyPrice}
                    onChange={(e) => setEditItemSwiggyPrice(e.target.value)}
                  />
                </label>
              </div>
              <div style={{ display: "flex", flexWrap: "wrap", gap: "14px", marginBottom: "10px" }}>
                <label className="checkbox-row" style={{ marginBottom: 0 }}>
                  <input
                    type="checkbox"
                    checked={editItemIsVeg}
                    onChange={(e) => setEditItemIsVeg(e.target.checked)}
                  />
                  Vegetarian
                </label>
                <label className="checkbox-row" style={{ marginBottom: 0 }}>
                  <input
                    type="checkbox"
                    checked={editItemParcelAvailable}
                    onChange={(e) => setEditItemParcelAvailable(e.target.checked)}
                  />
                  Parcel
                </label>
                <label className="checkbox-row" style={{ marginBottom: 0 }}>
                  <input
                    type="checkbox"
                    checked={editItemZomatoAvailable}
                    onChange={(e) => setEditItemZomatoAvailable(e.target.checked)}
                  />
                  Zomato
                </label>
                <label className="checkbox-row" style={{ marginBottom: 0 }}>
                  <input
                    type="checkbox"
                    checked={editItemSwiggyAvailable}
                    onChange={(e) => setEditItemSwiggyAvailable(e.target.checked)}
                  />
                  Swiggy
                </label>
              </div>
              <div className="modal-actions">
                <button type="button" className="btn-cancel" onClick={() => setIsEditItemOpen(false)}>
                  Cancel
                </button>
                <button type="submit" className="btn-primary" disabled={savingEditItem}>
                  {savingEditItem ? "Saving..." : "Save Changes"}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {isEditCategoryOpen && (
        <div className="modal-overlay" onClick={() => setIsEditCategoryOpen(false)}>
          <div className="modal" onClick={(e) => e.stopPropagation()}>
            <h3>Edit Category</h3>
            <form onSubmit={handleEditCategory}>
              <label>
                Category Name
                <input
                  type="text"
                  value={editCategoryName}
                  onChange={(e) => setEditCategoryName(e.target.value)}
                  autoFocus
                />
              </label>
              <label>
                Description (optional)
                <textarea
                  value={editCategoryDescription}
                  onChange={(e) => setEditCategoryDescription(e.target.value)}
                  placeholder="Short description"
                />
              </label>
              <div className="modal-actions">
                <button type="button" className="btn-cancel" onClick={() => setIsEditCategoryOpen(false)}>
                  Cancel
                </button>
                <button type="submit" className="btn-primary" disabled={savingEditCategory}>
                  {savingEditCategory ? "Saving..." : "Save Changes"}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Bulk CSV Menu Importer Modal */}
      {isBulkImportOpen && (
        <div className="modal-overlay" onClick={() => setIsBulkImportOpen(false)}>
          <div className="modal" style={{ maxWidth: "600px", width: "90%" }} onClick={(e) => e.stopPropagation()}>
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "16px" }}>
              <h3 style={{ margin: 0, fontSize: "1.25rem", fontWeight: 800 }}>📥 Bulk Import Menu (CSV / Excel)</h3>
              <button
                type="button"
                className="btn-normal small"
                onClick={downloadSampleCsv}
              >
                📥 Download Sample CSV
              </button>
            </div>

            <p style={{ fontSize: "0.8125rem", color: "var(--text-secondary)", margin: "0 0 16px" }}>
              Upload a <code>.csv</code> file or paste rows copied directly from Excel / Google Sheets. Categories will be automatically created if they don&apos;t already exist.
            </p>

            <form onSubmit={handleBulkImportSubmit}>
              <div style={{ marginBottom: "12px" }}>
                <label style={{ display: "block", fontSize: "0.75rem", fontWeight: 700, color: "var(--text-secondary)", marginBottom: "4px" }}>
                  Option 1: Pick a .CSV File from Computer
                </label>
                <input
                  type="file"
                  accept=".csv,.txt"
                  onChange={handleFileUpload}
                  style={{
                    display: "block",
                    width: "100%",
                    fontSize: "0.8125rem",
                    padding: "8px",
                    border: "1px dashed var(--border-strong)",
                    borderRadius: "6px",
                    background: "var(--bg-subtle)",
                    color: "var(--text-primary)",
                  }}
                />
              </div>

              <div style={{ marginBottom: "16px" }}>
                <label style={{ display: "block", fontSize: "0.75rem", fontWeight: 700, color: "var(--text-secondary)", marginBottom: "4px" }}>
                  Option 2: Paste CSV Text / Excel Rows Below
                </label>
                <textarea
                  rows={8}
                  value={bulkCsvText}
                  onChange={(e) => setBulkCsvText(e.target.value)}
                  placeholder={`category,name,price,is_veg,tax_rate,description,code\nStarters,Paneer Tikka,249,true,5,Grilled cottage cheese,SKU-001\nMain Course,Butter Chicken,360,false,5,Makhani gravy,SKU-002`}
                  style={{
                    width: "100%",
                    fontFamily: "monospace",
                    fontSize: "0.75rem",
                    padding: "10px",
                    borderRadius: "6px",
                    border: "1px solid var(--border-strong)",
                    background: "var(--bg-subtle)",
                    color: "var(--text-primary)",
                    resize: "vertical",
                  }}
                />
              </div>

              {bulkImportResult && (
                <div style={{
                  padding: "12px 16px",
                  borderRadius: "6px",
                  background: bulkImportResult.errors.length === 0 ? "rgba(16, 185, 129, 0.15)" : "rgba(245, 158, 11, 0.15)",
                  border: `1px solid ${bulkImportResult.errors.length === 0 ? "#10b981" : "#f59e0b"}`,
                  marginBottom: "16px",
                  fontSize: "0.8125rem",
                }}>
                  <div style={{ fontWeight: 800, color: bulkImportResult.errors.length === 0 ? "#34d399" : "#fbbf24", marginBottom: "4px" }}>
                    🎉 Import Summary:
                  </div>
                  <div>• Processed: <strong>{bulkImportResult.totalProcessed}</strong> items</div>
                  <div>• Categories Created: <strong>{bulkImportResult.categoriesCreated}</strong></div>
                  <div>• Items Created: <strong>{bulkImportResult.itemsCreated}</strong></div>
                  <div>• Items Updated: <strong>{bulkImportResult.itemsUpdated}</strong></div>
                  {bulkImportResult.errors.length > 0 && (
                    <div style={{ color: "#fbbf24", marginTop: "6px" }}>
                      ⚠️ Warnings / Skipped:
                      <ul style={{ margin: "4px 0 0", paddingLeft: "16px" }}>
                        {bulkImportResult.errors.map((err, i) => <li key={i}>{err}</li>)}
                      </ul>
                    </div>
                  )}
                </div>
              )}

              <div className="modal-actions" style={{ display: "flex", gap: "10px", justifyContent: "flex-end" }}>
                <button
                  type="button"
                  className="btn-cancel"
                  onClick={() => setIsBulkImportOpen(false)}
                >
                  Close
                </button>
                <button
                  type="submit"
                  className="btn-primary"
                  disabled={isImporting || !bulkCsvText.trim()}
                >
                  {isImporting ? "Importing..." : "Commit Bulk Import"}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {toastMessage && <div className="toast">{toastMessage}</div>}

      <style jsx>{`
        .menu-app {
          min-height: 100vh;
          background: var(--bg-base);
          display: flex;
          flex-direction: column;
          font-family: "Inter", system-ui, -apple-system, sans-serif;
          color: var(--text-primary);
        }

        .topbar {
          height: 64px;
          background: var(--bg-card);
          border-bottom: 1px solid var(--border);
          display: flex;
          align-items: center;
          justify-content: space-between;
          padding: 0 24px;
          position: sticky;
          top: 0;
          z-index: 50;
        }

        .topbar-left {
          display: flex;
          align-items: center;
          gap: 16px;
        }

        .brand-badge {
          display: flex;
          align-items: center;
          gap: 8px;
        }

        .brand-icon {
          font-size: 20px;
        }

        .brand-name {
          font-size: 16px;
          font-weight: 700;
          color: var(--text-primary);
        }

        .outlet-pill {
          display: flex;
          align-items: center;
          gap: 6px;
          padding: 4px 10px;
          background: rgba(16, 185, 129, 0.15);
          color: #34d399;
          border-radius: 9999px;
          font-size: 12px;
          font-weight: 600;
          border: 1px solid rgba(16, 185, 129, 0.2);
        }

        .outlet-dot {
          width: 6px;
          height: 6px;
          background: #10b981;
          border-radius: 50%;
        }

        .topbar-right {
          display: flex;
          align-items: center;
        }

        .user-profile-badge {
          display: flex;
          align-items: center;
          gap: 8px;
        }

        .avatar-circle {
          width: 32px;
          height: 32px;
          background: var(--bg-elevated);
          color: var(--text-primary);
          border: 1px solid var(--border-strong);
          border-radius: 50%;
          display: flex;
          align-items: center;
          justify-content: center;
          font-weight: 700;
          font-size: 13px;
        }

        .user-name {
          font-size: 13px;
          font-weight: 600;
          color: var(--text-primary);
        }

        .menu-content {
          padding: 24px;
          max-width: 1200px;
          margin: 0 auto;
          width: 100%;
          box-sizing: border-box;
          display: flex;
          flex-direction: column;
          gap: 20px;
        }

        .kpi-grid {
          display: grid;
          grid-template-columns: repeat(2, 1fr);
          gap: 16px;
          max-width: 500px;
        }

        .kpi-card {
          background: var(--bg-card);
          border: 1px solid var(--border);
          border-radius: 16px;
          padding: 20px;
          display: flex;
          align-items: center;
          gap: 16px;
          box-shadow: var(--shadow-card);
        }

        .kpi-icon-square {
          width: 48px;
          height: 48px;
          border-radius: 12px;
          display: flex;
          align-items: center;
          justify-content: center;
          font-size: 20px;
          flex-shrink: 0;
        }

        .kpi-icon-square.green {
          background: rgba(16, 185, 129, 0.15);
          color: #34d399;
        }

        .kpi-icon-square.blue {
          background: rgba(59, 130, 246, 0.15);
          color: #60a5fa;
        }

        .kpi-label {
          font-size: 11px;
          font-weight: 700;
          color: var(--text-secondary);
          letter-spacing: 0.5px;
        }

        .kpi-value {
          font-size: 26px;
          font-weight: 800;
          color: var(--text-primary);
          margin: 2px 0 0 0;
        }

        .toolbar {
          display: flex;
          align-items: center;
          justify-content: space-between;
        }

        .toolbar h2 {
          font-size: 18px;
          margin: 0;
          color: var(--text-primary);
        }

        .toolbar-actions {
          display: flex;
          gap: 10px;
        }

        .category-header-row {
          display: flex;
          align-items: stretch;
          gap: 8px;
        }

        .category-header-row .category-header {
          flex: 1;
          min-width: 0;
        }

        .category-actions {
          display: flex;
          align-items: center;
          gap: 6px;
          padding: 0 16px;
        }

        .row-actions {
          display: flex;
          gap: 6px;
        }

        .status-toggle {
          border: none;
          cursor: pointer;
        }

        .status-toggle:disabled {
          opacity: 0.6;
          cursor: not-allowed;
        }

        .empty-state {
          text-align: center;
          padding: 60px 20px;
          background: var(--bg-card);
          border: 1px dashed var(--border-strong);
          border-radius: 16px;
        }

        .empty-icon {
          font-size: 40px;
          display: block;
          margin-bottom: 12px;
        }

        .category-list {
          display: flex;
          flex-direction: column;
          gap: 12px;
        }

        .category-card {
          background: var(--bg-card);
          border: 1px solid var(--border);
          border-radius: 12px;
          overflow: hidden;
        }

        .category-header {
          width: 100%;
          display: flex;
          align-items: center;
          justify-content: space-between;
          padding: 16px;
          background: transparent;
          border: none;
          cursor: pointer;
          text-align: left;
        }

        .category-header-left {
          display: flex;
          align-items: center;
          gap: 10px;
        }

        .chevron {
          font-size: 10px;
          color: var(--text-muted);
          transition: transform 0.15s ease;
        }

        .chevron.open {
          transform: rotate(90deg);
        }

        .category-name {
          font-size: 14px;
          font-weight: 700;
          color: var(--text-primary);
        }

        .category-count {
          font-size: 12px;
          color: var(--text-secondary);
          background: var(--bg-subtle);
          border: 1px solid var(--border);
          padding: 2px 8px;
          border-radius: 9999px;
        }

        .category-desc {
          font-size: 12px;
          color: var(--text-muted);
        }

        .category-body {
          padding: 0 16px 16px 16px;
          border-top: 1px solid var(--border);
        }

        .category-body-actions {
          padding: 12px 0;
        }

        .no-items-msg {
          font-size: 13px;
          color: var(--text-muted);
        }

        .items-table {
          width: 100%;
          border-collapse: collapse;
          font-size: 13px;
        }

        .items-table th {
          text-align: left;
          font-size: 11px;
          color: var(--text-secondary);
          font-weight: 700;
          padding: 8px;
          border-bottom: 1px solid var(--border);
        }

        .items-table td {
          padding: 8px;
          border-bottom: 1px solid var(--border);
          color: var(--text-primary);
        }

        .desc-cell {
          color: var(--text-secondary);
          max-width: 240px;
        }

        .status-pill {
          font-size: 11px;
          font-weight: 700;
          padding: 2px 8px;
          border-radius: 9999px;
        }

        .status-pill.active {
          background: rgba(16, 185, 129, 0.15);
          color: #34d399;
          border: 1px solid rgba(16, 185, 129, 0.25);
        }

        .status-pill.inactive {
          background: rgba(239, 68, 68, 0.15);
          color: #f87171;
          border: 1px solid rgba(239, 68, 68, 0.25);
        }

        .modal-overlay {
          position: fixed;
          inset: 0;
          background: rgba(0, 0, 0, 0.65);
          backdrop-filter: blur(4px);
          display: flex;
          align-items: center;
          justify-content: center;
          z-index: 100;
        }

        .modal {
          background: var(--bg-card);
          border: 1px solid var(--border-strong);
          border-radius: 16px;
          padding: 24px;
          width: 480px;
          max-width: 92vw;
          max-height: 92vh;
          overflow-y: auto;
          box-shadow: var(--shadow-modal);
          color: var(--text-primary);
        }

        .item-name-cell {
          display: flex;
          align-items: center;
          gap: 12px;
        }

        .item-row-thumb {
          width: 36px;
          height: 36px;
          object-fit: cover;
          border-radius: 8px;
          border: 1px solid var(--border-strong);
          flex-shrink: 0;
        }

        .item-row-avatar {
          width: 36px;
          height: 36px;
          border-radius: 8px;
          background: var(--bg-subtle);
          border: 1px solid var(--border);
          display: flex;
          align-items: center;
          justify-content: center;
          font-size: 18px;
          flex-shrink: 0;
        }

        .item-row-title {
          font-weight: 600;
          color: var(--text-primary);
        }

        .image-field-container {
          margin-bottom: 14px;
        }

        .field-title {
          display: block;
          font-size: 12px;
          font-weight: 600;
          color: var(--text-secondary);
          margin-bottom: 8px;
        }

        .image-preview-wrapper {
          display: flex;
          align-items: center;
          gap: 14px;
          padding: 10px;
          background: var(--bg-subtle);
          border: 1px solid var(--border-strong);
          border-radius: 10px;
        }

        .image-preview-img {
          width: 64px;
          height: 64px;
          object-fit: cover;
          border-radius: 8px;
          border: 1px solid var(--border);
          flex-shrink: 0;
        }

        .image-preview-info {
          display: flex;
          flex-direction: column;
          gap: 6px;
          flex: 1;
        }

        .image-status-badge {
          font-size: 11px;
          font-weight: 700;
          color: #10b981;
        }

        .image-preview-btns {
          display: flex;
          gap: 8px;
        }

        .btn-replace-img {
          background: var(--bg-card);
          border: 1px solid var(--border);
          color: var(--text-primary);
          padding: 4px 10px;
          border-radius: 6px;
          font-size: 11px;
          font-weight: 600;
          cursor: pointer;
        }
        .btn-replace-img:hover {
          border-color: var(--accent);
        }

        .btn-remove-img {
          background: rgba(239, 68, 68, 0.1);
          border: 1px solid rgba(239, 68, 68, 0.3);
          color: #f87171;
          padding: 4px 10px;
          border-radius: 6px;
          font-size: 11px;
          font-weight: 600;
          cursor: pointer;
        }
        .btn-remove-img:hover {
          background: rgba(239, 68, 68, 0.2);
        }

        .image-dropzone {
          display: flex;
          align-items: center;
          gap: 12px;
          padding: 12px 14px;
          background: var(--bg-subtle);
          border: 2px dashed var(--border-strong);
          border-radius: 10px;
          cursor: pointer;
          transition: all 0.15s ease;
        }
        .image-dropzone:hover {
          border-color: var(--accent);
          background: rgba(59, 130, 246, 0.05);
        }
        .image-dropzone.dropzone-active {
          border-color: var(--accent);
          background: rgba(59, 130, 246, 0.12);
        }

        .dropzone-icon {
          font-size: 24px;
          line-height: 1;
        }

        .dropzone-copy {
          display: flex;
          flex-direction: column;
          gap: 2px;
        }

        .dropzone-title {
          font-size: 12px;
          font-weight: 600;
          color: var(--text-primary);
        }

        .dropzone-sub {
          font-size: 11px;
          color: var(--text-muted);
        }

        .btn-link-toggle {
          background: none;
          border: none;
          color: var(--accent);
          font-size: 11px;
          font-weight: 600;
          cursor: pointer;
          padding: 6px 0 0 0;
          text-align: left;
        }
        .btn-link-toggle:hover {
          text-decoration: underline;
        }

        .url-input-container {
          display: flex;
          gap: 6px;
          margin-top: 8px;
        }

        .url-input-container input {
          flex: 1;
          padding: 8px 10px !important;
          font-size: 12px !important;
        }

        .btn-url-close {
          background: var(--bg-subtle);
          border: 1px solid var(--border);
          color: var(--text-secondary);
          border-radius: 6px;
          width: 32px;
          cursor: pointer;
          font-size: 12px;
        }

        .modal h3 {
          margin: 0 0 16px 0;
          font-size: 16px;
          color: var(--text-primary);
        }

        .modal label {
          display: flex;
          flex-direction: column;
          gap: 6px;
          font-size: 12px;
          font-weight: 600;
          color: var(--text-secondary);
          margin-bottom: 12px;
        }

        .modal input,
        .modal select,
        .modal textarea {
          padding: 10px 12px;
          border: 1px solid var(--border-strong);
          background: var(--bg-subtle);
          border-radius: 8px;
          font-size: 13px;
          color: var(--text-primary);
          font-family: inherit;
        }

        .modal input:focus,
        .modal select:focus,
        .modal textarea:focus {
          border-color: var(--accent);
          outline: none;
        }

        .modal .checkbox-row {
          flex-direction: row;
          align-items: center;
          gap: 8px;
          color: var(--text-primary);
        }

        .field-row {
          display: flex;
          gap: 12px;
        }

        .field-row label {
          flex: 1;
        }

        .modal-actions {
          display: flex;
          justify-content: flex-end;
          gap: 10px;
          margin-top: 8px;
        }

        .toast {
          position: fixed;
          bottom: 24px;
          right: 24px;
          background: var(--bg-elevated);
          color: var(--text-primary);
          border: 1px solid var(--border-strong);
          padding: 12px 18px;
          border-radius: 10px;
          font-size: 13px;
          font-weight: 600;
          z-index: 200;
          box-shadow: var(--shadow-pop);
        }
      `}</style>
      </div>
      </div>
    </div>
  );
}
