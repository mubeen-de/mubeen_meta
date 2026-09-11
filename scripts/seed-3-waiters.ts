import { PrismaClient } from "@prisma/client";
import bcrypt from "bcryptjs";

const prisma = new PrismaClient();

async function main() {
  console.log("[SEED] Adding 3 distinct waiters with PIN 1234...");

  const salt = await bcrypt.genSalt(10);
  const passwordHash = await bcrypt.hash("password123", salt);
  const pinHash = await bcrypt.hash("1234", salt);

  // 1. Ensure WAITER role exists
  let waiterRole = await prisma.role.findFirst({ where: { name: "WAITER" } });
  if (!waiterRole) {
    waiterRole = await prisma.role.create({
      data: {
        id: "11111111-1111-1111-1111-111111111106",
        name: "WAITER",
        description: "Captain / Waiter / Table Steward",
      },
    });
  }

  // 2. Define the 3 Waiters
  const waitersData = [
    {
      email: "ramesh@hotelkapila.com",
      firstName: "Ramesh",
      lastName: "Kumar",
      phone: "+91 9876543201",
    },
    {
      email: "suresh@hotelkapila.com",
      firstName: "Suresh",
      lastName: "Patel",
      phone: "+91 9876543202",
    },
    {
      email: "mahesh@hotelkapila.com",
      firstName: "Mahesh",
      lastName: "Verma",
      phone: "+91 9876543203",
    },
  ];

  for (const w of waitersData) {
    const user = await prisma.user.upsert({
      where: { email: w.email },
      update: {
        firstName: w.firstName,
        lastName: w.lastName,
        phone: w.phone,
        passwordHash,
        pinHash,
        isActive: true,
      },
      create: {
        email: w.email,
        firstName: w.firstName,
        lastName: w.lastName,
        phone: w.phone,
        passwordHash,
        pinHash,
        isActive: true,
      },
    });

    // Check if userRole already exists
    const existingRole = await prisma.userRole.findFirst({
      where: {
        userId: user.id,
        roleId: waiterRole.id,
      },
    });

    if (!existingRole) {
      await prisma.userRole.create({
        data: {
          userId: user.id,
          roleId: waiterRole.id,
          outletId: null, // org-wide / all outlets
        },
      });
    }

    console.log(`[SUCCESS] Waiter configured: ${user.firstName} ${user.lastName} (${user.email}) with PIN 1234`);
  }

  console.log("[DONE] All 3 waiters seeded successfully.");
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
