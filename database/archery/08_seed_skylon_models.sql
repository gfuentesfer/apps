-- Modelos Skylon y spines
INSERT INTO arrow_model (manufacturer_id, model_name, arrow_family, material, description)
SELECT m.id, v.model_name, v.family, 'Carbono', v.description
FROM manufacturer m
JOIN (VALUES
    ('Skylon', 'Brixxon', 'Novice', 'Flecha principiante recurvo/compuesto'),
    ('Skylon', 'Radius', 'Novice', 'Flecha principiante'),
    ('Skylon', 'Performa', 'Performa', 'Outdoor recurvo/compuesto'),
    ('Skylon', 'Precium', 'Precium', 'Outdoor premium'),
    ('Skylon', 'Preminens', 'Preminens', 'Outdoor ultimate'),
    ('Skylon', 'Paragon', 'Paragon', 'Competición outdoor'),
    ('Skylon', 'Bruxx', 'Bruxx', 'Indoor / 3D'),
    ('Skylon', 'Empros', 'Empros', 'Indoor / 3D'),
    ('Skylon', 'Edge', 'Hunting', 'Caza compuesto'),
    ('Skylon', 'Maverick', 'Hunting', 'Caza compuesto'),
    ('Skylon', 'Frontier', 'Hunting', 'Caza compuesto'),
    ('Skylon', 'Rove', 'Hunting', 'Caza compuesto'),
    ('Skylon', 'Savage', 'Hunting', 'Caza compuesto'),
    ('Skylon', 'Bentwood', 'Hunting', 'Caza tradicional')
) AS v(mfr, model_name, family, description) ON v.mfr = m.name
ON CONFLICT (manufacturer_id, model_name) DO NOTHING;

INSERT INTO arrow_model_spine (arrow_model_id, spine, spine_label, gpi, max_length_inches)
SELECT am.id, v.spine, v.label, v.gpi, 32.0
FROM arrow_model am
JOIN manufacturer m ON m.id = am.manufacturer_id
JOIN (VALUES
    ('Skylon', 'Brixxon', 1000, '1000', 7.5),
    ('Skylon', 'Brixxon', 900, '900-850', 7.2),
    ('Skylon', 'Brixxon', 850, '850-800', 7.0),
    ('Skylon', 'Brixxon', 800, '800-750', 6.8),
    ('Skylon', 'Brixxon', 750, '750-700', 6.5),
    ('Skylon', 'Brixxon', 700, '700-650', 6.3),
    ('Skylon', 'Brixxon', 650, '650-600', 6.1),
    ('Skylon', 'Brixxon', 600, '600-550', 5.9),
    ('Skylon', 'Brixxon', 550, '550-500', 5.7),
    ('Skylon', 'Brixxon', 500, '500', 5.5),
    ('Skylon', 'Brixxon', 450, '450', 5.3),
    ('Skylon', 'Brixxon', 400, '400', 5.1),
    ('Skylon', 'Paragon', 1000, '1000', 7.0),
    ('Skylon', 'Paragon', 600, '600-550', 6.0),
    ('Skylon', 'Performa', 600, '600-550', 6.2),
    ('Skylon', 'Performa', 500, '500-450', 5.8),
    ('Skylon', 'Preminens', 500, '500-450', 5.7),
    ('Skylon', 'Preminens', 450, '450-400', 5.5),
    ('Skylon', 'Edge', 800, '800', 8.5),
    ('Skylon', 'Edge', 700, '700', 8.0),
    ('Skylon', 'Edge', 600, '600-500', 7.5),
    ('Skylon', 'Edge', 500, '500-400', 7.0),
    ('Skylon', 'Edge', 400, '400-350', 6.5),
    ('Skylon', 'Maverick', 500, '500-400', 7.2),
    ('Skylon', 'Maverick', 400, '400-350', 6.8),
    ('Skylon', 'Maverick', 350, '350-300', 6.4),
    ('Skylon', 'Rove', 500, '500-400', 7.0),
    ('Skylon', 'Rove', 400, '400-350', 6.6),
    ('Skylon', 'Rove', 350, '350-300', 6.2)
) AS v(mfr, model, spine, label, gpi) ON v.mfr = m.name AND v.model = am.model_name
ON CONFLICT (arrow_model_id, spine) DO NOTHING;

-- Grupos Skylon en lookup
INSERT INTO spine_group_lookup (manufacturer_id, group_code, spine_numeric_min, spine_numeric_max, shaft_sizes)
SELECT m.id, g.code, g.min, g.max, g.models
FROM manufacturer m
CROSS JOIN (VALUES
    ('A1', 800, 1000, 'Brixxon/Edge/Bentwood'),
    ('A2', 700, 900, 'Brixxon/Edge'),
    ('A3', 700, 850, 'Brixxon/Edge'),
    ('A4', 500, 750, 'Brixxon/Edge'),
    ('A5', 500, 700, 'Brixxon/Edge'),
    ('A6', 400, 600, 'Brixxon/Maverick'),
    ('A7', 400, 500, 'Brixxon/Edge/Maverick'),
    ('A8', 350, 500, 'Maverick/Rove'),
    ('A9', 350, 450, 'Brixxon/Maverick'),
    ('A10', 300, 400, 'Brixxon/Empros'),
    ('A11', 300, 1100, 'Brixxon/Empros'),
    ('A12', 300, 1000, 'Empros/Paragon'),
    ('A13', 300, 600, 'Performa/Preminens')
) AS g(code, min, max, models)
WHERE m.name = 'Skylon'
ON CONFLICT (manufacturer_id, group_code) DO UPDATE
SET spine_numeric_min = EXCLUDED.spine_numeric_min,
    spine_numeric_max = EXCLUDED.spine_numeric_max,
    shaft_sizes = EXCLUDED.shaft_sizes;
