const sql = require('mssql');

let poolPromise;

function toBool(value, defaultValue = true) {
  if (value == null || value === '') return defaultValue;
  return String(value).toLowerCase() === 'true';
}

function getConfig() {
  return {
    server: process.env.SQL_SERVER,
    database: process.env.SQL_DATABASE,
    user: process.env.SQL_USER,
    password: process.env.SQL_PASSWORD,
    options: {
      encrypt: toBool(process.env.SQL_ENCRYPT, true),
      trustServerCertificate: toBool(process.env.SQL_TRUST_SERVER_CERT, true)
    },
    pool: {
      max: 10,
      min: 0,
      idleTimeoutMillis: 30000
    }
  };
}

function validateConfig(config) {
  const missing = ['server', 'database', 'user', 'password'].filter((k) => !config[k]);
  if (missing.length > 0) {
    throw new Error(`Missing required SQL environment variables for: ${missing.join(', ')}`);
  }
}

async function getPool() {
  if (!poolPromise) {
    const config = getConfig();
    validateConfig(config);
    poolPromise = sql.connect(config);
  }
  return poolPromise;
}

module.exports = {
  sql,
  getPool
};
