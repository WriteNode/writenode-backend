/**
 * Aliases Configuration for Module Resolution
 * 
 * This file provides alias mappings for module resolution in Node.js.
 * By using module-alias, we can use cleaner, more concise import paths.
 * Instead of using relative paths like "../../db/pg-pool-manager", we can 
 * use "@db/pg-pool-manager" for better readability and maintainability.
 *
 * The paths are resolved based on the root directory of the project.
 * For example, "@db" maps to the "src/persistence/postgresql" directory.
 * 
 * To sync this configuration with your package.json, use the "sync-aliases.js"
 * script, which updates the "_moduleAliases" section in package.json.
 *
 * Make sure to install and configure the "module-alias" package to make this work.
 *
 * @see https://www.npmjs.com/package/module-alias
 */

const path = require('path');

module.exports = {
  '@db': path.resolve(__dirname, 'persistence/postgresql/config'),
  '@logger': path.resolve(__dirname, 'utils/loggers/'),
  // '@config': path.resolve(__dirname, 'config'),
  // '@utils': path.resolve(__dirname, 'utils'),
  // '@lib': path.resolve(__dirname, 'lib'),
  // '@middlewares': path.resolve(__dirname, 'middlewares'),
  // '@services': path.resolve(__dirname, 'services'),
};
