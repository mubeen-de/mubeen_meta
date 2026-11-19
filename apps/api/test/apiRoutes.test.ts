import { describe, expect, it } from 'vitest';
import request from 'supertest';
import { createApp } from '../src/app';

describe('Real API Gateway Routes', () => {
  const app = createApp();

  it('GET /healthz returns 200 ok', async () => {
    const res = await request(app).get('/healthz').expect(200);
    expect(res.body.status).toBe('ok');
  });

  it('POST /auth/login returns 400 or 401 when unauthenticated', async () => {
    const res = await request(app)
      .post('/auth/login')
      .send({ email: 'unknown@example.com', password: 'wrong' });
    expect([400, 401]).toContain(res.status);
  });

  it('GET /menu/items returns 401 when unauthorized', async () => {
    await request(app).get('/menu/items').expect(401);
  });

  it('GET /kitchen/stations returns 401 when unauthorized', async () => {
    await request(app).get('/kitchen/stations').expect(401);
  });

  it('isolates table active orders: table order does not leak to other tables', async () => {
    const { PrismaClient } = await import('@prisma/client');
    const prisma = new PrismaClient();
    const outletId = '11111111-1111-1111-1111-111111111111';

    await prisma.order.updateMany({
      where: {
        outletId,
        status: { in: ['DRAFT', 'PLACED', 'CONFIRMED', 'KOT_CREATED', 'IN_PREPARATION', 'READY', 'SERVED', 'HANDED_OVER'] },
      },
      data: { status: 'CANCELLED' },
    });
    await prisma.diningTable.updateMany({
      where: { outletId },
      data: { status: 'VACANT' },
    });

    const items = await prisma.menuItem.findMany({
      where: { outletId },
      take: 2,
    });
    const table = await prisma.diningTable.findFirst({
      where: { outletId },
    });

    if (!table || items.length < 2) {
      await prisma.$disconnect();
      throw new Error('Required seed data missing in database');
    }

    const loginRes = await request(app)
      .post('/auth/login')
      .send({ email: 'cashier@hotelkapila.com', password: 'password123', outletId })
      .expect(200);

    const token = loginRes.body.accessToken;

    // Create order on real table
    const orderRes = await request(app)
      .post('/orders')
      .set('Authorization', `Bearer ${token}`)
      .send({
        orderType: 'DINE_IN',
        terminalNumber: 'T-01',
        diningTableId: table.id,
        lines: [
          { menuItemId: items[0].id, quantity: 1 },
          { menuItemId: items[1].id, quantity: 1 },
        ],
      })
      .expect(201);

    expect(orderRes.body.id).toBeDefined();

    // Table active order should return the created order
    const activeRes = await request(app)
      .get(`/orders/by-table/${table.tableNumber}/active`)
      .set('Authorization', `Bearer ${token}`)
      .expect(200);

    expect(activeRes.body.items).toHaveLength(2);
    expect(activeRes.body.items.map((i: any) => i.menuItemId)).toContain(items[0].id);
    expect(activeRes.body.items.map((i: any) => i.menuItemId)).toContain(items[1].id);

    // Other table should return 404 (No active order)
    await request(app)
      .get('/orders/by-table/NONEXISTENT_TABLE/active')
      .set('Authorization', `Bearer ${token}`)
      .expect(404);

    await prisma.$disconnect();
  });
});
