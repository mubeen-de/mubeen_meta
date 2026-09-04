const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  const users = await prisma.user.findMany({ select: { id: true, email: true, firstName: true, lastName: true } });
  console.log('USERS:', JSON.stringify(users, null, 2));
  const roles = await prisma.role.findMany();
  console.log('ROLES:', JSON.stringify(roles, null, 2));
  const userRoles = await prisma.userRole.findMany();
  console.log('USER ROLES:', JSON.stringify(userRoles, null, 2));
  const billSettle = await prisma.permission.findFirst({ where: { action: 'bill.settle' } });
  console.log('BILL SETTLE PERM:', billSettle);
  if (billSettle) {
    const rps = await prisma.rolePermission.findMany({ where: { permissionId: billSettle.id } });
    console.log('ROLES WITH BILL SETTLE:', rps);
  }
  const sessions = await prisma.session.findMany({
    take: 10,
    orderBy: { createdAt: 'desc' },
    include: { user: true }
  });
  console.log('RECENT SESSIONS:', JSON.stringify(sessions.map(s => ({
    id: s.id,
    userId: s.userId,
    userEmail: s.user?.email,
    userName: s.user?.firstName + ' ' + s.user?.lastName,
    outletId: s.outletId,
    createdAt: s.createdAt
  })), null, 2));
}

main().catch(console.error).finally(() => prisma.$disconnect());
