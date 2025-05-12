/**
 * logging.js — Express middleware for request logging and metrics
 */

const { v4: uuidv4 } = require('uuid');
const { requestCount, errorCount, durationHistogram, logger } = require('../utils/loggers/logger');

function LoggingMiddleware(app) {
  app.use((req, res, next) => {
    const requestId = req.headers['x-request-id'] || uuidv4();
    req.id = requestId;
    res.setHeader('x-request-id', requestId);

    const start = process.hrtime();

    res.on('finish', () => {
      const [seconds, nanoseconds] = process.hrtime(start);
      const durationInSeconds = seconds + nanoseconds / 1e9;

      const { method, originalUrl } = req;
      const statusCode = res.statusCode;

      durationHistogram.observe(durationInSeconds);
      requestCount.inc({ method, status_code: statusCode });

      const logMessage = `${method} ${originalUrl} ${statusCode} - ${durationInSeconds.toFixed(3)}s [request-id: ${requestId}]`;

      if (statusCode >= 500) {
        errorCount.inc({ method, status_code: statusCode });
        logger.error(logMessage);
      } else if (statusCode >= 400) {
        logger.warn(logMessage);
      } else {
        logger.info(logMessage);
      }
    });

    next();
  });
}

module.exports = LoggingMiddleware;
