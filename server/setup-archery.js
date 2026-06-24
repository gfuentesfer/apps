const fs = require('fs');
const path = require('path');

const { createPool } = require('./db');

const files = [
  '01_schema.sql',
  '02_seed_catalogs.sql',
  '03_seed_easton_rules.sql',
  '04_seed_sample_spine_data.sql',
  '05_seed_arrow_models.sql',
  '10_compound_bow_catalog.sql',
];

async function setupArchery() {
  const pool = createPool();
  const dir = path.join(__dirname, '..', 'database', 'archery');

  try {
    for (const file of files) {
      const sql = fs.readFileSync(path.join(dir, file), 'utf8');
      console.log(`Ejecutando ${file}...`);
      await pool.query(sql);
    }
    console.log('Esquema de flechas instalado correctamente.');
  } catch (error) {
    console.error('Error:', error.message);
    process.exit(1);
  } finally {
    await pool.end();
  }
}

setupArchery();
