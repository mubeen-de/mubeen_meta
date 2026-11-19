// @ts-nocheck
import { PrismaClient } from "@prisma/client";
import type { MenuCategoryInput, MenuItemInput, MenuItemView } from "@kapmeta/shared-types/menu";

export class PrismaMenuCatalogRepository {
  constructor(private readonly prisma: PrismaClient) {}

  async createCategory(input: MenuCategoryInput) {
    return this.prisma.menuCategory.create({
      data: {
        outletId: input.outletId,
        name: input.name,
        description: input.description,
      },
    });
  }

  async createMenuItem(input: MenuItemInput) {
    const priceMinor = typeof input.priceMinor === "bigint"
      ? input.priceMinor
      : BigInt(input.priceMinor || 0);
    const priceDecimal = (Number(priceMinor) / 100).toFixed(2);
    const taxDecimal = input.taxRate !== undefined ? Number(input.taxRate).toFixed(2) : "5.00";

    const created = await this.prisma.menuItem.create({
      data: {
        outletId: input.outletId,
        categoryId: input.categoryId,
        name: input.name,
        description: input.description,
        onlineDisplayName: input.onlineDisplayName ?? null,
        price: priceMinor,
        isVeg: input.isVeg !== undefined ? input.isVeg : true,
        taxRate: taxDecimal as any,
        imageUrl: input.imageUrl,
      },
    });

    const parcelPriceMinor =
      input.parcelPriceMinor !== undefined && input.parcelPriceMinor !== null
        ? BigInt(input.parcelPriceMinor)
        : priceMinor;
    const zomatoPriceMinor =
      input.zomatoPriceMinor !== undefined && input.zomatoPriceMinor !== null
        ? BigInt(input.zomatoPriceMinor)
        : priceMinor;
    const swiggyPriceMinor =
      input.swiggyPriceMinor !== undefined && input.swiggyPriceMinor !== null
        ? BigInt(input.swiggyPriceMinor)
        : priceMinor;
    const parcelAvailable = input.parcelAvailable !== undefined ? Boolean(input.parcelAvailable) : true;
    const zomatoAvailable = input.zomatoAvailable !== undefined ? Boolean(input.zomatoAvailable) : true;
    const swiggyAvailable = input.swiggyAvailable !== undefined ? Boolean(input.swiggyAvailable) : true;
    const shortCode = input.shortCode ?? null;

    await this.prisma.$executeRaw`
      UPDATE menu_items
      SET
        short_code = ${shortCode},
        parcel_price = ${parcelPriceMinor},
        parcel_available = ${parcelAvailable},
        zomato_price = ${zomatoPriceMinor},
        zomato_available = ${zomatoAvailable},
        swiggy_price = ${swiggyPriceMinor},
        swiggy_available = ${swiggyAvailable}
      WHERE id = ${created.id}::uuid
    `.catch(() => {});

    return {
      id: created.id,
      outletId: created.outletId,
      categoryId: created.categoryId,
      name: created.name,
      description: created.description,
      onlineDisplayName: created.onlineDisplayName || null,
      shortCode,
      priceMinor: priceMinor,
      parcelPriceMinor,
      parcelAvailable,
      zomatoPriceMinor,
      zomatoAvailable,
      swiggyPriceMinor,
      swiggyAvailable,
      price: priceDecimal,
      isVeg: created.isVeg,
      taxRate: (created.taxRate ?? 5.0).toString(),
      isActive: created.isActive,
      imageUrl: (created as any).imageUrl || null,
    };
  }

  async createModifierGroup(outletId: string, name: string, minSelect: number, maxSelect: number) {
    return this.prisma.modifierGroup.create({
      data: { outletId, name, minSelect, maxSelect },
    });
  }

  async createModifierOption(outletId: string, modifierGroupId: string, name: string, priceMinor: bigint) {
    return this.prisma.modifier_options.create({
      data: { outletId, modifierGroupId, name, price: priceMinor },
    });
  }

