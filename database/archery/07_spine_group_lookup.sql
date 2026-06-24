-- Tabla auxiliar grupos Easton (T1, Y1, etc.)
CREATE TABLE IF NOT EXISTS spine_group_lookup (
    id                SERIAL PRIMARY KEY,
    manufacturer_id   BIGINT       NOT NULL REFERENCES manufacturer(id),
    group_code        VARCHAR(20)  NOT NULL,
    spine_numeric_min INTEGER      NOT NULL,
    spine_numeric_max INTEGER      NOT NULL,
    shaft_sizes       TEXT,
    UNIQUE (manufacturer_id, group_code)
);

-- Reglas Victory: ajuste IBO speed (similar Easton hunting)
INSERT INTO manufacturer_chart (
    manufacturer_id, chart_name, chart_purpose_id, bow_type_id, shooting_style_id,
    version, reference_fps_min, reference_fps_max, reference_point_grains,
    reference_release_type, source_url, notes
)
SELECT m.id, 'Victory VAP - Compound 315 FPS', cp.id, bt.id, ss.id,
       'VAP-315', 305, 325, 100, 'MECHANICAL',
       'https://victoryarchery.com/arrow-guide/',
       'Variante 315 IBO FPS - usar ajuste FPS en reglas'
FROM manufacturer m
CROSS JOIN chart_purpose cp
CROSS JOIN bow_type bt
CROSS JOIN shooting_style ss
WHERE m.name = 'Victory' AND cp.code = 'TARGET' AND bt.code = 'COMPOUND'
  AND ss.code = 'COMPOUND_RELEASE'
ON CONFLICT (manufacturer_id, chart_name, version) DO NOTHING;

-- Ajustes FPS Easton hunting (solo si no existen)
INSERT INTO chart_adjustment_rule (chart_id, rule_type, condition_min, condition_max, weight_delta_lbs, sort_order, notes)
SELECT mc.id, 'FPS_BAND', NULL, 300, -5, 10, 'Hasta 300 FPS'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Hunting - Compound Release'
  AND NOT EXISTS (SELECT 1 FROM chart_adjustment_rule r WHERE r.chart_id = mc.id AND r.condition_max = 300);

INSERT INTO chart_adjustment_rule (chart_id, rule_type, condition_min, condition_max, weight_delta_lbs, sort_order, notes)
SELECT mc.id, 'FPS_BAND', 301, 340, 0, 20, '301-340 FPS referencia hunting'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Hunting - Compound Release'
  AND NOT EXISTS (SELECT 1 FROM chart_adjustment_rule r WHERE r.chart_id = mc.id AND r.condition_min = 301);

INSERT INTO chart_adjustment_rule (chart_id, rule_type, condition_min, condition_max, weight_delta_lbs, sort_order, notes)
SELECT mc.id, 'FPS_BAND', 341, 350, 5, 30, '341-350 FPS'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Hunting - Compound Release'
  AND NOT EXISTS (SELECT 1 FROM chart_adjustment_rule r WHERE r.chart_id = mc.id AND r.condition_min = 341);

INSERT INTO chart_adjustment_rule (chart_id, rule_type, condition_min, condition_max, weight_delta_lbs, sort_order, notes)
SELECT mc.id, 'FPS_BAND', 351, NULL, 10, 40, '351+ FPS'
FROM manufacturer_chart mc WHERE mc.chart_name = 'Easton Hunting - Compound Release'
  AND NOT EXISTS (SELECT 1 FROM chart_adjustment_rule r WHERE r.chart_id = mc.id AND r.condition_min = 351);
