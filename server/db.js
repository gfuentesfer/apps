require('dotenv').config();

const { Pool } = require('pg');

const NEON_SSL = { rejectUnauthorized: false };

function isNeonHost(host) {
  return typeof host === 'string' && host.includes('neon.tech');
}

function resolvePgConfig() {
  const host = process.env.PGHOST || process.env.DB_HOST;
  const port = Number(process.env.PGPORT || process.env.DB_PORT || 5432);
  const user = process.env.PGUSER || process.env.DB_USER;
  const password = process.env.PGPASSWORD || process.env.DB_PASSWORD;
  const database = process.env.PGDATABASE || process.env.DB_NAME || 'arrows';

  if (host && user && password) {
    const ssl =
      process.env.PGSSLMODE === 'require' ||
      isNeonHost(host) ||
      process.env.DATABASE_URL?.includes('neon.tech')
        ? NEON_SSL
        : undefined;

    return { host, port, user, password, database, ssl };
  }

  return null;
}

/**
 * Pool PostgreSQL. Prioridad:
 * 1. PGHOST + PGUSER + PGPASSWORD (variables estándar / Neon)
 * 2. DATABASE_URL
 * 3. DB_HOST, DB_USER, … (local)
 */
function createPool() {
  const pgConfig = resolvePgConfig();
  const poolOptions = {
    connectionTimeoutMillis: 8000,
    idleTimeoutMillis: 10000,
  };

  if (pgConfig) {
    return new Pool({ ...pgConfig, ...poolOptions });
  }

  if (process.env.DATABASE_URL) {
    return new Pool({
      connectionString: process.env.DATABASE_URL,
      ssl: NEON_SSL,
      ...poolOptions,
    });
  }

  return new Pool({
    host: process.env.DB_HOST || 'localhost',
    port: Number(process.env.DB_PORT || 5432),
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME || 'arrows',
    ...poolOptions,
  });
}

function assertDatabaseConfig() {
  const isProduction =
    process.env.NODE_ENV === 'production' || process.env.RENDER === 'true';
  if (!isProduction) return;

  const hasPg = resolvePgConfig() != null || Boolean(process.env.DATABASE_URL);
  if (!hasPg) {
    console.error(
      'ERROR: En Render faltan variables de Neon. Configura PGHOST, PGUSER, ' +
        'PGPASSWORD, PGDATABASE (o DATABASE_URL) en Environment.',
    );
    process.exit(1);
  }
}

function getDatabaseMode() {
  const host = process.env.PGHOST || process.env.DB_HOST || '';
  if (
    process.env.PGUSER ||
    process.env.DATABASE_URL ||
    isNeonHost(host)
  ) {
    return 'neon';
  }
  return 'local';
}

module.exports = { createPool, getDatabaseMode, assertDatabaseConfig };
