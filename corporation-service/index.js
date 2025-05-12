require('module-alias/register');
const express = require("express");
const { logger, metricsRegister } = require('./utils/loggers/logger');
const LoggingMiddleware = require("./middleware/logging");
//const Middleware = require("./middleware/middleware");
////const ErrorHandlingMiddleware = require("./middleware/error-handling");
//const UsersController = require("./controllers/users-controller");
//const path = require('path');
const PORT = process.env.PORT || 4002;

const app = express();
//app.use("/public", express.static(path.join(__dirname, 'public')));
//Middleware(app);
//app.use("", UsersController);



//ErrorHandlingMiddleware(app);
LoggingMiddleware(app);

app.get('/', (req, res) => {
    logger.info('Home page hit');
    res.send('Logger is working!');
  });
  
  app.get('/error', (req, res) => {
    logger.error('Something went wrong');
    res.status(500).send('Error');
  });
  
  app.get('/metrics', async (req, res) => {
    res.set('Content-Type', metricsRegister.contentType);
    res.end(await metricsRegister.metrics());
  });

app.listen(PORT, () => {
    console.log(`Corporation Service listening on Port ${PORT}`);
})