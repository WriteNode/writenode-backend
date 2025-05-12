/**
 * logger.js — Pino logger with pino.transport(), rotating logs, and Prometheus metrics
 */

const fs = require('fs');
const path = require('path');
const pino = require('pino');
const { Counter, Histogram,register } = require('prom-client');
const { transport } = require('pino');


// Define some basic metrics
const requestCount = new Counter({
    name: 'http_requests_total',
    help: 'Total HTTP requests received',
    labelNames: ['method', 'status_code'],
  });
  
  const errorCount = new Counter({
    name: 'http_errors_total',
    help: 'Total number of errors',
    labelNames: ['method', 'status_code'],
  });
  
  const durationHistogram = new Histogram({
    name: 'http_duration_seconds',
    help: 'HTTP request duration in seconds',
    buckets: [0.1, 0.2, 0.3, 0.4, 0.5, 1, 2, 5, 10],
  });


// Ensure log directory exists
const logDir = path.join(__dirname, 'logs');
if (!fs.existsSync(logDir)) fs.mkdirSync(logDir);

// Setup log level metrics
const levels = ['info', 'error', 'debug'];
const logCounters = {};
levels.forEach(level => {
  logCounters[level] = new Counter({
    name: `log_${level}_total`,
    help: `Total number of ${level} logs`,
  });
});

// Create transport worker
const logTransport = transport({
  targets: levels.map(level => ({
    target: 'pino/file',
    level,
    options: {
      destination: path.join(logDir, `${level}-%Y-%m.log`), // e.g., info-2025-05.log
      mkdir: true,
      append: true,
    },
    worker: {
      filename: require.resolve('./logger-transport-worker'),
      workerData: {
        level,
        logDir,
      },
    }
  })),
});

const logger = pino(logTransport);

// Wrap logger with metric counters
levels.forEach(level => {
  const original = logger[level];
  logger[level] = (...args) => {
    logCounters[level].inc();
    return original.apply(logger, args);
  };
});

module.exports = {
  logger,
  requestCount,
  errorCount,
  durationHistogram,
  metricsRegister: register
};
