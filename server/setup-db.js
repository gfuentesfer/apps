const fs = require('fs');
const path = require('path');

const { createPool } = require('./db');

async function setup() {
  const pool = createPool();
  const sqlPath = path.join(__dirname, '..', 'database', 'menu.sql');
  const sql = fs.readFileSync(sqlPath, 'utf8');

  try {
    await pool.query(sql);
    console.log('Base de datos inicializada correctamente.');
  } catch (error) {
    console.error('Error al inicializar la base de datos:', error.message);
    process.exit(1);
  } finally {
    await pool.end();
  }
}

setup();
