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
  if (pgConfig) {
    return new Pool(pgConfig);
  }

  if (process.env.DATABASE_URL) {
    return new Pool({
      connectionString: process.env.DATABASE_URL,
      ssl: NEON_SSL,
    });
  }

  return new Pool({
    host: process.env.DB_HOST || 'localhost',
    port: Number(process.env.DB_PORT || 5432),
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME || 'arrows',
  });
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

module.exports = { createPool, getDatabaseMode };
