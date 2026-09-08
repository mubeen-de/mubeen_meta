(async () => {
  try {
    const outletId = '11111111-1111-1111-1111-111111111111';
    for (const email of ['admin@hotelkapila.com', 'cashier@hotelkapila.com']) {
      console.log(`\n=== Logging in as ${email} to outlet ${outletId} ===`);
      const loginRes = await fetch('http://localhost:4001/auth/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email, password: 'password123', outletId })
      });
      const loginData = await loginRes.json();
      console.log('Login status:', loginRes.status, 'User:', loginData.user);

      const token = loginData.accessToken;
      const testNum = 'test_verify_' + Date.now().toString().slice(-4);

      console.log(`Trying to create table ${testNum}...`);
      const tableRes = await fetch('http://localhost:4001/tables', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`
        },
        body: JSON.stringify({
          tableNumber: testNum,
          section: 'Non AC',
          capacity: 4
        })
      });

      console.log('Table create status:', tableRes.status);
      const tableData = await tableRes.json();
      console.log('Table create response:', tableData);
    }
  } catch (err) {
    console.error('Error:', err);
  }
})();