  async updateMenuItem(outletId: string, itemId: string, patch: Partial<MenuItemInput>) {
    const data: Record<string, unknown> = {};
    if (patch.name !== undefined) data.name = patch.name;
    if (patch.description !== undefined) data.description = patch.description;
    if (patch.onlineDisplayName !== undefined) data.onlineDisplayName = patch.onlineDisplayName;
    if (patch.categoryId !== undefined) data.categoryId = patch.categoryId;
    if (patch.isVeg !== undefined) data.isVeg = patch.isVeg;
    if (patch.priceMinor !== undefined) {
      data.price = typeof patch.priceMinor === "bigint" ? patch.priceMinor : BigInt(patch.priceMinor || 0);
    }
    if (patch.taxRate !== undefined) data.taxRate = Number(patch.taxRate).toFixed(2);
    if (patch.imageUrl !== undefined) data.imageUrl = patch.imageUrl;

    const updated = await this.prisma.menuItem.update({
      where: { id: itemId },
      data,
    });

    if (patch.shortCode !== undefined) {
      await this.prisma.$executeRaw`UPDATE menu_items SET short_code = ${patch.shortCode} WHERE id = ${itemId}::uuid`.catch(() => {});
    }
    if (patch.parcelPriceMinor !== undefined) {
      const v = patch.parcelPriceMinor === null ? null : BigInt(patch.parcelPriceMinor);
      await this.prisma.$executeRaw`UPDATE menu_items SET parcel_price = ${v} WHERE id = ${itemId}::uuid`.catch(() => {});
    }
    if (patch.parcelAvailable !== undefined) {
      await this.prisma.$executeRaw`UPDATE menu_items SET parcel_available = ${Boolean(patch.parcelAvailable)} WHERE id = ${itemId}::uuid`.catch(() => {});
    }
    if (patch.zomatoPriceMinor !== undefined) {
      const v = patch.zomatoPriceMinor === null ? null : BigInt(patch.zomatoPriceMinor);
      await this.prisma.$executeRaw`UPDATE menu_items SET zomato_price = ${v} WHERE id = ${itemId}::uuid`.catch(() => {});
    }
    if (patch.zomatoAvailable !== undefined) {
      await this.prisma.$executeRaw`UPDATE menu_items SET zomato_available = ${Boolean(patch.zomatoAvailable)} WHERE id = ${itemId}::uuid`.catch(() => {});
    }
    if (patch.swiggyPriceMinor !== undefined) {
      const v = patch.swiggyPriceMinor === null ? null : BigInt(patch.swiggyPriceMinor);
      await this.prisma.$executeRaw`UPDATE menu_items SET swiggy_price = ${v} WHERE id = ${itemId}::uuid`.catch(() => {});
    }
    if (patch.swiggyAvailable !== undefined) {
      await this.prisma.$executeRaw`UPDATE menu_items SET swiggy_available = ${Boolean(patch.swiggyAvailable)} WHERE id = ${itemId}::uuid`.catch(() => {});
    }

    return updated;
  }

  async deleteMenuItem(outletId: string, itemId: string) {
    // Soft delete: items may be referenced by historical orders/KOTs, so we
    // never hard-delete a menu item. isActive=false hides it from listAllItems.
    return this.prisma.menuItem.update({
      where: { id: itemId },
      data: { isActive: false },
    });
  }

  async updateCategory(outletId: string, categoryId: string, patch: { name?: string; description?: string; sortOrder?: number }) {
    const data: Record<string, unknown> = {};
    if (patch.name !== undefined) data.name = patch.name;
    if (patch.description !== undefined) data.description = patch.description;
    if (patch.sortOrder !== undefined) data.sortOrder = patch.sortOrder;
    return this.prisma.menuCategory.update({ where: { id: categoryId }, data });
  }

  async deleteCategory(outletId: string, categoryId: string) {
    // Soft delete: a category with existing items must not vanish from history.
    return this.prisma.menuCategory.update({
      where: { id: categoryId },
      data: { isActive: false },
    });
  }

  async listModifierGroups(outletId: string) {
    return this.prisma.modifierGroup.findMany({
      where: { outletId, is_active: true },
      orderBy: { name: "asc" },
    });
  }

  async listModifierOptions(outletId: string, modifierGroupId: string) {
    return (this.prisma as any).modifier_options.findMany({
      where: { outlet_id: outletId, modifier_group_id: modifierGroupId, is_active: true },
      orderBy: { sort_order: "asc" },
    });
  }

  async updateModifierGroup(outletId: string, groupId: string, patch: { name?: string; minSelect?: number; maxSelect?: number }) {
    const data: Record<string, unknown> = {};
    if (patch.name !== undefined) data.name = patch.name;
    if (patch.minSelect !== undefined) data.minSelect = patch.minSelect;
    if (patch.maxSelect !== undefined) data.maxSelect = patch.maxSelect;
    return this.prisma.modifierGroup.update({ where: { id: groupId }, data });
  }

  async deleteModifierGroup(outletId: string, groupId: string) {
    return this.prisma.modifierGroup.update({ where: { id: groupId }, data: { is_active: false } });
  }

  async unlinkModifierFromItem(menuItemId: string, modifierGroupId: string) {
    return (this.prisma as any).item_modifier_groups.deleteMany({
      where: { item_id: menuItemId, group_id: modifierGroupId },
    });
  }

  async linkModifierToItem(outletId: string, menuItemId: string, modifierGroupId: string) {
    return (this.prisma as any).item_modifier_groups.create({
      data: { outlet_id: outletId, item_id: menuItemId, group_id: modifierGroupId },
    });
  }

  async listCategories(outletId: string) {
    return this.prisma.menuCategory.findMany({
      where: { outletId, isActive: true },
      orderBy: { sortOrder: "asc" },
    });
  }

  private async fetchChannelPricingMap(itemIds: string[]) {
    if (itemIds.length === 0) return new Map();
    const rows = await this.prisma.$queryRaw<Array<{
      id: string;
      short_code: string | null;
      parcel_price: bigint | null;
      parcel_available: boolean | null;
      zomato_price: bigint | null;
      zomato_available: boolean | null;
      swiggy_price: bigint | null;
      swiggy_available: boolean | null;
    }>>`
      SELECT id::text, short_code, parcel_price, parcel_available, zomato_price, zomato_available, swiggy_price, swiggy_available
      FROM menu_items
      WHERE id = ANY(${itemIds}::uuid[])
    `.catch(() => []);
    return new Map(rows.map((r) => [r.id, r]));
  }

