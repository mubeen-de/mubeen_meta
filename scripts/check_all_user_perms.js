const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

(async () => {
  const users = await prisma.user.findMany();
  const outlet = await prisma.outlet.findFirst({ where: { isActive: true } });

  console.log('Outlet:', outlet?.id, outlet?.name);

  for (const u of users) {
    const userRoles = await prisma.userRole.findMany({
      where: { userId: u.id },
      include: { role: { include: { rolePermissions: { include: { permission: true } } } } }
    });

    const roles = userRoles.map(ur => ur.role.name);
    const perms = new Set();
    userRoles.forEach(ur => {
      ur.role.rolePermissions.forEach(rp => {
        perms.add(rp.permission.code || rp.permission.action);
      });
    });

    console.log(`\nUser: ${u.email} (${u.firstName} ${u.lastName})`);
    console.log(`Roles: ${roles.join(', ')}`);
    console.log(`Has settings.manage: ${perms.has('settings.manage')}`);
    console.log(`Has table.manage: ${perms.has('table.manage')}`);
  }

  await prisma.$disconnect();
})();
