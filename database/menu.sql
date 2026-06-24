-- MyArrows App - Base de datos del menú
-- Ejecutar en PostgreSQL 14+

-- CREATE DATABASE arrows;
-- \c arrows

CREATE TABLE IF NOT EXISTS menu_options (
  id          SERIAL PRIMARY KEY,
  title       VARCHAR(100)  NOT NULL,
  subtitle    VARCHAR(255),
  icon_name   VARCHAR(50)   NOT NULL DEFAULT 'menu',
  route       VARCHAR(100)  NOT NULL,
  sort_order  INT           NOT NULL DEFAULT 0,
  is_active   BOOLEAN       NOT NULL DEFAULT TRUE,
  parent_id   INT           REFERENCES menu_options (id) ON DELETE SET NULL,
  created_at  TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_menu_active_order
  ON menu_options (is_active, sort_order);

INSERT INTO menu_options (title, subtitle, icon_name, route, sort_order, is_active)
VALUES
  ('Inicio',        'Pantalla principal',         'home',     'home',     10, TRUE),
  ('Configuración', 'Ajustes de la aplicación',   'settings', 'settings', 30, TRUE),
  ('Calculadora de flechas', 'Spine, longitud y modelos por marca', 'straighten', 'arrows', 15, TRUE);

-- Consulta que usa la API:
-- SELECT id, title, subtitle, icon_name, route, sort_order
-- FROM menu_options
-- WHERE is_active = TRUE
-- ORDER BY sort_order ASC, id ASC;
