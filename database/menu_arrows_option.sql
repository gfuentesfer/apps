-- Añadir opción de menú para calculadora de flechas (idempotente)
INSERT INTO menu_options (title, subtitle, icon_name, route, sort_order, is_active)
SELECT 'Calculadora de flechas', 'Spine, longitud y modelos por marca', 'straighten', 'arrows', 15, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM menu_options WHERE route = 'arrows'
);