  async listAllItems(outletId: string): Promise<MenuItemView[]> {
    const rows = await this.prisma.menuItem.findMany({
      where: { outletId, isActive: true },
      include: { category: true },
      orderBy: { name: "asc" },
    });

    const channelMap = await this.fetchChannelPricingMap(rows.map((r: any) => r.id));

    const availRows = await this.prisma.$queryRaw<Array<{
      item_id: string;
      state: string;
      version: number;
      stock_qty: number | null;
    }>>`
      SELECT item_id, state::text, version, stock_qty
      FROM item_availability
      WHERE outlet_id = ${outletId}::uuid
    `.catch(() => []);

    const availMap = new Map<string, { isStocked: boolean; stockQty: number; version: number }>();
    for (const a of availRows) {
      const stock = a.stock_qty != null ? Number(a.stock_qty) : 100;
      availMap.set(a.item_id, {
        isStocked: a.state !== "OFF" && stock > 0,
        stockQty: stock,
        version: a.version || 1,
      });
    }

    return rows.map((row: any) => {
      const avail = availMap.get(row.id);
      const ch = channelMap.get(row.id);
      const stockQty = avail?.stockQty ?? 100;
      const isStocked = avail ? avail.isStocked : (row.isActive !== false);
      const baseMinor = row.priceMinor !== undefined
        ? BigInt(row.priceMinor)
        : (Number.isInteger(Number(row.price || 0)) && Number(row.price || 0) >= 100
            ? BigInt(Number(row.price || 0))
            : BigInt(Math.round(Number(row.price || 0) * 100)));

      return {
        id: row.id,
        outletId: row.outletId,
        categoryId: row.categoryId,
        categoryName: row.category?.name ?? "General",
        name: row.name,
        description: row.description,
        onlineDisplayName: row.onlineDisplayName || null,
        shortCode: ch?.short_code ?? null,
        imageUrl: (row as any).imageUrl || null,
        priceMinor: baseMinor,
        parcelPriceMinor: ch?.parcel_price != null ? BigInt(ch.parcel_price) : baseMinor,
        parcelAvailable: ch?.parcel_available ?? true,
        zomatoPriceMinor: ch?.zomato_price != null ? BigInt(ch.zomato_price) : baseMinor,
        zomatoAvailable: ch?.zomato_available ?? true,
        swiggyPriceMinor: ch?.swiggy_price != null ? BigInt(ch.swiggy_price) : baseMinor,
        swiggyAvailable: ch?.swiggy_available ?? true,
        isVeg: Boolean(row.isVeg),
        taxRate: (row.taxRate ?? 5.0).toString(),
        isActive: isStocked,
        isStocked,
        stockQty,
        availability: {
          isStocked,
          stockQty,
          version: avail?.version ?? 1,
        },
      };
    });
  }

  async listByCategory(categoryId: string): Promise<MenuItemView[]> {
    const rows = await this.prisma.menuItem.findMany({
      where: { categoryId, isActive: true },
      include: { category: true },
      orderBy: { name: "asc" },
    });
    const channelMap = await this.fetchChannelPricingMap(rows.map((r: any) => r.id));

    return rows.map((row: any) => {
      const ch = channelMap.get(row.id);
      const baseMinor = row.priceMinor !== undefined
        ? BigInt(row.priceMinor)
        : (Number.isInteger(Number(row.price || 0)) && Number(row.price || 0) >= 100
            ? BigInt(Number(row.price || 0))
            : BigInt(Math.round(Number(row.price || 0) * 100)));
      return {
        id: row.id,
        outletId: row.outletId,
        categoryId: row.categoryId,
        categoryName: row.category?.name ?? "General",
        name: row.name,
        description: row.description,
        onlineDisplayName: row.onlineDisplayName || null,
        shortCode: ch?.short_code ?? null,
        imageUrl: (row as any).imageUrl || null,
        priceMinor: baseMinor,
        parcelPriceMinor: ch?.parcel_price != null ? BigInt(ch.parcel_price) : baseMinor,
        parcelAvailable: ch?.parcel_available ?? true,
        zomatoPriceMinor: ch?.zomato_price != null ? BigInt(ch.zomato_price) : baseMinor,
        zomatoAvailable: ch?.zomato_available ?? true,
        swiggyPriceMinor: ch?.swiggy_price != null ? BigInt(ch.swiggy_price) : baseMinor,
        swiggyAvailable: ch?.swiggy_available ?? true,
        isVeg: Boolean(row.isVeg),
        taxRate: (row.taxRate ?? 5.0).toString(),
        isActive: row.isActive !== false,
        availability: {
          isStocked: true,
          stockQty: 100,
          version: 1,
        },
      };
    });
  }
}
