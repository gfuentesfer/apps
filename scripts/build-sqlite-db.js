const fs = require('fs');
const path = require('path');
const Database = require('better-sqlite3');
const { execSqlFile } = require('./pg-to-sqlite');
const { importCharts } = require('./sqlite-chart-importer');

const root = path.join(__dirname, '..');
const outDir = path.join(root, 'assets', 'database');
const outFile = path.join(outDir, 'myarrows.db');

const seedFiles = [
  path.join(root, 'database', 'archery', '02_seed_catalogs.sql'),
  path.join(root, 'database', 'archery', '03_seed_easton_rules.sql'),
  path.join(root, 'database', 'archery', '04_seed_sample_spine_data.sql'),
  path.join(root, 'database', 'archery', '05_seed_arrow_models.sql'),
  path.join(root, 'database', 'archery', '10_compound_bow_catalog.sql'),
  path.join(root, 'database', 'menu.sql'),
  path.join(root, 'database', 'archery', '07_spine_group_lookup.sql'),
  path.join(root, 'database', 'archery', '08_seed_skylon_models.sql'),
  path.join(root, 'database', 'archery', '09_seed_easton_target_models.sql'),
];

function main() {
  fs.mkdirSync(outDir, { recursive: true });
  if (fs.existsSync(outFile)) fs.unlinkSync(outFile);

  const db = new Database(outFile);
  db.pragma('foreign_keys = ON');

  console.log('Creando esquema SQLite...');
  const schema = fs.readFileSync(path.join(root, 'database', 'sqlite', 'schema.sql'), 'utf8');
  db.exec(schema);

  for (const file of seedFiles) {
    console.log(`Ejecutando ${path.basename(file)}...`);
    execSqlFile(db, fs.readFileSync(file, 'utf8'), file);
  }

  console.log('Importando charts Easton, Victory y Skylon...');
  importCharts(db);

  const counts = {
    spine_chart_entry: db.prepare('SELECT COUNT(*) AS n FROM spine_chart_entry').get().n,
    arrow_model: db.prepare('SELECT COUNT(*) AS n FROM arrow_model').get().n,
    compound_bow_model: db.prepare('SELECT COUNT(*) AS n FROM compound_bow_model').get().n,
  };

  db.close();
  const sizeMb = (fs.statSync(outFile).size / (1024 * 1024)).toFixed(2);
  console.log(`\nBase de datos generada: ${outFile}`);
  console.log(`Tamaño: ${sizeMb} MB`);
  console.log('Registros:', counts);
}

main();
