-- Modelos de flecha por marca (catálogo de producto)
-- GPI y spine según fichas públicas de fabricante

INSERT INTO arrow_model (manufacturer_id, model_name, arrow_family, material, description)
SELECT m.id, v.model_name, v.family, v.material, v.description
FROM manufacturer m
JOIN (VALUES
    ('Easton', 'X10', 'X10', 'Aluminio/Carbono', 'Flecha olímpica premium'),
    ('Easton', 'ACE', 'ACE', 'Aluminio/Carbono', 'Competition alloy/carbon'),
    ('Easton', 'FMJ', 'FMJ', 'Aluminio/Carbono', 'Full metal jacket hunting'),
    ('Easton', 'Axis', 'Axis', 'Carbono', 'Caza carbono'),
    ('Gold Tip', 'Hunter', 'Hunter', 'Carbono', 'Caza general'),
    ('Gold Tip', 'Velocity', 'Velocity', 'Carbono', 'Alta velocidad'),
    ('Gold Tip', 'Traditional Classic', 'Traditional', 'Carbono', 'Tradicional'),
    ('Black Eagle', 'Outlaw', 'Outlaw', 'Carbono', 'Tradicional/hunting'),
    ('Black Eagle', 'Carnivore', 'Carnivore', 'Carbono', 'Caza'),
    ('Victory', 'VAP TKO', 'VAP', 'Carbono', 'Target/hunting'),
    ('Carbon Express', 'Maxima RED', 'Maxima', 'Carbono', 'Caza precision')
) AS v(mfr, model_name, family, material, description) ON v.mfr = m.name
ON CONFLICT (manufacturer_id, model_name) DO NOTHING;

INSERT INTO arrow_model_spine (arrow_model_id, spine, spine_label, gpi, max_length_inches)
SELECT am.id, v.spine, v.label, v.gpi, v.max_len
FROM arrow_model am
JOIN manufacturer m ON m.id = am.manufacturer_id
JOIN (VALUES
    ('Easton', 'X10', 400, '1214', 9.0, 32.0),
    ('Easton', 'X10', 500, '1416', 8.1, 32.0),
    ('Easton', 'X10', 600, '1616', 7.3, 32.0),
    ('Easton', 'ACE', 400, '1416', 8.5, 32.0),
    ('Easton', 'ACE', 500, '1616', 7.8, 32.0),
    ('Easton', 'FMJ', 300, '300', 11.3, 32.0),
    ('Easton', 'FMJ', 340, '340', 10.2, 32.0),
    ('Easton', 'FMJ', 400, '400', 9.1, 32.0),
    ('Easton', 'Axis', 250, '250', 10.7, 32.0),
    ('Easton', 'Axis', 300, '300', 9.5, 32.0),
    ('Easton', 'Axis', 340, '340', 8.9, 32.0),
    ('Gold Tip', 'Hunter', 400, '400', 8.2, 32.0),
    ('Gold Tip', 'Hunter', 500, '500', 7.4, 32.0),
    ('Gold Tip', 'Hunter', 600, '600', 6.6, 32.0),
    ('Gold Tip', 'Velocity', 300, '300', 7.9, 32.0),
    ('Gold Tip', 'Velocity', 340, '340', 7.2, 32.0),
    ('Gold Tip', 'Traditional Classic', 600, '600', 7.0, 32.0),
    ('Gold Tip', 'Traditional Classic', 700, '700', 6.2, 32.0),
    ('Black Eagle', 'Outlaw', 400, '400', 8.5, 32.0),
    ('Black Eagle', 'Outlaw', 500, '500', 7.6, 32.0),
    ('Black Eagle', 'Carnivore', 300, '300', 9.8, 32.0),
    ('Black Eagle', 'Carnivore', 350, '350', 9.1, 32.0),
    ('Victory', 'VAP TKO', 300, '300', 8.9, 32.0),
    ('Victory', 'VAP TKO', 350, '350', 8.2, 32.0),
    ('Carbon Express', 'Maxima RED', 250, '250', 9.1, 32.0),
    ('Carbon Express', 'Maxima RED', 350, '350', 8.0, 32.0)
) AS v(mfr, model, spine, label, gpi, max_len)
    ON v.mfr = m.name AND v.model = am.model_name
ON CONFLICT (arrow_model_id, spine) DO NOTHING;

-- Vincular modelos a entradas de chart por spine numérico cercano
INSERT INTO chart_entry_arrow_model (spine_chart_entry_id, arrow_model_spine_id, priority_order)
SELECT DISTINCT ON (sce.id, ams.id)
    sce.id,
    ams.id,
    1
FROM spine_chart_entry sce
JOIN manufacturer_chart mc ON mc.id = sce.chart_id
JOIN manufacturer m ON m.id = mc.manufacturer_id
JOIN arrow_model am ON am.manufacturer_id = m.id
JOIN arrow_model_spine ams ON ams.arrow_model_id = am.id
WHERE sce.spine_numeric IS NOT NULL
  AND ABS(ams.spine - sce.spine_numeric) <= 100
ORDER BY sce.id, ams.id, ABS(ams.spine - sce.spine_numeric);
