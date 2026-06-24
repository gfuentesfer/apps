-- Muestra de datos de matriz spine (extraídos de fuentes públicas)
-- Fuente tradicional: StickBow Arrow Selection Guide (Anthony Camera, Chart C)
-- Fuente recurvo: simplificación Easton target (grupos → spine numérico aproximado)

-- ---------------------------------------------------------------------------
-- EASTON TRADITIONAL - datos StickBow Chart C (spine × 1000)
-- Bow draw weight lbs × arrow length inches → spine numérico
-- ---------------------------------------------------------------------------

INSERT INTO spine_chart_entry (
    chart_id, draw_weight_min, draw_weight_max,
    arrow_length_min, arrow_length_max,
    recommended_spine, spine_numeric, notes
)
SELECT mc.id, 18, 23, 28, 28, '1403', 1403, 'StickBow Chart C - 18-23 lbs @ 28"'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Traditional - Recurve/Longbow Finger'
UNION ALL SELECT mc.id, 18, 23, 30, 30, '1079', 1079, 'StickBow Chart C'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Traditional - Recurve/Longbow Finger'
UNION ALL SELECT mc.id, 18, 23, 32, 32, '880', 880, 'StickBow Chart C'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Traditional - Recurve/Longbow Finger'
UNION ALL SELECT mc.id, 24, 27, 28, 28, '1079', 1079, 'StickBow Chart C'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Traditional - Recurve/Longbow Finger'
UNION ALL SELECT mc.id, 24, 27, 30, 30, '880', 880, 'StickBow Chart C'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Traditional - Recurve/Longbow Finger'
UNION ALL SELECT mc.id, 24, 27, 32, 32, '756', 756, 'StickBow Chart C'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Traditional - Recurve/Longbow Finger'
UNION ALL SELECT mc.id, 28, 33, 28, 28, '880', 880, 'StickBow Chart C'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Traditional - Recurve/Longbow Finger'
UNION ALL SELECT mc.id, 28, 33, 30, 30, '756', 756, 'StickBow Chart C'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Traditional - Recurve/Longbow Finger'
UNION ALL SELECT mc.id, 28, 33, 32, 32, '623', 623, 'StickBow Chart C'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Traditional - Recurve/Longbow Finger'
UNION ALL SELECT mc.id, 34, 42, 28, 28, '756', 756, 'StickBow Chart C'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Traditional - Recurve/Longbow Finger'
UNION ALL SELECT mc.id, 34, 42, 30, 30, '623', 623, 'StickBow Chart C'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Traditional - Recurve/Longbow Finger'
UNION ALL SELECT mc.id, 34, 42, 32, 32, '531', 531, 'StickBow Chart C'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Traditional - Recurve/Longbow Finger';

-- ---------------------------------------------------------------------------
-- EASTON RECURVE - muestra target (peso lbs × longitud flecha → spine)
-- Basado en chart Easton target recurvo carbon (valores spine numéricos)
-- ---------------------------------------------------------------------------

INSERT INTO spine_chart_entry (
    chart_id, draw_weight_min, draw_weight_max,
    arrow_length_min, arrow_length_max,
    recommended_spine, spine_numeric, spine_group_code, notes
)
SELECT mc.id, 24, 28, 26, 26, '800', 800, 'Y6', 'Recurvo 24-28 lbs'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Target - Recurve Finger'
UNION ALL SELECT mc.id, 24, 28, 27, 27, '700', 700, 'Y7', 'Recurvo 24-28 lbs'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Target - Recurve Finger'
UNION ALL SELECT mc.id, 28, 32, 27, 27, '600', 600, 'T1', 'Recurvo 28-32 lbs'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Target - Recurve Finger'
UNION ALL SELECT mc.id, 28, 32, 28, 28, '500', 500, 'T2', 'Recurvo 28-32 lbs'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Target - Recurve Finger'
UNION ALL SELECT mc.id, 32, 36, 28, 28, '500', 500, 'T3', 'Recurvo 32-36 lbs'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Target - Recurve Finger'
UNION ALL SELECT mc.id, 32, 36, 29, 29, '400', 400, 'T4', 'Recurvo 32-36 lbs'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Target - Recurve Finger'
UNION ALL SELECT mc.id, 36, 40, 28, 28, '400', 400, 'T5', 'Recurvo 36-40 lbs'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Target - Recurve Finger'
UNION ALL SELECT mc.id, 40, 44, 29, 29, '340', 340, 'T7', 'Recurvo 40-44 lbs'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Target - Recurve Finger'
UNION ALL SELECT mc.id, 44, 48, 29, 29, '300', 300, 'T9', 'Recurvo 44-48 lbs'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Target - Recurve Finger'
UNION ALL SELECT mc.id, 48, 52, 30, 30, '250', 250, 'T11', 'Recurvo 48-52 lbs'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Target - Recurve Finger';

