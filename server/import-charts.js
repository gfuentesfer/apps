const { createPool } = require('./db');
const fs = require('fs');
const path = require('path');
const { importCharts } = require('./lib/chart-importer');

async function main() {
  const pool = createPool();

  try {
    const lookupSql = fs.readFileSync(
      path.join(__dirname, '..', 'database', 'archery', '07_spine_group_lookup.sql'),
      'utf8',
    );
    await pool.query(lookupSql);

    const skylonSql = fs.readFileSync(
      path.join(__dirname, '..', 'database', 'archery', '08_seed_skylon_models.sql'),
      'utf8',
    );
    await pool.query(skylonSql);

    const eastonTargetSql = fs.readFileSync(
      path.join(__dirname, '..', 'database', 'archery', '09_seed_easton_target_models.sql'),
      'utf8',
    );
    await pool.query(eastonTargetSql);

    console.log('Importando charts Easton y Victory...');
    await importCharts(pool);

    const count = await pool.query('SELECT COUNT(*)::int AS n FROM spine_chart_entry');
    console.log(`Total celdas en spine_chart_entry: ${count.rows[0].n}`);
  } catch (error) {
    console.error('Error importando charts:', error.message);
    process.exit(1);
  } finally {
    await pool.end();
  }
}

main();
