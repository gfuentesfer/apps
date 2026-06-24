-- =============================================================================
-- MyArrows - Modelo de datos para selección de flechas por marca
-- PostgreSQL 15+
-- Base de datos: arrows
--
-- Fuentes públicas de referencia:
--   Easton Target/Hunting charts (PN 301055-A)
--   https://eastonarchery.com/selector/
--   Gold Tip Spine Selector
--   Black Eagle / 3 Rivers traditional charts
--
-- NOTA: Las tablas de fabricante son matrices (peso × longitud flecha → spine).
--       Este script crea la estructura + catálogos + reglas de ajuste Easton
--       + muestra de datos. La carga completa de cada PDF requiere importación
--       por marca (ver database/import/README en comentarios al final).
-- =============================================================================

-- =============================================================================
-- CATÁLOGOS GENERALES
-- =============================================================================

CREATE TABLE IF NOT EXISTS bow_type (
    id          SERIAL PRIMARY KEY,
    code        VARCHAR(30)  NOT NULL UNIQUE,
    description VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS shooting_style (
    id          SERIAL PRIMARY KEY,
    code        VARCHAR(50)  NOT NULL UNIQUE,
    description VARCHAR(150) NOT NULL,
    bow_type_id INTEGER      REFERENCES bow_type(id)
);

CREATE TABLE IF NOT EXISTS manufacturer (
    id         BIGSERIAL PRIMARY KEY,
    name       VARCHAR(100) NOT NULL UNIQUE,
    country    VARCHAR(100),
    website    VARCHAR(250),
    active     BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS point_weight (
    id     SERIAL PRIMARY KEY,
    grains INTEGER NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS chart_purpose (
    id          SERIAL PRIMARY KEY,
    code        VARCHAR(30) NOT NULL UNIQUE,
    description VARCHAR(100) NOT NULL
);

-- =============================================================================
-- TABLAS OFICIALES POR FABRICANTE
-- =============================================================================

CREATE TABLE IF NOT EXISTS manufacturer_chart (
    id              BIGSERIAL PRIMARY KEY,
    manufacturer_id BIGINT       NOT NULL REFERENCES manufacturer(id),
    chart_name      VARCHAR(200) NOT NULL,
    chart_purpose_id INTEGER     NOT NULL REFERENCES chart_purpose(id),
    bow_type_id     INTEGER      NOT NULL REFERENCES bow_type(id),
    shooting_style_id INTEGER    REFERENCES shooting_style(id),
    version         VARCHAR(50),
    publication_year INTEGER,
    reference_fps_min INTEGER,
    reference_fps_max INTEGER,
    reference_point_grains INTEGER NOT NULL DEFAULT 100,
    reference_release_type VARCHAR(30) NOT NULL DEFAULT 'MECHANICAL',
    source_url      TEXT,
    notes           TEXT,
    active          BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    UNIQUE (manufacturer_id, chart_name, version)
);

CREATE INDEX IF NOT EXISTS idx_chart_manufacturer ON manufacturer_chart(manufacturer_id);
CREATE INDEX IF NOT EXISTS idx_chart_bow_type ON manufacturer_chart(bow_type_id);

-- Reglas para calcular el "peso efectivo" antes de consultar la matriz
-- Ejemplo Easton: FPS 276-300 → -5 lbs; punta 125gr → +3 lbs
CREATE TABLE IF NOT EXISTS chart_adjustment_rule (
    id                  SERIAL PRIMARY KEY,
    chart_id            BIGINT       NOT NULL REFERENCES manufacturer_chart(id) ON DELETE CASCADE,
    rule_type           VARCHAR(40)  NOT NULL,
    -- FPS_BAND | POINT_WEIGHT | RELEASE_TYPE | LIMB_TYPE | INSERT_WEIGHT
    condition_min       NUMERIC(10,2),
    condition_max       NUMERIC(10,2),
    condition_code      VARCHAR(50),
    weight_delta_lbs    NUMERIC(6,2) NOT NULL,
    per_unit            NUMERIC(10,2),
  -- para punta: -3 lbs por cada 25 grains bajo 100
    unit_label          VARCHAR(30),
    sort_order          INTEGER      NOT NULL DEFAULT 0,
    notes               TEXT
);

CREATE INDEX IF NOT EXISTS idx_adjustment_chart ON chart_adjustment_rule(chart_id);

-- Matriz principal: peso efectivo + longitud flecha → spine recomendado
CREATE TABLE IF NOT EXISTS spine_chart_entry (
    id                      BIGSERIAL PRIMARY KEY,
    chart_id                BIGINT        NOT NULL REFERENCES manufacturer_chart(id) ON DELETE CASCADE,
    draw_weight_min         NUMERIC(6,2)  NOT NULL,
    draw_weight_max         NUMERIC(6,2)  NOT NULL,
    arrow_length_min        NUMERIC(6,2)  NOT NULL,
    arrow_length_max        NUMERIC(6,2)  NOT NULL,
    point_weight_grains     INTEGER       REFERENCES point_weight(grains),
    -- NULL = aplica a cualquier punta (chart base 100gr)
    recommended_spine       VARCHAR(30)   NOT NULL,
    -- ej: '500', '400', 'T3', '1816', '500-400'
    spine_numeric           INTEGER,
    spine_numeric_max       INTEGER,
    spine_group_code        VARCHAR(20),
    notes                   TEXT,
    CHECK (draw_weight_max >= draw_weight_min),
    CHECK (arrow_length_max >= arrow_length_min)
);

CREATE INDEX IF NOT EXISTS idx_spine_entry_lookup ON spine_chart_entry (
    chart_id, draw_weight_min, draw_weight_max, arrow_length_min, arrow_length_max
);

-- =============================================================================
-- MODELOS DE FLECHA POR MARCA
-- =============================================================================

CREATE TABLE IF NOT EXISTS arrow_model (
    id                  BIGSERIAL PRIMARY KEY,
    manufacturer_id     BIGINT       NOT NULL REFERENCES manufacturer(id),
    model_name          VARCHAR(150) NOT NULL,
    arrow_family        VARCHAR(100),
    material            VARCHAR(100),
    inside_diameter_mm  NUMERIC(6,3),
    outside_diameter_mm NUMERIC(6,3),
    description         TEXT,
    active              BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    UNIQUE (manufacturer_id, model_name)
);

CREATE TABLE IF NOT EXISTS arrow_model_spine (
    id                  BIGSERIAL PRIMARY KEY,
    arrow_model_id      BIGINT        NOT NULL REFERENCES arrow_model(id) ON DELETE CASCADE,
    spine               INTEGER       NOT NULL,
    spine_label         VARCHAR(30),
    gpi                 NUMERIC(8,3),
    max_length_inches   NUMERIC(6,2),
    straightness        VARCHAR(50),
    weight_tolerance    VARCHAR(50),
    notes               TEXT,
    UNIQUE (arrow_model_id, spine)
);

-- Relaciona una entrada de chart con modelos concretos de esa marca
CREATE TABLE IF NOT EXISTS chart_entry_arrow_model (
    id                  BIGSERIAL PRIMARY KEY,
    spine_chart_entry_id BIGINT       NOT NULL REFERENCES spine_chart_entry(id) ON DELETE CASCADE,
    arrow_model_spine_id BIGINT       NOT NULL REFERENCES arrow_model_spine(id) ON DELETE CASCADE,
    priority_order      INTEGER       NOT NULL DEFAULT 1,
    UNIQUE (spine_chart_entry_id, arrow_model_spine_id)
);

-- =============================================================================
-- CONFIGURACIONES DEL ARQUERO (entrada de la app)
-- =============================================================================

CREATE TABLE IF NOT EXISTS archer_setup (
    id                  BIGSERIAL PRIMARY KEY,
    firebase_uid        VARCHAR(128),
    nickname            VARCHAR(100),
    bow_type_id         INTEGER       NOT NULL REFERENCES bow_type(id),
    shooting_style_id   INTEGER       REFERENCES shooting_style(id),
    manufacturer_id     BIGINT        REFERENCES manufacturer(id),
    draw_weight_lbs     NUMERIC(6,2)  NOT NULL,
    draw_length_inches  NUMERIC(6,2)  NOT NULL,
    arrow_length_inches NUMERIC(6,2)  NOT NULL,
    point_weight_grains INTEGER       REFERENCES point_weight(grains),
    speed_fps           INTEGER,
    effective_draw_weight_lbs NUMERIC(6,2),
    recommended_spine   VARCHAR(30),
  notes               TEXT,
    created_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_archer_setup_uid ON archer_setup(firebase_uid);

-- =============================================================================
-- VISTAS
-- =============================================================================

CREATE OR REPLACE VIEW vw_arrow_models AS
SELECT
    am.id,
    mf.id   AS manufacturer_id,
    mf.name AS manufacturer,
    am.model_name,
    am.arrow_family,
    am.material,
    ams.spine,
    ams.spine_label,
    ams.gpi,
    ams.max_length_inches
FROM arrow_model am
JOIN manufacturer mf ON mf.id = am.manufacturer_id
JOIN arrow_model_spine ams ON ams.arrow_model_id = am.id
WHERE am.active = TRUE AND mf.active = TRUE;

-- =============================================================================
-- FUNCIÓN: peso efectivo según reglas del chart
-- =============================================================================

CREATE OR REPLACE FUNCTION fn_effective_draw_weight(
    p_chart_id          BIGINT,
    p_actual_weight     NUMERIC,
    p_point_grains      INTEGER DEFAULT 100,
    p_fps               INTEGER DEFAULT NULL,
    p_release_type      VARCHAR DEFAULT 'MECHANICAL',
    p_limb_type         VARCHAR DEFAULT 'CARBON_COMPETITION'
)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    v_weight NUMERIC := p_actual_weight;
    r RECORD;
    v_delta  NUMERIC;
    v_units  NUMERIC;
BEGIN
    FOR r IN
        SELECT *
        FROM chart_adjustment_rule
        WHERE chart_id = p_chart_id
        ORDER BY sort_order, id
    LOOP
        v_delta := 0;

        IF r.rule_type = 'FPS_BAND' AND p_fps IS NOT NULL THEN
            IF (r.condition_min IS NULL OR p_fps >= r.condition_min)
               AND (r.condition_max IS NULL OR p_fps <= r.condition_max) THEN
                v_delta := r.weight_delta_lbs;
            END IF;

        ELSIF r.rule_type = 'POINT_WEIGHT' AND p_point_grains IS NOT NULL THEN
            IF p_point_grains <> 100 AND r.per_unit IS NOT NULL THEN
                v_units := (p_point_grains - 100) / r.per_unit;
                v_delta := r.weight_delta_lbs * v_units;
            END IF;

        ELSIF r.rule_type = 'RELEASE_TYPE' AND p_release_type IS NOT NULL THEN
            IF r.condition_code = p_release_type THEN
                v_delta := r.weight_delta_lbs;
            END IF;

        ELSIF r.rule_type = 'LIMB_TYPE' AND p_limb_type IS NOT NULL THEN
            IF r.condition_code = p_limb_type THEN
                v_delta := r.weight_delta_lbs;
            END IF;
        END IF;

        v_weight := v_weight + v_delta;
    END LOOP;

    RETURN ROUND(v_weight, 2);
END;
$$;

-- =============================================================================
-- FUNCIÓN: recomendar spine + modelos
-- =============================================================================

CREATE OR REPLACE FUNCTION fn_recommend_arrows(
    p_manufacturer_id   BIGINT,
    p_bow_type_id       INTEGER,
    p_draw_weight_lbs   NUMERIC,
    p_arrow_length_in   NUMERIC,
    p_shooting_style_id INTEGER DEFAULT NULL,
    p_point_grains      INTEGER DEFAULT 100,
    p_fps               INTEGER DEFAULT NULL,
    p_release_type      VARCHAR DEFAULT 'MECHANICAL',
    p_limb_type         VARCHAR DEFAULT 'CARBON_COMPETITION'
)
RETURNS TABLE (
    chart_id            BIGINT,
    chart_name          VARCHAR,
    effective_weight    NUMERIC,
    recommended_spine   VARCHAR,
    spine_numeric       INTEGER,
    manufacturer        VARCHAR,
    model_name          VARCHAR,
    gpi                 NUMERIC,
    max_length_inches   NUMERIC,
    shaft_weight_grains NUMERIC,
    total_weight_grains NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_chart_id BIGINT;
    v_effective NUMERIC;
BEGIN
    SELECT mc.id
    INTO v_chart_id
    FROM manufacturer_chart mc
    WHERE mc.manufacturer_id = p_manufacturer_id
      AND mc.bow_type_id = p_bow_type_id
      AND (p_shooting_style_id IS NULL OR mc.shooting_style_id = p_shooting_style_id)
      AND mc.active = TRUE
    ORDER BY mc.publication_year DESC NULLS LAST, mc.id DESC
    LIMIT 1;

    IF v_chart_id IS NULL THEN
        RETURN;
    END IF;

    v_effective := fn_effective_draw_weight(
        v_chart_id, p_draw_weight_lbs, p_point_grains, p_fps, p_release_type, p_limb_type
    );

    RETURN QUERY
    SELECT
        mc.id,
        mc.chart_name::VARCHAR,
        v_effective,
        sce.recommended_spine::VARCHAR,
        sce.spine_numeric,
        mf.name::VARCHAR,
        am.model_name::VARCHAR,
        ams.gpi,
        ams.max_length_inches,
        ROUND((ams.gpi * p_arrow_length_in)::NUMERIC, 1),
        ROUND((ams.gpi * p_arrow_length_in + COALESCE(p_point_grains, 0))::NUMERIC, 1)
    FROM manufacturer_chart mc
    JOIN spine_chart_entry sce ON sce.chart_id = mc.id
    LEFT JOIN chart_entry_arrow_model cem
        ON cem.spine_chart_entry_id = sce.id
    LEFT JOIN arrow_model_spine ams ON ams.id = cem.arrow_model_spine_id
    LEFT JOIN arrow_model am ON am.id = ams.arrow_model_id
    LEFT JOIN manufacturer mf ON mf.id = am.manufacturer_id
    WHERE mc.id = v_chart_id
      AND v_effective BETWEEN sce.draw_weight_min AND sce.draw_weight_max
      AND p_arrow_length_in BETWEEN sce.arrow_length_min AND sce.arrow_length_max
      AND (sce.point_weight_grains IS NULL OR sce.point_weight_grains = p_point_grains)
    ORDER BY sce.spine_numeric NULLS LAST, am.model_name;
END;
$$;