-- ---------------------------------------------------------------------------
-- EASTON COMPOUND - muestra hunting (spine range por peso y longitud)
-- Fuente: Easton 301055-A Hunting chart (sección compound release)
-- ---------------------------------------------------------------------------

INSERT INTO spine_chart_entry (
    chart_id, draw_weight_min, draw_weight_max,
    arrow_length_min, arrow_length_max,
    recommended_spine, spine_numeric, spine_numeric_max, notes
)
SELECT mc.id, 40, 43, 28, 28, '500-400', 400, 500, 'Compound 301-340 FPS ref'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Target - Compound Release'
UNION ALL SELECT mc.id, 40, 43, 29, 29, '400-350', 350, 400, 'Compound'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Target - Compound Release'
UNION ALL SELECT mc.id, 44, 47, 28, 28, '400-350', 350, 400, 'Compound'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Target - Compound Release'
UNION ALL SELECT mc.id, 44, 47, 29, 29, '350-300', 300, 350, 'Compound'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Target - Compound Release'
UNION ALL SELECT mc.id, 48, 52, 28, 28, '350-300', 300, 350, 'Compound'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Target - Compound Release'
UNION ALL SELECT mc.id, 48, 52, 29, 29, '300-250', 250, 300, 'Compound'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Target - Compound Release'
UNION ALL SELECT mc.id, 53, 57, 28, 28, '300-250', 250, 300, 'Compound'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Target - Compound Release'
UNION ALL SELECT mc.id, 58, 62, 29, 29, '250-200', 200, 250, 'Compound'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Target - Compound Release'
UNION ALL SELECT mc.id, 63, 67, 29, 29, '200-150', 150, 200, 'Compound alto peso'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Target - Compound Release';

-- ---------------------------------------------------------------------------
-- BAREBOW: reutiliza chart recurvo (misma matriz, estilo distinto en app)
-- ---------------------------------------------------------------------------

INSERT INTO manufacturer_chart (
    manufacturer_id, chart_name, chart_purpose_id, bow_type_id, shooting_style_id,
    version, publication_year, reference_point_grains, reference_release_type,
    source_url, notes
)
SELECT
    m.id,
    'Easton Target - Barebow Finger',
    cp.id,
    bt.id,
    ss.id,
    '301055-A',
    2024,
    100,
    'FINGER',
  'https://bowtuning.fr/images/Chart%20Easton/Arrow%20Shaft%20Selection%20Target.pdf',
    'Barebow usa chart recurvo. String walking requiere tuning adicional.'
FROM manufacturer m
CROSS JOIN chart_purpose cp
CROSS JOIN bow_type bt
CROSS JOIN shooting_style ss
WHERE m.name = 'Easton'
  AND cp.code = 'TARGET'
  AND bt.code = 'BAREBOW'
  AND ss.code = 'BAREBOW_STANDARD'
ON CONFLICT (manufacturer_id, chart_name, version) DO NOTHING;

-- Copiar entradas recurvo al chart barebow
INSERT INTO spine_chart_entry (
    chart_id, draw_weight_min, draw_weight_max,
    arrow_length_min, arrow_length_max,
    recommended_spine, spine_numeric, spine_group_code, notes
)
SELECT
    barebow.id,
    sce.draw_weight_min, sce.draw_weight_max,
    sce.arrow_length_min, sce.arrow_length_max,
    sce.recommended_spine, sce.spine_numeric, sce.spine_group_code,
    'Heredado de recurvo: ' || COALESCE(sce.notes, '')
FROM spine_chart_entry sce
JOIN manufacturer_chart recurve ON recurve.id = sce.chart_id
JOIN manufacturer_chart barebow ON barebow.chart_name = 'Easton Target - Barebow Finger'
WHERE recurve.chart_name = 'Easton Target - Recurve Finger';
