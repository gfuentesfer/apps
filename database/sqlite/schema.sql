PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS bow_type (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    code        TEXT NOT NULL UNIQUE,
    description TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS shooting_style (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    code        TEXT NOT NULL UNIQUE,
    description TEXT NOT NULL,
    bow_type_id INTEGER REFERENCES bow_type(id)
);

CREATE TABLE IF NOT EXISTS manufacturer (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    name       TEXT NOT NULL UNIQUE,
    country    TEXT,
    website    TEXT,
    active     INTEGER NOT NULL DEFAULT 1,
    created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS point_weight (
    id     INTEGER PRIMARY KEY AUTOINCREMENT,
    grains INTEGER NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS chart_purpose (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    code        TEXT NOT NULL UNIQUE,
    description TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS manufacturer_chart (
    id                     INTEGER PRIMARY KEY AUTOINCREMENT,
    manufacturer_id        INTEGER NOT NULL REFERENCES manufacturer(id),
    chart_name             TEXT NOT NULL,
    chart_purpose_id       INTEGER NOT NULL REFERENCES chart_purpose(id),
    bow_type_id            INTEGER NOT NULL REFERENCES bow_type(id),
    shooting_style_id      INTEGER REFERENCES shooting_style(id),
    version                TEXT,
    publication_year       INTEGER,
    reference_fps_min      INTEGER,
    reference_fps_max      INTEGER,
    reference_point_grains INTEGER NOT NULL DEFAULT 100,
    reference_release_type TEXT NOT NULL DEFAULT 'MECHANICAL',
    source_url             TEXT,
    notes                  TEXT,
    active                 INTEGER NOT NULL DEFAULT 1,
    created_at             TEXT NOT NULL DEFAULT (datetime('now')),
    UNIQUE (manufacturer_id, chart_name, version)
);

CREATE INDEX IF NOT EXISTS idx_chart_manufacturer ON manufacturer_chart(manufacturer_id);
CREATE INDEX IF NOT EXISTS idx_chart_bow_type ON manufacturer_chart(bow_type_id);

CREATE TABLE IF NOT EXISTS chart_adjustment_rule (
    id               INTEGER PRIMARY KEY AUTOINCREMENT,
    chart_id         INTEGER NOT NULL REFERENCES manufacturer_chart(id) ON DELETE CASCADE,
    rule_type        TEXT NOT NULL,
    condition_min    REAL,
    condition_max    REAL,
    condition_code   TEXT,
    weight_delta_lbs REAL NOT NULL,
    per_unit         REAL,
    unit_label       TEXT,
    sort_order       INTEGER NOT NULL DEFAULT 0,
    notes            TEXT
);

CREATE INDEX IF NOT EXISTS idx_adjustment_chart ON chart_adjustment_rule(chart_id);

CREATE TABLE IF NOT EXISTS spine_chart_entry (
    id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    chart_id            INTEGER NOT NULL REFERENCES manufacturer_chart(id) ON DELETE CASCADE,
    draw_weight_min     REAL NOT NULL,
    draw_weight_max     REAL NOT NULL,
    arrow_length_min    REAL NOT NULL,
    arrow_length_max    REAL NOT NULL,
    point_weight_grains INTEGER REFERENCES point_weight(grains),
    recommended_spine   TEXT NOT NULL,
    spine_numeric       INTEGER,
    spine_numeric_max   INTEGER,
    spine_group_code    TEXT,
    notes               TEXT,
    CHECK (draw_weight_max >= draw_weight_min),
    CHECK (arrow_length_max >= arrow_length_min)
);

CREATE INDEX IF NOT EXISTS idx_spine_entry_lookup ON spine_chart_entry (
    chart_id, draw_weight_min, draw_weight_max, arrow_length_min, arrow_length_max
);

CREATE TABLE IF NOT EXISTS arrow_model (
    id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    manufacturer_id     INTEGER NOT NULL REFERENCES manufacturer(id),
    model_name          TEXT NOT NULL,
    arrow_family        TEXT,
    material            TEXT,
    inside_diameter_mm  REAL,
    outside_diameter_mm REAL,
    description         TEXT,
    active              INTEGER NOT NULL DEFAULT 1,
    created_at          TEXT NOT NULL DEFAULT (datetime('now')),
    UNIQUE (manufacturer_id, model_name)
);

CREATE TABLE IF NOT EXISTS arrow_model_spine (
    id                INTEGER PRIMARY KEY AUTOINCREMENT,
    arrow_model_id    INTEGER NOT NULL REFERENCES arrow_model(id) ON DELETE CASCADE,
    spine             INTEGER NOT NULL,
    spine_label       TEXT,
    gpi               REAL,
    max_length_inches REAL,
    straightness      TEXT,
    weight_tolerance  TEXT,
    notes             TEXT,
    UNIQUE (arrow_model_id, spine)
);

CREATE TABLE IF NOT EXISTS chart_entry_arrow_model (
    id                   INTEGER PRIMARY KEY AUTOINCREMENT,
    spine_chart_entry_id INTEGER NOT NULL REFERENCES spine_chart_entry(id) ON DELETE CASCADE,
    arrow_model_spine_id INTEGER NOT NULL REFERENCES arrow_model_spine(id) ON DELETE CASCADE,
    priority_order       INTEGER NOT NULL DEFAULT 1,
    UNIQUE (spine_chart_entry_id, arrow_model_spine_id)
);

CREATE TABLE IF NOT EXISTS spine_group_lookup (
    id                INTEGER PRIMARY KEY AUTOINCREMENT,
    manufacturer_id   INTEGER NOT NULL REFERENCES manufacturer(id),
    group_code        TEXT NOT NULL,
    spine_numeric_min INTEGER NOT NULL,
    spine_numeric_max INTEGER NOT NULL,
    shaft_sizes       TEXT,
    UNIQUE (manufacturer_id, group_code)
);

CREATE TABLE IF NOT EXISTS compound_bow_brand (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    name       TEXT NOT NULL UNIQUE,
    country    TEXT,
    website    TEXT,
    active     INTEGER NOT NULL DEFAULT 1,
    created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS compound_bow_model (
    id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    brand_id            INTEGER NOT NULL REFERENCES compound_bow_brand(id) ON DELETE CASCADE,
    model_name          TEXT NOT NULL,
    model_year          INTEGER,
    ibo_fps             INTEGER NOT NULL,
    draw_weight_min_lbs REAL,
    draw_weight_max_lbs REAL,
    draw_length_min_in  REAL,
    draw_length_max_in  REAL,
    axle_to_axle_in     REAL,
    brace_height_in     REAL,
    notes               TEXT,
    active              INTEGER NOT NULL DEFAULT 1,
    created_at          TEXT NOT NULL DEFAULT (datetime('now')),
    UNIQUE (brand_id, model_name, model_year)
);

CREATE INDEX IF NOT EXISTS idx_compound_bow_model_brand ON compound_bow_model(brand_id);

CREATE TABLE IF NOT EXISTS menu_options (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    title      TEXT NOT NULL,
    subtitle   TEXT,
    icon_name  TEXT NOT NULL DEFAULT 'menu',
    route      TEXT NOT NULL,
    sort_order INTEGER NOT NULL DEFAULT 0,
    is_active  INTEGER NOT NULL DEFAULT 1,
    parent_id  INTEGER REFERENCES menu_options(id) ON DELETE SET NULL,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_menu_active_order ON menu_options (is_active, sort_order);
