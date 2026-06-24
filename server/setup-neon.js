require('dotenv').config();

const fs = require('fs');
const path = require('path');

const { createPool } = require('./db');

const archeryFiles = [
  '01_schema.sql',
  '02_seed_catalogs.sql',
  '03_seed_easton_rules.sql',
  '04_seed_sample_spine_data.sql',
  '05_seed_arrow_models.sql',
  '10_compound_bow_catalog.sql',
];

async function runSqlFile(pool, label, filePath) {
  const sql = fs.readFileSync(filePath, 'utf8');
  console.log(`>> ${label}`);
  await pool.query(sql);
}

async function setupNeon() {
  if (!process.env.DATABASE_URL && !process.env.PGHOST && !process.env.PGUSER) {
    console.error(
      'Falta configuración de Neon en server/.env.\n' +
        'Usa PGHOST, PGUSER, PGPASSWORD, PGDATABASE o DATABASE_URL.',
    );
    process.exit(1);
  }

  const pool = createPool();
  const root = path.join(__dirname, '..', 'database');

  try {
    await pool.query('SELECT 1');
    console.log('Conectado a Neon.\n');

    await runSqlFile(pool, 'menu.sql', path.join(root, 'menu.sql'));

    const archeryDir = path.join(root, 'archery');
    for (const file of archeryFiles) {
      await runSqlFile(pool, `archery/${file}`, path.join(archeryDir, file));
    }

    const tables = await pool.query(
      "SELECT COUNT(*)::int AS n FROM information_schema.tables WHERE table_schema = 'public'",
    );
    console.log(`\nListo. Tablas en public: ${tables.rows[0].n}`);
  } catch (error) {
    console.error('Error:', error.message);
    process.exit(1);
  } finally {
    await pool.end();
  }
}

setupNeon();
