const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  const waiterRole = await prisma.role.findFirst({ where: { name: 'WAITER' } });
  if (!waiterRole) {
    console.log('WAITER role not found');
    return;
  }
  console.log('WAITER role found:', waiterRole.id);

  const permsToAdd = [
    'bill.settle',
    'bill.generate',
    'bill.split',
    'bill.reprint',
    'payment.collect',
    'payment.split'
  ];

  for (const action of permsToAdd) {
    let perm = await prisma.permission.findFirst({ where: { action } });
    if (!perm) {
      perm = await prisma.permission.create({
        data: {
          action,
          description: `Permission for ${action}`
        }
      });
      console.log(`Created permission ${action}:`, perm.id);
    }

    const existingRp = await prisma.rolePermission.findFirst({
      where: {
        roleId: waiterRole.id,
        permissionId: perm.id
      }
    });

    if (!existingRp) {
      await prisma.rolePermission.create({
        data: {
          roleId: waiterRole.id,
          permissionId: perm.id
        }
      });
      console.log(`Granted ${action} to WAITER role`);
    } else {
      console.log(`WAITER already has ${action}`);
    }
  }

  console.log('Permissions successfully updated for WAITER role!');
}

main().catch(console.error).finally(() => prisma.$disconnect());
