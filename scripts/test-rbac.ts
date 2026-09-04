import { PrismaClient } from "@prisma/client";
import { PrismaRbacChecker } from "../services/auth/src/rbac";

const prisma = new PrismaClient();
const rbac = new PrismaRbacChecker(prisma);

async function main() {
  const outlets = await prisma.outlet.findMany();
  console.log("ALL OUTLETS:", outlets.map(o => ({ id: o.id, name: o.name, code: o.code })));
  const users = await prisma.user.findMany();

  for (const outlet of outlets) {
    console.log(`\n=== TESTING OUTLET: ${outlet.name} (${outlet.id}) ===`);
    for (const u of users) {
      const settle = await rbac.checkPermission({
        userId: u.id,
        outletId: outlet.id,
        action: "bill.settle",
      });
      const create = await rbac.checkPermission({
        userId: u.id,
        outletId: outlet.id,
        action: "order.create",
      });
      console.log(`USER: ${u.email} (${u.firstName} ${u.lastName})`);
      console.log(`  bill.settle:`, settle);
      console.log(`  order.create:`, create);
    }
  }
}

main().catch(console.error).finally(() => prisma.$disconnect());
