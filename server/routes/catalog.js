const express = require('express');

function createCatalogRouter(pool) {
  const router = express.Router();

  router.get('/bow-types', async (_req, res) => {
    const result = await pool.query(
      'SELECT id, code, description FROM bow_type ORDER BY id',
    );
    res.json(result.rows);
  });

  router.get('/shooting-styles', async (req, res) => {
    const { bowTypeId } = req.query;
    const result = bowTypeId
      ? await pool.query(
          'SELECT id, code, description, bow_type_id AS "bowTypeId" FROM shooting_style WHERE bow_type_id = $1 ORDER BY id',
          [bowTypeId],
        )
      : await pool.query(
          'SELECT id, code, description, bow_type_id AS "bowTypeId" FROM shooting_style ORDER BY id',
        );
    res.json(result.rows);
  });

  router.get('/manufacturers', async (_req, res) => {
    const result = await pool.query(
      `SELECT id, name, country, website
       FROM manufacturer WHERE active = TRUE ORDER BY name`,
    );
    res.json(result.rows);
  });

  router.get('/point-weights', async (_req, res) => {
    const result = await pool.query(
      'SELECT id, grains FROM point_weight ORDER BY grains',
    );
    res.json(result.rows);
  });

  router.get('/compound-bow-brands', async (_req, res) => {
    const result = await pool.query(
      `SELECT id, name, country, website
       FROM compound_bow_brand WHERE active = TRUE ORDER BY name`,
    );
    res.json(result.rows);
  });

  router.get('/compound-bow-models', async (req, res) => {
    const { brandId } = req.query;
    if (!brandId) {
      res.status(400).json({ error: 'brandId requerido' });
      return;
    }
    const result = await pool.query(
      `SELECT id, brand_id AS "brandId", model_name AS "modelName",
              model_year AS "modelYear", ibo_fps AS "iboFps",
              draw_weight_min_lbs AS "drawWeightMinLbs",
              draw_weight_max_lbs AS "drawWeightMaxLbs",
              draw_length_min_in AS "drawLengthMinIn",
              draw_length_max_in AS "drawLengthMaxIn",
              axle_to_axle_in AS "axleToAxleIn",
              brace_height_in AS "braceHeightIn",
              notes
       FROM compound_bow_model
       WHERE brand_id = $1 AND active = TRUE
       ORDER BY model_year DESC NULLS LAST, model_name`,
      [brandId],
    );
    res.json(result.rows);
  });

  router.get('/charts', async (req, res) => {
    const { manufacturerId } = req.query;
    const result = manufacturerId
      ? await pool.query(
          `SELECT mc.id, mc.chart_name AS "chartName", bt.code AS "bowType",
                  ss.code AS "shootingStyle", cp.code AS purpose, mc.version,
                  mc.reference_fps_min AS "referenceFpsMin",
                  mc.reference_fps_max AS "referenceFpsMax",
                  mc.reference_point_grains AS "referencePointGrains"
           FROM manufacturer_chart mc
           JOIN bow_type bt ON bt.id = mc.bow_type_id
           LEFT JOIN shooting_style ss ON ss.id = mc.shooting_style_id
           JOIN chart_purpose cp ON cp.id = mc.chart_purpose_id
           WHERE mc.manufacturer_id = $1 AND mc.active = TRUE
           ORDER BY mc.chart_name`,
          [manufacturerId],
        )
      : await pool.query(
          `SELECT mc.id, m.name AS manufacturer, mc.chart_name AS "chartName",
                  bt.code AS "bowType", ss.code AS "shootingStyle"
           FROM manufacturer_chart mc
           JOIN manufacturer m ON m.id = mc.manufacturer_id
           JOIN bow_type bt ON bt.id = mc.bow_type_id
           LEFT JOIN shooting_style ss ON ss.id = mc.shooting_style_id
           WHERE mc.active = TRUE
           ORDER BY m.name, mc.chart_name`,
        );
    res.json(result.rows);
  });

  return router;
}

module.exports = { createCatalogRouter };
