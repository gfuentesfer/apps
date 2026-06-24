const { Pool } = require('pg');
const { parseSpineRange, EASTON_SPINE_GROUPS } = require('../../database/archery/data/easton-spine-groups');
const { parseSkylonGroup } = require('../../database/archery/data/skylon-spine-groups');

const CHARTS = [
  require('../../database/archery/data/easton-hunting-compound'),
  require('../../database/archery/data/easton-target-compound'),
  require('../../database/archery/data/easton-target-recurve'),
  require('../../database/archery/data/easton-target-recurve-aluminum'),
  require('../../database/archery/data/victory-vap-compound'),
  require('../../database/archery/data/victory-vap-recurve'),
  require('../../database/archery/data/skylon-target-compound'),
  require('../../database/archery/data/skylon-target-recurve'),
  require('../../database/archery/data/skylon-hunting-compound'),
];

function expandGroupRows(chart) {
  const entries = [];
  const skylonBow = chart.skylonBowType || chart.bowType;

  const addRow = (row, lengths, values, valueType) => {
    values.forEach((value, index) => {
      if (!value || !lengths[index]) return;
      const length = lengths[index];
      let parsed;
      if (valueType === 'skylon_group') {
        const code = String(value).replace('GR ', '');
        parsed = parseSkylonGroup(code, skylonBow);
        if (String(value).startsWith('GR')) {
          parsed.notes = 'Grupo bajo peso Skylon (Radius/Brixxon)';
        } else {
          parsed.notes = `Grupo Skylon → ${parsed.models || 'ver chart'}`;
        }
      } else if (valueType === 'group') {
        parsed = parseSpineRange(value);
      } else if (valueType === 'spine') {
        parsed = { recommended: String(value), min: value, max: value, groupCode: null };
      } else {
        parsed = parseSpineRange(value);
        if (parsed.min == null && parsed.max == null) {
          parsed = { recommended: value, min: null, max: null, groupCode: null };
        }
      }
      entries.push({
        drawWeightMin: row.drawWeightMin,
        drawWeightMax: row.drawWeightMax,
        arrowLengthMin: length,
        arrowLengthMax: length,
        recommendedSpine: parsed.recommended,
        spineNumeric: parsed.min,
        spineNumericMax: parsed.max,
        spineGroupCode: parsed.groupCode,
        notes: parsed.notes ?? (valueType === 'shaft_size' ? 'Tamaño astil aluminio Easton' : null),
      });
    });
  };

  if (chart.rows) {
    chart.rows.forEach((row) => {
      if (row.spines) {
        addRow(row, chart.arrowLengths, row.spines, chart.valueType || 'range');
      } else if (row.groups) {
        const lengths = chart.arrowLengths.slice(0, row.groups.length);
        addRow(row, lengths, row.groups, chart.valueType || 'group');
      }
    });
  }

  if (chart.lowPoundageRows) {
    chart.lowPoundageRows.forEach((row) => {
      addRow(row, row.arrowLengths, row.groups, 'group');
    });
  }

  return entries;
}

async function importCharts(pool) {
  for (const chart of CHARTS) {
    const mfr = await pool.query(
      'SELECT id FROM manufacturer WHERE name = $1',
      [chart.manufacturer],
    );
    if (mfr.rows.length === 0) {
      throw new Error(`Fabricante no encontrado: ${chart.manufacturer}`);
    }
    const manufacturerId = mfr.rows[0].id;

    const purpose = await pool.query(
      'SELECT id FROM chart_purpose WHERE code = $1',
      [chart.chartPurpose],
    );
    const bowType = await pool.query(
      'SELECT id FROM bow_type WHERE code = $1',
      [chart.bowType],
    );
    const shootingStyle = chart.shootingStyle
      ? await pool.query(
          'SELECT id FROM shooting_style WHERE code = $1',
          [chart.shootingStyle],
        )
      : { rows: [] };

    const chartResult = await pool.query(
      `INSERT INTO manufacturer_chart (
         manufacturer_id, chart_name, chart_purpose_id, bow_type_id, shooting_style_id,
         version, publication_year, reference_fps_min, reference_fps_max,
         reference_point_grains, reference_release_type, source_url, notes, active
       ) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,TRUE)
       ON CONFLICT (manufacturer_id, chart_name, version)
       DO UPDATE SET
         source_url = EXCLUDED.source_url,
         notes = EXCLUDED.notes,
         active = TRUE
       RETURNING id`,
      [
        manufacturerId,
        chart.chartName,
        purpose.rows[0].id,
        bowType.rows[0].id,
        shootingStyle.rows[0]?.id ?? null,
        chart.version,
        chart.publicationYear ?? null,
        chart.referenceFpsMin ?? null,
        chart.referenceFpsMax ?? null,
        chart.referencePointGrains ?? 100,
        chart.referenceReleaseType ?? 'MECHANICAL',
        chart.sourceUrl ?? null,
        `Importado automáticamente. ${chart.rows?.length ?? 0} filas de peso.`,
      ],
    );

    const chartId = chartResult.rows[0].id;

    await pool.query('DELETE FROM spine_chart_entry WHERE chart_id = $1', [chartId]);

    const entries = expandGroupRows(chart);
    for (const entry of entries) {
      await pool.query(
        `INSERT INTO spine_chart_entry (
           chart_id, draw_weight_min, draw_weight_max,
           arrow_length_min, arrow_length_max,
           recommended_spine, spine_numeric, spine_numeric_max, spine_group_code, notes
         ) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10)`,
        [
          chartId,
          entry.drawWeightMin,
          entry.drawWeightMax,
          entry.arrowLengthMin,
          entry.arrowLengthMax,
          entry.recommendedSpine,
          entry.spineNumeric,
          entry.spineNumericMax,
          entry.spineGroupCode,
          entry.notes,
        ],
      );
    }

    console.log(`  ${chart.chartName}: ${entries.length} celdas`);
  }

  // Grupos Easton en tabla auxiliar si existe
  const hasLookup = await pool.query(`
    SELECT EXISTS (
      SELECT 1 FROM information_schema.tables
      WHERE table_name = 'spine_group_lookup'
    ) AS exists
  `);

  if (hasLookup.rows[0].exists) {
    const easton = await pool.query(
      "SELECT id FROM manufacturer WHERE name = 'Easton'",
    );
    for (const [code, group] of Object.entries(EASTON_SPINE_GROUPS)) {
      await pool.query(
        `INSERT INTO spine_group_lookup (manufacturer_id, group_code, spine_numeric_min, spine_numeric_max)
         VALUES ($1,$2,$3,$4)
         ON CONFLICT (manufacturer_id, group_code) DO UPDATE
         SET spine_numeric_min = EXCLUDED.spine_numeric_min,
             spine_numeric_max = EXCLUDED.spine_numeric_max`,
        [easton.rows[0].id, code, group.min, group.max],
      );
    }
  }
}

module.exports = { importCharts, CHARTS };
