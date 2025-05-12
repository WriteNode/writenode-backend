// db/pgPoolManager.js
const { Pool } = require('pg');
const logger = require('@logger');

class PgPoolManager {
  constructor(config) {
    if (!PgPoolManager.instance) {
      this.pool = new Pool({
        max: config.max || 10,
        idleTimeoutMillis: config.idleTimeoutMillis || 30000,
        connectionTimeoutMillis: config.connectionTimeoutMillis || 2000,
        ...config,
      });

      logger.info('PostgreSQL pool created');
      this._setupGracefulShutdown();
      this._setupErrorHandling();

      PgPoolManager.instance = this;
    }

    return PgPoolManager.instance;
  }

  async query(text, params) {
    const start = Date.now();
    const res = await this.pool.query(text, params);
    const duration = Date.now() - start;

    logger.debug({ query: text, params, duration }, 'Executed query');

    if (duration > 500) {
      logger.warn({ duration, query: text }, 'Slow query detected');
    }

    return res;
  }
/**
 * Returns a PostgreSQL client from the pool.
 * 
 * Use this when you need to:
 * - Perform multi-statement transactions (BEGIN/COMMIT/ROLLBACK)
 * - Manually manage client lifecycle (acquire/release)
 * - Handle low-level error handling or retry logic
 * 
 * Example usage:
 * const client = await poolManager.getClient();
 * try {
 *   await client.query('BEGIN');
 *   // ... your queries ...
 *   await client.query('COMMIT');
 * } catch (err) {
 *   await client.query('ROLLBACK');
 *   throw err;
 * } finally {
 *   client.release(); // Always release the client!
 * }
 *
 * @returns {Promise<PoolClient>} A PostgreSQL client connection.
 */
  async getClient() {
    const client = await this.pool.connect();

    const timeout = setTimeout(() => {
      logger.error({ lastQuery: client.lastQuery }, 'Client held too long — potential leak!');
    }, 15000);

    const query = client.query.bind(client);
    client.query = (...args) => {
      client.lastQuery = args;
      return query(...args);
    };

    const release = client.release.bind(client);
    client.release = () => {
      clearTimeout(timeout);
      return release();
    };

    return client;
  }

  async close() {
    await this.pool.end();
    logger.info('PostgreSQL pool closed');
  }

  _setupGracefulShutdown() {
    const shutdown = async () => {
      try {
        await this.close();
        process.exit(0);
      } catch (err) {
        logger.error({ err }, 'Error during graceful shutdown');
        process.exit(1);
      }
    };

    process.on('SIGINT', shutdown);
    process.on('SIGTERM', shutdown);
  }

  _setupErrorHandling() {
    this.pool.on('error', (err) => {
      logger.error({ err }, 'Unexpected error on idle client');
    });
  }
}

module.exports = PgPoolManager;
