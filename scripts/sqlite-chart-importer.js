const { EASTON_SPINE_GROUPS } = require('../database/archery/data/easton-spine-groups');
const { parseSkylonGroup } = require('../database/archery/data/skylon-spine-groups');
const { parseSpineRange } = require('../database/archery/data/easton-spine-groups');

const CHARTS = [
  require('../database/archery/data/easton-hunting-compound'),
  require('../database/archery/data/easton-target-compound'),
  require('../database/archery/data/easton-target-recurve'),
  require('../database/archery/data/easton-target-recurve-aluminum'),
  require('../database/archery/data/victory-vap-compound'),
  require('../database/archery/data/victory-vap-recurve'),
  require('../database/archery/data/skylon-target-compound'),
  require('../database/archery/data/skylon-target-recurve'),
  require('../database/archery/data/skylon-hunting-compound'),
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

function importCharts(db) {
  const getMfr = db.prepare('SELECT id FROM manufacturer WHERE name = ?');
  const getPurpose = db.prepare('SELECT id FROM chart_purpose WHERE code = ?');
  const getBowType = db.prepare('SELECT id FROM bow_type WHERE code = ?');
  const getStyle = db.prepare('SELECT id FROM shooting_style WHERE code = ?');

  const upsertChart = db.prepare(`
    INSERT INTO manufacturer_chart (
      manufacturer_id, chart_name, chart_purpose_id, bow_type_id, shooting_style_id,
      version, publication_year, reference_fps_min, reference_fps_max,
      reference_point_grains, reference_release_type, source_url, notes, active
    ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,1)
    ON CONFLICT (manufacturer_id, chart_name, version)
    DO UPDATE SET
      source_url = excluded.source_url,
      notes = excluded.notes,
      active = 1
  `);

  const findChartId = db.prepare(`
    SELECT id FROM manufacturer_chart
    WHERE manufacturer_id = ? AND chart_name = ? AND version = ?
  `);

  const deleteEntries = db.prepare('DELETE FROM spine_chart_entry WHERE chart_id = ?');
  const insertEntry = db.prepare(`
    INSERT INTO spine_chart_entry (
      chart_id, draw_weight_min, draw_weight_max,
      arrow_length_min, arrow_length_max,
      recommended_spine, spine_numeric, spine_numeric_max, spine_group_code, notes
    ) VALUES (?,?,?,?,?,?,?,?,?,?)
  `);

  for (const chart of CHARTS) {
    const manufacturerId = getMfr.get(chart.manufacturer)?.id;
    if (!manufacturerId) {
      throw new Error(`Fabricante no encontrado: ${chart.manufacturer}`);
    }

    const purposeId = getPurpose.get(chart.chartPurpose).id;
    const bowTypeId = getBowType.get(chart.bowType).id;
    const shootingStyleId = chart.shootingStyle
      ? getStyle.get(chart.shootingStyle)?.id ?? null
      : null;

    upsertChart.run(
      manufacturerId,
      chart.chartName,
      purposeId,
      bowTypeId,
      shootingStyleId,
      chart.version,
      chart.publicationYear ?? null,
      chart.referenceFpsMin ?? null,
      chart.referenceFpsMax ?? null,
      chart.referencePointGrains ?? 100,
      chart.referenceReleaseType ?? 'MECHANICAL',
      chart.sourceUrl ?? null,
      `Importado automáticamente. ${chart.rows?.length ?? 0} filas de peso.`,
    );

    const chartId = findChartId.get(manufacturerId, chart.chartName, chart.version).id;
    deleteEntries.run(chartId);

    const entries = expandGroupRows(chart);
    for (const entry of entries) {
      insertEntry.run(
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
      );
    }

    console.log(`  ${chart.chartName}: ${entries.length} celdas`);
  }

  const easton = getMfr.get('Easton');
  if (easton) {
    const upsertGroup = db.prepare(`
      INSERT INTO spine_group_lookup (manufacturer_id, group_code, spine_numeric_min, spine_numeric_max)
      VALUES (?,?,?,?)
      ON CONFLICT (manufacturer_id, group_code) DO UPDATE SET
        spine_numeric_min = excluded.spine_numeric_min,
        spine_numeric_max = excluded.spine_numeric_max
    `);
    for (const [code, group] of Object.entries(EASTON_SPINE_GROUPS)) {
      upsertGroup.run(easton.id, code, group.min, group.max);
    }
  }
}

module.exports = { importCharts, CHARTS };
