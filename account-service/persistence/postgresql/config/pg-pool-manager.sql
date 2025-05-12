const { Pool } = require('pg');

class PgPoolManager {
  constructor(config) {
    if (!PgPoolManager.instance) {
      this.pool = new Pool({
        max: config.max || 10,
        idleTimeoutMillis: config.idleTimeoutMillis || 30000,
        connectionTimeoutMillis: config.connectionTimeoutMillis || 2000,
        ...config,
      });

      this._setupGracefulShutdown();
      this._setupErrorHandling();

      PgPoolManager.instance = this;
    }

    return PgPoolManager.instance;
  }

  /**
   * Executes a query directly on the pool.
   * @param {string} text
   * @param {Array} params
   */
  async query(text, params) {
    const start = Date.now();
    const res = await this.pool.query(text, params);
    const duration = Date.now() - start;

    if (duration > 500) {
      console.warn(`[PG-SLOW-QUERY] ${duration}ms\n`, text, params);
    }

    return res;
  }

  /**
   * Gets a pooled client. Must call client.release() afterwards.
   * Useful for transactions.
   */
  async getClient() {
    const client = await this.pool.connect();

    // Attach a timeout checker to detect leaks
    const timeout = setTimeout(() => {
      console.error('[PG-CLIENT-LEAK] Client checked out too long!');
      console.error(client.lastQuery);
    }, 15000); // 15s max hold time

    // Monkey-patch query and release
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

  /**
   * Closes the pool gracefully
   */
  async close() {
    await this.pool.end();
    console.info('[PG-POOL] Closed PostgreSQL pool.');
  }

  /**
   * Listen for app shutdown
   */
  _setupGracefulShutdown() {
    const shutdown = async () => {
      try {
        await this.close();
        process.exit(0);
      } catch (err) {
        console.error('[PG-POOL] Error during shutdown:', err);
        process.exit(1);
      }
    };

    process.on('SIGINT', shutdown);
    process.on('SIGTERM', shutdown);
  }

  /**
   * Handles and logs unexpected errors
   */
  _setupErrorHandling() {
    this.pool.on('error', (err) => {
      console.error('[PG-POOL] Unexpected error on idle client', err);
    });
  }
}

module.exports = PgPoolManager;
