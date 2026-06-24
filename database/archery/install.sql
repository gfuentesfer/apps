-- Ejecutar en psql conectado a la base de datos arrows:
--   \i database/archery/01_schema.sql
--   \i database/archery/02_seed_catalogs.sql
--   ...
--
-- O desde Node: npm run setup-archery

\echo '>> 01_schema.sql'
\ir 01_schema.sql
\echo '>> 02_seed_catalogs.sql'
\ir 02_seed_catalogs.sql
\echo '>> 03_seed_easton_rules.sql'
\ir 03_seed_easton_rules.sql
\echo '>> 04_seed_sample_spine_data.sql'
\ir 04_seed_sample_spine_data.sql
\echo '>> 05_seed_arrow_models.sql'
\ir 05_seed_arrow_models.sql
