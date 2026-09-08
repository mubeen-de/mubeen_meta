const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

(async () => {
  try {
    const abdulId = 'd119207c-8cf7-4a03-8125-6737c85c210d';
    const cashierId = '4bc4d34d-f0d4-4402-ae14-2ab128803657';
    const outletId = '11111111-1111-1111-1111-111111111111';

    for (const [name, uid] of [['Abdul', abdulId], ['Cashier', cashierId]]) {
      console.log(`\n=== Testing for ${name} (${uid}) ===`);
      const userRoles = await prisma.userRole.findMany({
        where: {
          userId: uid,
          OR: [{ outletId }, { outletId: null }],
        },
      });
      console.log('userRoles returned:', userRoles);

      const roleIds = userRoles.map((ur) => ur.roleId).filter(Boolean);
      console.log('roleIds:', roleIds);

      const roles = prisma.role ? await prisma.role.findMany({ where: { id: { in: roleIds } } }) : [];
      console.log('roles:', roles);

      const rolePerms = prisma.rolePermission ? await prisma.rolePermission.findMany({ where: { roleId: { in: roleIds } } }) : [];
      const permIds = rolePerms.map((rp) => rp.permissionId).filter(Boolean);
      const perms = prisma.permission ? await prisma.permission.findMany({ where: { id: { in: permIds } } }) : [];

      console.log('perm count:', perms.length);

      const isSuperAdmin = roles.some(
        (r) =>
          r.name === "SUPER_ADMIN" ||
          r.name === "ADMIN" ||
          r.name === "Administrator" ||
          r.code === "ADMIN" ||
          r.code === "SUPER_ADMIN"
      );
      console.log('isSuperAdmin:', isSuperAdmin);

      for (const act of ['settings.manage', 'table.manage', 'menu.manage', 'menu.item.create', 'order.create']) {
        const has = perms.some((p) => (p.code || p.action) === act);
        console.log(`Action "${act}": has=${has}, allowed=${isSuperAdmin || has}`);
      }
    }
  } catch (err) {
    console.error(err);
  } finally {
    await prisma.$disconnect();
  }
})();
