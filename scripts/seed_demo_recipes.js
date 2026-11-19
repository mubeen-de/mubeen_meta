const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

const OUTLET_ID = '11111111-1111-1111-1111-111111111111';

async function main() {
  console.log('Seeding ingredients and BOM recipes for outlet:', OUTLET_ID);

  // 1. Ingredients definition
  const ingredientsData = [
    { name: 'Idly Rice & Urad Batter', unit_of_measure: 'portion', unit_cost_minor: 1200n, current_stock_qty: 250 },
    { name: 'Vada Dal Batter & Herbs', unit_of_measure: 'portion', unit_cost_minor: 1500n, current_stock_qty: 200 },
    { name: 'Sambar Veggies & Dal', unit_of_measure: 'portion', unit_cost_minor: 800n, current_stock_qty: 300 },
    { name: 'Fresh Boneless Chicken', unit_of_measure: 'kg', unit_cost_minor: 24000n, current_stock_qty: 50 },
    { name: 'Aged Basmati Rice', unit_of_measure: 'kg', unit_cost_minor: 10000n, current_stock_qty: 100 },
    { name: 'Biryani Spices & Marinade', unit_of_measure: 'portion', unit_cost_minor: 2500n, current_stock_qty: 150 },
    { name: 'Fermented Dosa Batter', unit_of_measure: 'portion', unit_cost_minor: 1800n, current_stock_qty: 250 },
    { name: 'Spiced Gunpowder Podi & Ghee', unit_of_measure: 'portion', unit_cost_minor: 1400n, current_stock_qty: 180 },
    { name: 'Breakfast Buffet Assorted Prep', unit_of_measure: 'portion', unit_cost_minor: 7500n, current_stock_qty: 80 },
    { name: 'Poori Whole Wheat Dough & Oil', unit_of_measure: 'portion', unit_cost_minor: 800n, current_stock_qty: 200 },
    { name: 'Aloo Bhaji Masala', unit_of_measure: 'portion', unit_cost_minor: 700n, current_stock_qty: 150 },
    { name: 'Fresh Paneer Cubes', unit_of_measure: 'kg', unit_cost_minor: 32000n, current_stock_qty: 30 },
    { name: 'Filter Coffee Decoction & Milk', unit_of_measure: 'cup', unit_cost_minor: 1000n, current_stock_qty: 300 },
    { name: 'Special Masala Tea & Milk', unit_of_measure: 'cup', unit_cost_minor: 800n, current_stock_qty: 300 }
  ];

  const ingredientMap = new Map();

  for (const ing of ingredientsData) {
    let record = await prisma.ingredients.findFirst({
      where: { outlet_id: OUTLET_ID, name: ing.name }
    });
    if (!record) {
      record = await prisma.ingredients.create({
        data: {
          outlet_id: OUTLET_ID,
          name: ing.name,
          unit_of_measure: ing.unit_of_measure,
          unit_cost_minor: ing.unit_cost_minor,
          current_stock_qty: ing.current_stock_qty,
          is_active: true
        }
      });
    } else {
      record = await prisma.ingredients.update({
        where: { id: record.id },
        data: { unit_cost_minor: ing.unit_cost_minor }
      });
    }
    ingredientMap.set(ing.name, record.id);
  }

  // 2. Map of Dish Name to Recipe BOM definition
  const dishBOM = {
    '(2) Idly (1) Vada': [
      { name: 'Idly Rice & Urad Batter', qty: 1 },
      { name: 'Vada Dal Batter & Herbs', qty: 1 },
      { name: 'Sambar Veggies & Dal', qty: 1 }
    ],
    'Hotel Kapila Special Chicken Biryani (Boneless)': [
      { name: 'Aged Basmati Rice', qty: 0.25 },
      { name: 'Fresh Boneless Chicken', qty: 0.25 },
      { name: 'Biryani Spices & Marinade', qty: 1 }
    ],
    '(S) Idly': [
      { name: 'Idly Rice & Urad Batter', qty: 1 },
      { name: 'Sambar Veggies & Dal', qty: 1 }
    ],
    'Breakfast Buffet': [
      { name: 'Breakfast Buffet Assorted Prep', qty: 1 }
    ],
    '(S) Vada': [
      { name: 'Vada Dal Batter & Herbs', qty: 1 },
      { name: 'Sambar Veggies & Dal', qty: 0.5 }
    ],
    'Ghee Podi Dosa': [
      { name: 'Fermented Dosa Batter', qty: 1 },
      { name: 'Spiced Gunpowder Podi & Ghee', qty: 1 },
      { name: 'Sambar Veggies & Dal', qty: 0.5 }
    ],
    '(S) Vada Sambar': [
      { name: 'Vada Dal Batter & Herbs', qty: 1 },
      { name: 'Sambar Veggies & Dal', qty: 1 }
    ],
    'Extra Poori': [
      { name: 'Poori Whole Wheat Dough & Oil', qty: 1 }
    ],
    'Idly (2)': [
      { name: 'Idly Rice & Urad Batter', qty: 1 },
      { name: 'Sambar Veggies & Dal', qty: 1 }
    ],
    'Butter Masala Dosa': [
      { name: 'Fermented Dosa Batter', qty: 1 },
      { name: 'Aloo Bhaji Masala', qty: 1 },
      { name: 'Sambar Veggies & Dal', qty: 0.5 }
    ],
    'Hyderabadi Paneer Dum Biryani': [
      { name: 'Aged Basmati Rice', qty: 0.25 },
      { name: 'Fresh Paneer Cubes', qty: 0.2 },
      { name: 'Biryani Spices & Marinade', qty: 1 }
    ],
    'Filter Coffee': [
      { name: 'Filter Coffee Decoction & Milk', qty: 1 }
    ],
    'Special Masala Tea': [
      { name: 'Special Masala Tea & Milk', qty: 1 }
    ]
  };

  // 3. Find menu items and link recipes
  const menuItems = await prisma.menuItem.findMany({
    where: { outletId: OUTLET_ID }
  });

  let createdRecipesCount = 0;

  for (const item of menuItems) {
    const bom = dishBOM[item.name];
    if (!bom) continue;

    // Check existing recipe
    let existingRecipe = await prisma.recipes.findFirst({
      where: { outlet_id: OUTLET_ID, menu_item_id: item.id, is_active: true }
    });

    if (existingRecipe) {
      // Remove old recipe ingredients to update fresh
      await prisma.recipe_ingredients.deleteMany({
        where: { recipe_id: existingRecipe.id }
      });
    } else {
      existingRecipe = await prisma.recipes.create({
        data: {
          outlet_id: OUTLET_ID,
          menu_item_id: item.id,
          name: `${item.name} Recipe BOM`,
          yield_portions: '1',
          version: 1,
          is_active: true
        }
      });
    }

    // Insert recipe ingredients
    for (const line of bom) {
      const ingId = ingredientMap.get(line.name);
      if (!ingId) continue;
      await prisma.recipe_ingredients.create({
        data: {
          recipe_id: existingRecipe.id,
          ingredient_id: ingId,
          quantity: line.qty.toString()
        }
      });
    }

    createdRecipesCount++;
    console.log(`Linked Recipe BOM for: ${item.name}`);
  }

  console.log(`\nSuccessfully created/updated ${createdRecipesCount} recipe BOMs for outlet ${OUTLET_ID}!`);
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
