-- Modelos Easton target con grupos T/Y (chart PN 301055-A)
-- spine = valor mínimo del grupo para matching por rango en la API

INSERT INTO arrow_model (manufacturer_id, model_name, arrow_family, material, description)
SELECT m.id, v.model_name, v.family, v.material, v.description
FROM manufacturer m
JOIN (VALUES
    ('Easton', 'A/C Pro', 'A/C Pro', 'Aluminio/Carbono', 'Competition alloy/carbon pro'),
    ('Easton', 'Navigator', 'Navigator', 'Aluminio', 'Outdoor aluminum recurve'),
    ('Easton', 'Jazz', 'Jazz', 'Aluminio', 'Beginner aluminum')
) AS v(mfr, model_name, family, material, description) ON v.mfr = m.name
ON CONFLICT (manufacturer_id, model_name) DO NOTHING;

-- X10: grupos T1–T14 (target carbon)
INSERT INTO arrow_model_spine (arrow_model_id, spine, spine_label, gpi, max_length_inches)
SELECT am.id, v.spine, v.label, v.gpi, 32.0
FROM arrow_model am
JOIN manufacturer m ON m.id = am.manufacturer_id
JOIN (VALUES
    ('Easton', 'X10', 920,  'T1',  8.2),
    ('Easton', 'X10', 880,  'T2',  8.0),
    ('Easton', 'X10', 780,  'T3',  7.8),
    ('Easton', 'X10', 750,  'T4',  7.6),
    ('Easton', 'X10', 720,  'T5',  7.4),
    ('Easton', 'X10', 670,  'T6',  7.2),
    ('Easton', 'X10', 620,  'T7',  7.0),
    ('Easton', 'X10', 570,  'T8',  6.8),
    ('Easton', 'X10', 520,  'T9',  6.6),
    ('Easton', 'X10', 470,  'T10', 6.4),
    ('Easton', 'X10', 430,  'T11', 6.2),
    ('Easton', 'X10', 400,  'T12', 6.0),
    ('Easton', 'X10', 370,  'T13', 5.8),
    ('Easton', 'X10', 270,  'T14', 5.5)
) AS v(mfr, model, spine, label, gpi) ON v.mfr = m.name AND v.model = am.model_name
ON CONFLICT (arrow_model_id, spine) DO UPDATE
    SET spine_label = EXCLUDED.spine_label, gpi = EXCLUDED.gpi;

-- ACE: grupos T3–T14
INSERT INTO arrow_model_spine (arrow_model_id, spine, spine_label, gpi, max_length_inches)
SELECT am.id, v.spine, v.label, v.gpi, 32.0
FROM arrow_model am
JOIN manufacturer m ON m.id = am.manufacturer_id
JOIN (VALUES
    ('Easton', 'ACE', 780,  'T3',  8.0),
    ('Easton', 'ACE', 750,  'T4',  7.8),
    ('Easton', 'ACE', 720,  'T5',  7.6),
    ('Easton', 'ACE', 670,  'T6',  7.4),
    ('Easton', 'ACE', 620,  'T7',  7.2),
    ('Easton', 'ACE', 570,  'T8',  7.0),
    ('Easton', 'ACE', 520,  'T9',  6.8),
    ('Easton', 'ACE', 470,  'T10', 6.6),
    ('Easton', 'ACE', 430,  'T11', 6.4),
    ('Easton', 'ACE', 400,  'T12', 6.2),
    ('Easton', 'ACE', 370,  'T13', 6.0),
    ('Easton', 'ACE', 270,  'T14', 5.7)
) AS v(mfr, model, spine, label, gpi) ON v.mfr = m.name AND v.model = am.model_name
ON CONFLICT (arrow_model_id, spine) DO UPDATE
    SET spine_label = EXCLUDED.spine_label, gpi = EXCLUDED.gpi;

-- A/C Pro: grupos T1–T12
INSERT INTO arrow_model_spine (arrow_model_id, spine, spine_label, gpi, max_length_inches)
SELECT am.id, v.spine, v.label, v.gpi, 32.0
FROM arrow_model am
JOIN manufacturer m ON m.id = am.manufacturer_id
JOIN (VALUES
    ('Easton', 'A/C Pro', 920,  'T1',  8.4),
    ('Easton', 'A/C Pro', 880,  'T2',  8.2),
    ('Easton', 'A/C Pro', 780,  'T3',  8.0),
    ('Easton', 'A/C Pro', 750,  'T4',  7.8),
    ('Easton', 'A/C Pro', 720,  'T5',  7.6),
    ('Easton', 'A/C Pro', 670,  'T6',  7.4),
    ('Easton', 'A/C Pro', 620,  'T7',  7.2),
    ('Easton', 'A/C Pro', 570,  'T8',  7.0),
    ('Easton', 'A/C Pro', 520,  'T9',  6.8),
    ('Easton', 'A/C Pro', 470,  'T10', 6.6),
    ('Easton', 'A/C Pro', 430,  'T11', 6.4),
    ('Easton', 'A/C Pro', 400,  'T12', 6.2)
) AS v(mfr, model, spine, label, gpi) ON v.mfr = m.name AND v.model = am.model_name
ON CONFLICT (arrow_model_id, spine) DO NOTHING;

-- Navigator: aluminio outdoor (grupos 00–03, Y4–Y7)
INSERT INTO arrow_model_spine (arrow_model_id, spine, spine_label, gpi, max_length_inches)
SELECT am.id, v.spine, v.label, v.gpi, 32.0
FROM arrow_model am
JOIN manufacturer m ON m.id = am.manufacturer_id
JOIN (VALUES
    ('Easton', 'Navigator', 1800, '00', 9.5),
    ('Easton', 'Navigator', 1500, '01', 9.0),
    ('Easton', 'Navigator', 1250, '02', 8.5),
    ('Easton', 'Navigator', 1100, '03', 8.0),
    ('Easton', 'Navigator', 1416, 'Y4', 8.8),
    ('Easton', 'Navigator', 1250, 'Y5', 8.4),
    ('Easton', 'Navigator', 1150, 'Y6', 8.0),
    ('Easton', 'Navigator', 1000, 'Y7', 7.6)
) AS v(mfr, model, spine, label, gpi) ON v.mfr = m.name AND v.model = am.model_name
ON CONFLICT (arrow_model_id, spine) DO NOTHING;

-- Jazz: principiante aluminio (Y1–Y7)
INSERT INTO arrow_model_spine (arrow_model_id, spine, spine_label, gpi, max_length_inches)
SELECT am.id, v.spine, v.label, v.gpi, 32.0
FROM arrow_model am
JOIN manufacturer m ON m.id = am.manufacturer_id
JOIN (VALUES
    ('Easton', 'Jazz', 2000, 'Y1', 9.8),
    ('Easton', 'Jazz', 1800, 'Y2', 9.4),
    ('Easton', 'Jazz', 1600, 'Y3', 9.0),
    ('Easton', 'Jazz', 1416, 'Y4', 8.6),
    ('Easton', 'Jazz', 1250, 'Y5', 8.2),
    ('Easton', 'Jazz', 1150, 'Y6', 7.8),
    ('Easton', 'Jazz', 1000, 'Y7', 7.4)
) AS v(mfr, model, spine, label, gpi) ON v.mfr = m.name AND v.model = am.model_name
ON CONFLICT (arrow_model_id, spine) DO NOTHING;
