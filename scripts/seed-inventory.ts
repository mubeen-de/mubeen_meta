import 'dotenv/config';
import { PrismaClient } from "@prisma/client";
import fs from "fs";
import path from "path";

const prisma = new PrismaClient();

async function seedInventory() {
  console.log("Loading inventory data from template...");
  const dataPath = path.resolve(__dirname, "../data/inventory-finance-template.json");
  
  if (!fs.existsSync(dataPath)) {
    console.error("inventory-finance-template.json not found!");
    process.exit(1);
  }

  const data = JSON.parse(fs.readFileSync(dataPath, "utf-8"));
  
  // Hardcode the first outlet for seeding purposes
  const outlet = await prisma.outlet.findFirst();
  if (!outlet) {
    console.error("No outlet found! Please run the main kapmeta/seed.ts first.");
    process.exit(1);
  }
  const outletId = outlet.id;

  console.log(`Seeding for Outlet ID: ${outletId}`);

  // 1. Seed Ingredients
  const ingredientNameMap = new Map<string, string>();
  for (const ing of data.ingredients) {
    let ingRecord = await prisma.ingredient.findFirst({
      where: { outletId, name: ing.name }
    });
    if (!ingRecord) {
      ingRecord = await prisma.ingredient.create({
        data: {
          outletId,
          name: ing.name,
          unitOfMeasure: ing.unitOfMeasure,
          reorderLevel: ing.reorderLevel,
          unitCost: ing.unitCost,
          currentStock: 100 // Seed with some initial stock
        }
      });
      console.log(`Created ingredient: ${ing.name}`);
    } else {
      console.log(`Ingredient ${ing.name} already exists.`);
    }
    ingredientNameMap.set(ing.name, ingRecord.id);
  }

  // 2. Seed Recipes
  for (const recipe of data.recipes) {
    // Find the menu item by name or partial match
    let menuItem = await prisma.menuItem.findFirst({
      where: {
        outletId,
        OR: [
          { name: recipe.menuItemName },
          { name: { contains: recipe.menuItemName, mode: 'insensitive' } }
        ]
      }
    });

    if (!menuItem) {
      let cat = await prisma.menuCategory.findFirst({ where: { outletId } });
      if (cat) {
        menuItem = await prisma.menuItem.create({
          data: {
            outletId,
            categoryId: cat.id,
            name: recipe.menuItemName,
            price: 32000n,
            isVeg: false,
            taxRate: 5.0,
            isActive: true,
          }
        });
        console.log(`Created missing menu item for recipe: ${recipe.menuItemName}`);
      }
    }

    if (!menuItem) {
      console.warn(`MenuItem '${recipe.menuItemName}' could not be resolved. Skipping recipe.`);
      continue;
    }

    // Check existing recipe
    let createdRecipe = await prisma.recipe.findFirst({
      where: { outletId, menuItemId: menuItem.id }
    });

    if (!createdRecipe) {
      createdRecipe = await prisma.recipe.create({
        data: {
          outletId,
          menuItemId: menuItem.id,
          version: 1,
          isActive: true
        }
      });
      console.log(`Created recipe for: ${menuItem.name}`);
    }

    // Create Recipe Ingredients
    for (const recipeIng of recipe.ingredients) {
      const ingredientId = ingredientNameMap.get(recipeIng.ingredientName);
      if (!ingredientId) {
        console.warn(`Ingredient '${recipeIng.ingredientName}' not found for recipe.`);
        continue;
      }

      const existingLine = await prisma.recipeIngredient.findFirst({
        where: { recipeId: createdRecipe.id, ingredientId }
      });

      if (!existingLine) {
        await prisma.recipeIngredient.create({
          data: {
            recipeId: createdRecipe.id,
            ingredientId,
            quantity: recipeIng.quantity,
            yieldPercent: recipeIng.yieldPercent
          }
        });
        console.log(`  Added recipe ingredient: ${recipeIng.ingredientName} (${recipeIng.quantity})`);
      }
    }
  }

  // 3. Seed Vendors
  for (const vendor of data.vendors) {
    const existingVendor = await prisma.vendor.findFirst({
      where: { outletId, name: vendor.name }
    });
    if (!existingVendor) {
      await prisma.vendor.create({
        data: {
          outletId,
          name: vendor.name,
          phone: vendor.phone,
          email: vendor.email,
          taxNumber: vendor.taxNumber
        }
      });
      console.log(`Created vendor: ${vendor.name}`);
    } else {
      console.log(`Vendor ${vendor.name} already exists.`);
    }
  }

  console.log("Inventory seeding completed successfully!");
}

seedInventory()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
