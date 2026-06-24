const express = require('express');

function num(value, name) {
  const parsed = Number(value);
  if (Number.isNaN(parsed)) throw new Error(`Campo inválido: ${name}`);
  return parsed;
}

function createArrowsRouter(pool) {
  const router = express.Router();

  router.post('/recommend', async (req, res) => {
    try {
      const {
        manufacturerId,
        manufacturerName,
        bowTypeId,
        shootingStyleId,
        drawWeightLbs,
        drawLengthInches,
        arrowLengthInches,
        pointWeightGrains = 100,
        speedFps,
        releaseType = 'MECHANICAL',
        limbType = 'CARBON_COMPETITION',
        saveSetup = false,
        nickname,
        firebaseUid,
      } = req.body;

      if (!bowTypeId || drawWeightLbs == null || drawLengthInches == null) {
        return res.status(400).json({
          error: 'Faltan campos: bowTypeId, drawWeightLbs, drawLengthInches',
        });
      }

      let mfrId = manufacturerId;
      if (!mfrId && manufacturerName) {
        const mfr = await pool.query(
          'SELECT id FROM manufacturer WHERE name ILIKE $1',
          [manufacturerName],
        );
        mfrId = mfr.rows[0]?.id;
      }
      if (!mfrId) {
        return res.status(400).json({ error: 'Fabricante no especificado' });
      }

      const drawWeight = num(drawWeightLbs, 'drawWeightLbs');
      const drawLength = num(drawLengthInches, 'drawLengthInches');
      const arrowLength = arrowLengthInches != null
        ? num(arrowLengthInches, 'arrowLengthInches')
        : drawLength + 1;
      const pointWeight = pointWeightGrains != null
        ? num(pointWeightGrains, 'pointWeightGrains')
        : 100;
      const fps = speedFps != null ? num(speedFps, 'speedFps') : null;

      const chartResult = await pool.query(
        `SELECT mc.id, mc.chart_name,
                mc.reference_fps_min AS "referenceFpsMin",
                mc.reference_fps_max AS "referenceFpsMax",
                mc.reference_point_grains AS "referencePointGrains",
                mc.reference_release_type AS "referenceReleaseType"
         FROM manufacturer_chart mc
         WHERE mc.manufacturer_id = $1
           AND mc.bow_type_id = $2
           AND ($3::int IS NULL OR mc.shooting_style_id = $3 OR mc.shooting_style_id IS NULL)
           AND mc.active = TRUE
         ORDER BY
           CASE WHEN mc.shooting_style_id = $3 THEN 0 ELSE 1 END,
           CASE WHEN mc.chart_name ILIKE '%aluminum%' THEN 1 ELSE 0 END,
           mc.publication_year DESC NULLS LAST,
           mc.id DESC
         LIMIT 1`,
        [mfrId, bowTypeId, shootingStyleId ?? null],
      );

      if (chartResult.rows.length === 0) {
        return res.status(404).json({ error: 'No hay chart para este fabricante y tipo de arco' });
      }

      const chartId = chartResult.rows[0].id;
      const chartName = chartResult.rows[0].chart_name;
      const chartMeta = chartResult.rows[0];
      const recommendedPointWeight = chartMeta.referencePointGrains ?? 100;
      const recommendedArrowLength = arrowLength;

      const effectiveResult = await pool.query(
        `SELECT fn_effective_draw_weight($1, $2, $3, $4, $5, $6) AS weight`,
        [chartId, drawWeight, pointWeight, fps, releaseType, limbType],
      );
      const effectiveWeight = Number(effectiveResult.rows[0].weight);

      const spineResult = await pool.query(
        `SELECT recommended_spine AS "recommendedSpine",
                spine_numeric AS "spineNumeric",
                spine_numeric_max AS "spineNumericMax",
                spine_group_code AS "spineGroupCode",
                arrow_length_min AS "arrowLengthMin",
                arrow_length_max AS "arrowLengthMax",
                draw_weight_min AS "drawWeightMin",
                draw_weight_max AS "drawWeightMax",
                notes
         FROM spine_chart_entry
         WHERE chart_id = $1
           AND $2 BETWEEN draw_weight_min AND draw_weight_max
           AND $3 BETWEEN arrow_length_min AND arrow_length_max
         ORDER BY spine_numeric NULLS LAST`,
        [chartId, effectiveWeight, arrowLength],
      );

      const spines = spineResult.rows;
      let arrows = [];

      if (spines.length > 0) {
        const spineValues = spines
          .flatMap((s) => [s.spineNumeric, s.spineNumericMax])
          .filter((v) => v != null);
        const spineMin = spineValues.length ? Math.min(...spineValues) : 0;
        const spineMax = spineValues.length ? Math.max(...spineValues) : 0;

        const arrowsResult = await pool.query(
          `SELECT DISTINCT ON (am.id, ams.spine)
                  am.id,
                  mf.name AS manufacturer,
                  mf.id AS "manufacturerId",
                  am.model_name AS "modelName",
                  am.arrow_family AS "arrowFamily",
                  am.material,
                  am.description,
                  ams.spine,
                  ams.spine_label AS "spineLabel",
                  ams.gpi,
                  ams.max_length_inches AS "maxLengthInches",
                  ROUND((ams.gpi * $3)::numeric, 1) AS "shaftWeightGrains",
                  ROUND((ams.gpi * $3 + $4)::numeric, 1) AS "totalWeightGrains"
           FROM arrow_model am
           JOIN manufacturer mf ON mf.id = am.manufacturer_id
           JOIN arrow_model_spine ams ON ams.arrow_model_id = am.id
           WHERE mf.id = $1
             AND ams.spine BETWEEN $2 AND $5
             AND ams.max_length_inches >= $3
           ORDER BY am.id, ams.spine, am.model_name`,
          [mfrId, spineMin, arrowLength, pointWeight, spineMax || spineMin],
        );
        arrows = arrowsResult.rows;
      }

      let setupId = null;
      if (saveSetup) {
        const setup = await pool.query(
          `INSERT INTO archer_setup (
             firebase_uid, nickname, bow_type_id, shooting_style_id, manufacturer_id,
             draw_weight_lbs, draw_length_inches, arrow_length_inches,
             point_weight_grains, speed_fps, effective_draw_weight_lbs,
             recommended_spine, notes
           ) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13)
           RETURNING id`,
          [
            firebaseUid ?? null,
            nickname ?? null,
            bowTypeId,
            shootingStyleId ?? null,
            mfrId,
            drawWeight,
            drawLength,
            arrowLength,
            pointWeight,
            fps,
            effectiveWeight,
            spines[0]?.recommendedSpine ?? null,
            `Chart: ${chartName}`,
          ],
        );
        setupId = setup.rows[0]?.id;
      }

      res.json({
        setupId,
        chartId,
        chartName,
        effectiveDrawWeightLbs: effectiveWeight,
        recommendations: {
          arrowLengthInches: recommendedArrowLength,
          pointWeightGrains: recommendedPointWeight,
          referenceFpsMin: chartMeta.referenceFpsMin,
          referenceFpsMax: chartMeta.referenceFpsMax,
          referenceReleaseType: chartMeta.referenceReleaseType,
        },
        input: {
          drawWeightLbs: drawWeight,
          drawLengthInches: drawLength,
          arrowLengthInches: arrowLength,
          pointWeightGrains: pointWeight,
          speedFps: fps,
        },
        spines,
        arrows,
        message: spines.length === 0
          ? 'Sin coincidencia en el chart para peso efectivo y longitud indicados.'
          : arrows.length === 0
            ? 'Spine encontrado. Añade modelos de flecha de esta marca en arrow_model.'
            : null,
      });
    } catch (error) {
      console.error('Recommend error:', error);
      res.status(error.message?.includes('inválido') ? 400 : 500).json({
        error: error.message || 'Error al calcular recomendación',
      });
    }
  });

  return router;
}

module.exports = { createArrowsRouter };
