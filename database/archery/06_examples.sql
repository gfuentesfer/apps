-- Ejemplos de consulta

-- 1) Peso efectivo con ajustes Easton compound
-- SELECT fn_effective_draw_weight(
--     (SELECT id FROM manufacturer_chart WHERE chart_name = 'Easton Target - Compound Release'),
--     50,    -- lbs reales
--     125,   -- grains punta
--     330,   -- fps
--     'MECHANICAL',
--     'CARBON_COMPETITION'
-- );

-- 2) Recomendación completa: marca Easton, recurvo 36 lbs, flecha 29", punta 100gr
-- SELECT * FROM fn_recommend_arrows(
--     (SELECT id FROM manufacturer WHERE name = 'Easton'),
--     (SELECT id FROM bow_type WHERE code = 'RECURVE'),
--     (SELECT id FROM shooting_style WHERE code = 'OLYMPIC_RECURVE'),
--     36,    -- potencia lbs
--     29,    -- longitud flecha pulgadas
--     100,   -- punta grains
--     NULL,  -- fps (no aplica recurvo)
--     'FINGER',
--     'CARBON_COMPETITION'
-- );

-- 3) Longitud flecha sugerida desde apertura (draw length + 1")
-- SELECT 28.0 AS draw_length, 28.0 + 1 AS suggested_arrow_length;
