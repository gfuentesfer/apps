const cors = require('cors');
const express = require('express');

const { createPool, getDatabaseMode } = require('./db');
const { createArrowsRouter } = require('./routes/arrows');
const { createCatalogRouter } = require('./routes/catalog');

const app = express();
const port = process.env.PORT || 3000;

const pool = createPool();
app.use(cors());
app.use(express.json());

app.get('/health', async (_req, res) => {
  try {
    await pool.query('SELECT 1');
    res.json({ status: 'ok', database: 'connected', mode: getDatabaseMode() });
  } catch (error) {
    res.status(503).json({ status: 'error', database: 'disconnected' });
  }
});

app.get('/menu', async (_req, res) => {
  try {
    const result = await pool.query(
      `SELECT id, title, subtitle, icon_name AS "iconName", route, sort_order AS "sortOrder"
       FROM menu_options WHERE is_active = TRUE
       ORDER BY sort_order ASC, id ASC`,
    );
    res.json(result.rows);
  } catch (error) {
    console.error('Error /menu:', error.message);
    res.status(500).json({ error: 'No se pudo cargar el menú' });
  }
});

app.use('/api/catalog', createCatalogRouter(pool));
app.use('/api/arrows', createArrowsRouter(pool));

app.listen(port, '0.0.0.0', () => {
  console.log(`MyArrows API listening on http://0.0.0.0:${port}`);
  console.log(`  Emulador Android: http://10.0.2.2:${port}`);
  console.log(`Database mode: ${getDatabaseMode()}`);
});