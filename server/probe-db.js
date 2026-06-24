const { createPool, getDatabaseMode } = require('./db');

async function probe() {
  const pool = createPool();
  const mode = getDatabaseMode();

  try {
    await pool.query('SELECT 1');
    const version = await pool.query('SELECT version()');
    const tables = await pool.query(
      "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' ORDER BY table_name",
    );

    console.log(`Modo: ${mode}`);
    console.log(version.rows[0].version.split(',')[0]);
    console.log(`Tablas (${tables.rows.length}): ${tables.rows.map((r) => r.table_name).join(', ') || '(ninguna)'}`);
  } catch (error) {
    console.error(`Error (${mode}):`, error.message);
    process.exit(1);
  } finally {
    await pool.end();
  }
}

probe();
