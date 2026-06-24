-- =============================================================================
-- Catálogo de arcos compuestos: marcas, modelos y velocidad IBO de referencia
-- IBO: 70 lbs, 30" draw, 350 gr arrow, sin accesorios (dato publicado por fabricante)
-- =============================================================================

CREATE TABLE IF NOT EXISTS compound_bow_brand (
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(100) NOT NULL UNIQUE,
    country    VARCHAR(100),
    website    VARCHAR(250),
    active     BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS compound_bow_model (
    id                  SERIAL PRIMARY KEY,
    brand_id            INTEGER      NOT NULL REFERENCES compound_bow_brand(id) ON DELETE CASCADE,
    model_name          VARCHAR(150) NOT NULL,
    model_year          INTEGER,
    ibo_fps             INTEGER      NOT NULL,
    draw_weight_min_lbs NUMERIC(5, 2),
    draw_weight_max_lbs NUMERIC(5, 2),
    draw_length_min_in  NUMERIC(5, 2),
    draw_length_max_in  NUMERIC(5, 2),
    axle_to_axle_in     NUMERIC(5, 2),
    brace_height_in     NUMERIC(5, 2),
    notes               TEXT,
    active              BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    UNIQUE (brand_id, model_name, model_year)
);

CREATE INDEX IF NOT EXISTS idx_compound_bow_model_brand ON compound_bow_model(brand_id);

-- Marcas principales
INSERT INTO compound_bow_brand (name, country, website) VALUES
    ('Hoyt', 'USA', 'https://hoyt.com'),
    ('Mathews', 'USA', 'https://mathewsinc.com'),
    ('Bowtech', 'USA', 'https://bowtecharchery.com'),
    ('PSE', 'USA', 'https://pse-archery.com'),
    ('Prime', 'USA', 'https://primearchery.com'),
    ('Bear Archery', 'USA', 'https://beararchery.com'),
    ('Elite Archery', 'USA', 'https://elitearchery.com'),
    ('Darton Archery', 'USA', 'https://dartonarchery.com'),
    ('Mission', 'USA', 'https://missionarchery.com'),
    ('Athens Archery', 'USA', 'https://athensarchery.com')
ON CONFLICT (name) DO NOTHING;

-- Hoyt
INSERT INTO compound_bow_model (brand_id, model_name, model_year, ibo_fps, draw_weight_min_lbs, draw_weight_max_lbs, draw_length_min_in, draw_length_max_in, axle_to_axle_in, brace_height_in)
SELECT b.id, v.model_name, v.model_year, v.ibo_fps, v.dw_min, v.dw_max, v.dl_min, v.dl_max, v.ata, v.bh
FROM compound_bow_brand b
CROSS JOIN (VALUES
    ('RX-7 Ultra', 2025, 350, 40, 60, 25, 30, 33.00, 6.00),
    ('RX-7 33', 2025, 348, 40, 60, 25, 30, 33.00, 6.00),
    ('RX-7 30', 2025, 345, 40, 60, 25, 30, 30.00, 6.00),
    ('Ventum Pro 33', 2024, 346, 40, 60, 25, 30, 33.00, 6.10),
    ('Ventum Pro 30', 2024, 342, 40, 60, 25, 30, 30.00, 6.10),
    ('Carbon RX-8 33', 2023, 344, 40, 60, 25, 30, 33.00, 6.20),
    ('Torrex XT Long Draw', 2022, 332, 30, 70, 26, 32, 34.75, 7.00)
) AS v(model_name, model_year, ibo_fps, dw_min, dw_max, dl_min, dl_max, ata, bh)
WHERE b.name = 'Hoyt'
ON CONFLICT (brand_id, model_name, model_year) DO NOTHING;

-- Mathews
INSERT INTO compound_bow_model (brand_id, model_name, model_year, ibo_fps, draw_weight_min_lbs, draw_weight_max_lbs, draw_length_min_in, draw_length_max_in, axle_to_axle_in, brace_height_in)
SELECT b.id, v.model_name, v.model_year, v.ibo_fps, v.dw_min, v.dw_max, v.dl_min, v.dl_max, v.ata, v.bh
FROM compound_bow_brand b
CROSS JOIN (VALUES
    ('Lift X 33', 2025, 345, 50, 70, 25, 30, 33.00, 6.00),
    ('Lift X 29', 2025, 342, 50, 70, 25, 30, 29.00, 6.00),
    ('Phase 4 33', 2024, 343, 50, 70, 25, 30, 33.00, 6.00),
    ('Phase 4 29', 2024, 340, 50, 70, 25, 30, 29.00, 6.00),
    ('Halon X 33', 2023, 342, 50, 70, 25, 30, 33.00, 6.00),
    ('V3X 33', 2022, 340, 50, 70, 25, 30, 33.00, 6.00),
    ('Triax', 2021, 335, 50, 70, 25, 30, 30.00, 6.00)
) AS v(model_name, model_year, ibo_fps, dw_min, dw_max, dl_min, dl_max, ata, bh)
WHERE b.name = 'Mathews'
ON CONFLICT (brand_id, model_name, model_year) DO NOTHING;

-- Bowtech
INSERT INTO compound_bow_model (brand_id, model_name, model_year, ibo_fps, draw_weight_min_lbs, draw_weight_max_lbs, draw_length_min_in, draw_length_max_in, axle_to_axle_in, brace_height_in)
SELECT b.id, v.model_name, v.model_year, v.ibo_fps, v.dw_min, v.dw_max, v.dl_min, v.dl_max, v.ata, v.bh
FROM compound_bow_brand b
CROSS JOIN (VALUES
    ('Revolt X 34', 2024, 350, 50, 70, 25, 30, 34.00, 6.00),
    ('Revolt X 30', 2024, 346, 50, 70, 25, 30, 30.00, 6.00),
    ('Reckoning 38', 2024, 348, 50, 70, 25, 30, 38.00, 6.00),
    ('Carbon One X 34', 2023, 345, 50, 70, 25, 30, 34.00, 6.00),
    ('SR350', 2022, 350, 50, 70, 25, 30, 35.00, 6.00),
    ('Solution SS', 2021, 336, 50, 70, 25, 30, 32.00, 6.00)
) AS v(model_name, model_year, ibo_fps, dw_min, dw_max, dl_min, dl_max, ata, bh)
WHERE b.name = 'Bowtech'
ON CONFLICT (brand_id, model_name, model_year) DO NOTHING;

-- PSE
INSERT INTO compound_bow_model (brand_id, model_name, model_year, ibo_fps, draw_weight_min_lbs, draw_weight_max_lbs, draw_length_min_in, draw_length_max_in, axle_to_axle_in, brace_height_in)
SELECT b.id, v.model_name, v.model_year, v.ibo_fps, v.dw_min, v.dw_max, v.dl_min, v.dl_max, v.ata, v.bh
FROM compound_bow_brand b
CROSS JOIN (VALUES
    ('EVO NTN 33', 2024, 343, 50, 70, 25, 30, 33.00, 6.00),
    ('EVO NTN 30', 2024, 340, 50, 70, 25, 30, 30.00, 6.00),
    ('Xpedite NXT 33', 2023, 340, 50, 70, 25, 30, 33.00, 6.00),
    ('Brute NXT 32', 2023, 332, 50, 70, 25, 30, 32.00, 6.50),
    ('Stinger X 32', 2022, 328, 40, 70, 25, 30, 32.00, 7.00),
    ('Uprising 33', 2022, 320, 40, 70, 25, 30, 33.00, 7.00)
) AS v(model_name, model_year, ibo_fps, dw_min, dw_max, dl_min, dl_max, ata, bh)
WHERE b.name = 'PSE'
ON CONFLICT (brand_id, model_name, model_year) DO NOTHING;

-- Prime
INSERT INTO compound_bow_model (brand_id, model_name, model_year, ibo_fps, draw_weight_min_lbs, draw_weight_max_lbs, draw_length_min_in, draw_length_max_in, axle_to_axle_in, brace_height_in)
SELECT b.id, v.model_name, v.model_year, v.ibo_fps, v.dw_min, v.dw_max, v.dl_min, v.dl_max, v.ata, v.bh
FROM compound_bow_brand b
CROSS JOIN (VALUES
    ('Nexus 4 36', 2024, 344, 40, 80, 25, 30, 36.00, 6.00),
    ('Nexus 4 33', 2024, 341, 40, 80, 25, 30, 33.00, 6.00),
    ('Inline 5 35', 2023, 343, 40, 80, 25, 30, 35.00, 6.00),
    ('Inline 4 33', 2023, 340, 40, 80, 25, 30, 33.00, 6.00),
    ('Black 5', 2022, 338, 40, 80, 25, 30, 35.00, 6.00)
) AS v(model_name, model_year, ibo_fps, dw_min, dw_max, dl_min, dl_max, ata, bh)
WHERE b.name = 'Prime'
ON CONFLICT (brand_id, model_name, model_year) DO NOTHING;

-- Bear Archery
INSERT INTO compound_bow_model (brand_id, model_name, model_year, ibo_fps, draw_weight_min_lbs, draw_weight_max_lbs, draw_length_min_in, draw_length_max_in, axle_to_axle_in, brace_height_in)
SELECT b.id, v.model_name, v.model_year, v.ibo_fps, v.dw_min, v.dw_max, v.dl_min, v.dl_max, v.ata, v.bh
FROM compound_bow_brand b
CROSS JOIN (VALUES
    ('Alaskan XT', 2024, 335, 45, 70, 25, 30, 33.00, 6.50),
    ('Kuma 30', 2023, 338, 45, 70, 25, 30, 30.00, 6.50),
    ('Legion', 2023, 332, 45, 70, 25, 30, 32.00, 6.50),
    ('Species EV', 2022, 320, 45, 70, 25, 30, 30.00, 7.00)
) AS v(model_name, model_year, ibo_fps, dw_min, dw_max, dl_min, dl_max, ata, bh)
WHERE b.name = 'Bear Archery'
ON CONFLICT (brand_id, model_name, model_year) DO NOTHING;

-- Elite Archery
INSERT INTO compound_bow_model (brand_id, model_name, model_year, ibo_fps, draw_weight_min_lbs, draw_weight_max_lbs, draw_length_min_in, draw_length_max_in, axle_to_axle_in, brace_height_in)
SELECT b.id, v.model_name, v.model_year, v.ibo_fps, v.dw_min, v.dw_max, v.dl_min, v.dl_max, v.ata, v.bh
FROM compound_bow_brand b
CROSS JOIN (VALUES
    ('Enkore', 2024, 342, 40, 70, 25, 30, 33.00, 6.00),
    ('Remedy', 2023, 338, 40, 70, 25, 30, 33.00, 6.50),
    ('Ember', 2023, 328, 40, 70, 25, 30, 32.00, 6.50),
    ('Rezult 36', 2022, 340, 40, 70, 25, 30, 36.00, 6.00)
) AS v(model_name, model_year, ibo_fps, dw_min, dw_max, dl_min, dl_max, ata, bh)
WHERE b.name = 'Elite Archery'
ON CONFLICT (brand_id, model_name, model_year) DO NOTHING;

-- Darton Archery
INSERT INTO compound_bow_model (brand_id, model_name, model_year, ibo_fps, draw_weight_min_lbs, draw_weight_max_lbs, draw_length_min_in, draw_length_max_in, axle_to_axle_in, brace_height_in)
SELECT b.id, v.model_name, v.model_year, v.ibo_fps, v.dw_min, v.dw_max, v.dl_min, v.dl_max, v.ata, v.bh
FROM compound_bow_brand b
CROSS JOIN (VALUES
    ('MA-3', 2024, 336, 40, 70, 25, 30, 33.00, 6.50),
    ('MA-5', 2024, 340, 40, 70, 25, 30, 35.00, 6.50),
    ('Sovereign', 2023, 338, 40, 70, 25, 30, 34.00, 6.50)
) AS v(model_name, model_year, ibo_fps, dw_min, dw_max, dl_min, dl_max, ata, bh)
WHERE b.name = 'Darton Archery'
ON CONFLICT (brand_id, model_name, model_year) DO NOTHING;

-- Mission (entry / hunting line)
INSERT INTO compound_bow_model (brand_id, model_name, model_year, ibo_fps, draw_weight_min_lbs, draw_weight_max_lbs, draw_length_min_in, draw_length_max_in, axle_to_axle_in, brace_height_in)
SELECT b.id, v.model_name, v.model_year, v.ibo_fps, v.dw_min, v.dw_max, v.dl_min, v.dl_max, v.ata, v.bh
FROM compound_bow_brand b
CROSS JOIN (VALUES
    ('Switch', 2024, 328, 40, 70, 25, 30, 32.00, 7.00),
    ('Hammr', 2023, 318, 40, 70, 25, 30, 31.00, 7.00),
    ('Craze G2', 2022, 310, 30, 70, 25, 30, 30.00, 7.25)
) AS v(model_name, model_year, ibo_fps, dw_min, dw_max, dl_min, dl_max, ata, bh)
WHERE b.name = 'Mission'
ON CONFLICT (brand_id, model_name, model_year) DO NOTHING;

-- Athens Archery
INSERT INTO compound_bow_model (brand_id, model_name, model_year, ibo_fps, draw_weight_min_lbs, draw_weight_max_lbs, draw_length_min_in, draw_length_max_in, axle_to_axle_in, brace_height_in)
SELECT b.id, v.model_name, v.model_year, v.ibo_fps, v.dw_min, v.dw_max, v.dl_min, v.dl_max, v.ata, v.bh
FROM compound_bow_brand b
CROSS JOIN (VALUES
    ('AthenX 33', 2024, 342, 40, 70, 25, 30, 33.00, 6.00),
    ('AthenX 29', 2024, 338, 40, 70, 25, 30, 29.00, 6.00),
    ('Ridge 32', 2023, 332, 40, 70, 25, 30, 32.00, 6.50)
) AS v(model_name, model_year, ibo_fps, dw_min, dw_max, dl_min, dl_max, ata, bh)
WHERE b.name = 'Athens Archery'
ON CONFLICT (brand_id, model_name, model_year) DO NOTHING;
