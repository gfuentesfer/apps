-- Reglas de ajuste Easton (oficiales, chart PN 301055-A Target)
-- Fuente: https://goodarcher.com/wp-content/uploads/2024/09/Easton_Arrow_Shaft_Selection_Target.pdf

INSERT INTO manufacturer_chart (
    manufacturer_id, chart_name, chart_purpose_id, bow_type_id, shooting_style_id,
    version, publication_year, reference_fps_min, reference_fps_max,
    reference_point_grains, reference_release_type, source_url, notes
)
SELECT
    m.id,
    'Easton Target - Compound Release',
    cp.id,
    bt.id,
    ss.id,
    '301055-A',
    2024,
    301,
    320,
    100,
    'MECHANICAL',
    'https://eastonarchery.com/wp-content/uploads/2023/08/301055-A-Arrow-Shaft-Selection-Target.pdf',
    'Chart base: 301-320 FPS, punta 100gr glue-in, release mecánico'
FROM manufacturer m
CROSS JOIN chart_purpose cp
CROSS JOIN bow_type bt
CROSS JOIN shooting_style ss
WHERE m.name = 'Easton'
  AND cp.code = 'TARGET'
  AND bt.code = 'COMPOUND'
  AND ss.code = 'COMPOUND_RELEASE'
ON CONFLICT (manufacturer_id, chart_name, version) DO NOTHING;

INSERT INTO manufacturer_chart (
    manufacturer_id, chart_name, chart_purpose_id, bow_type_id, shooting_style_id,
    version, publication_year, reference_fps_min, reference_fps_max,
    reference_point_grains, reference_release_type, source_url, notes
)
SELECT
    m.id,
    'Easton Target - Recurve Finger',
    cp.id,
    bt.id,
    ss.id,
    '301055-A',
    2024,
    301,
    320,
    100,
    'FINGER',
    'https://bowtuning.fr/images/Chart%20Easton/Arrow%20Shaft%20Selection%20Target.pdf',
    'Recurvo carbon limbs 301-320 FPS, dedos. Elegir spine más débil si hay rango.'
FROM manufacturer m
CROSS JOIN chart_purpose cp
CROSS JOIN bow_type bt
CROSS JOIN shooting_style ss
WHERE m.name = 'Easton'
  AND cp.code = 'TARGET'
  AND bt.code = 'RECURVE'
  AND ss.code = 'OLYMPIC_RECURVE'
ON CONFLICT (manufacturer_id, chart_name, version) DO NOTHING;

INSERT INTO manufacturer_chart (
    manufacturer_id, chart_name, chart_purpose_id, bow_type_id, shooting_style_id,
    version, publication_year, reference_point_grains, reference_release_type,
    source_url, notes
)
SELECT
    m.id,
    'Easton Traditional - Recurve/Longbow Finger',
    cp.id,
    bt.id,
    ss.id,
    '301055-A',
    2024,
    100,
    'FINGER',
    'https://eastonarchery.com/wp-content/uploads/2023/08/301055-A-Arrow-Shaft-Selection-Hunting.pdf',
    'Sección tradicional recurvo/longbow del chart hunting'
FROM manufacturer m
CROSS JOIN chart_purpose cp
CROSS JOIN bow_type bt
CROSS JOIN shooting_style ss
WHERE m.name = 'Easton'
  AND cp.code = 'TRADITIONAL'
  AND bt.code = 'TRADITIONAL'
  AND ss.code = 'TRADITIONAL_FINGER'
ON CONFLICT (manufacturer_id, chart_name, version) DO NOTHING;

-- Ajustes FPS - Compound Target (chart Easton compound release)
INSERT INTO chart_adjustment_rule (chart_id, rule_type, condition_min, condition_max, weight_delta_lbs, sort_order, notes)
SELECT mc.id, 'FPS_BAND', NULL, 275, -10, 10, 'Hasta 275 FPS'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Target - Compound Release'
UNION ALL
SELECT mc.id, 'FPS_BAND', 276, 300, -5, 20, '276-300 FPS'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Target - Compound Release'
UNION ALL
SELECT mc.id, 'FPS_BAND', 301, 320, 0, 30, '301-320 FPS (referencia)'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Target - Compound Release'
UNION ALL
SELECT mc.id, 'FPS_BAND', 321, 340, 5, 40, '321-340 FPS'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Target - Compound Release'
UNION ALL
SELECT mc.id, 'FPS_BAND', 341, 350, 10, 50, '341-350 FPS'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Target - Compound Release'
UNION ALL
SELECT mc.id, 'FPS_BAND', 351, NULL, 15, 60, '351 FPS o más'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Target - Compound Release';

-- Ajuste release dedos (+5 lbs) en compound
INSERT INTO chart_adjustment_rule (chart_id, rule_type, condition_code, weight_delta_lbs, sort_order, notes)
SELECT mc.id, 'RELEASE_TYPE', 'FINGER', 5, 70, 'Compuesto con dedos: +5 lbs'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Target - Compound Release';

-- Ajuste punta: ±3 lbs por cada 25 grains respecto a 100gr
INSERT INTO chart_adjustment_rule (chart_id, rule_type, weight_delta_lbs, per_unit, unit_label, sort_order, notes)
SELECT mc.id, 'POINT_WEIGHT', 3, 25, 'grains', 80, '+3 lbs por cada 25gr sobre 100gr'
FROM manufacturer_chart mc
WHERE mc.chart_name IN (
    'Easton Target - Compound Release',
    'Easton Target - Recurve Finger',
    'Easton Traditional - Recurve/Longbow Finger'
);

-- Recurvo: madera/vidrio principiante -5 lbs
INSERT INTO chart_adjustment_rule (chart_id, rule_type, condition_code, weight_delta_lbs, sort_order, notes)
SELECT mc.id, 'LIMB_TYPE', 'WOOD_GLASS', -5, 90, 'Palas madera/vidrio principiante'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Target - Recurve Finger';
