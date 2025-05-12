/**
 * Sync Aliases Script
 *
 * This script reads custom module path aliases from `aliases.config.js`
 * and writes them into the `package.json` under `_moduleAliases`, 
 * used by `module-alias` for runtime resolution.
 *
 * Usage:
 *   node sync-aliases.js
 *
 * Requirements:
 *   - `aliases.config.js` must be in the project root.
 *   - `module-alias` must be installed as a dependency.
 *
 * Project Structure Expected:
 * writenode-backend/
 * ├── aliases.config.js
 * ├── sync-aliases.js
 * ├── package.json
 * └── persistence/
 *     └── postgresql/config/
 */

const fs = require('fs');
const path = require('path');

// Load aliases from the config file
const aliases = require('./aliases.config');

// Load and parse package.json
const packageJsonPath = path.resolve(__dirname, 'package.json');
const packageJson = require(packageJsonPath);

// Convert full paths to relative paths for _moduleAliases
const relativeAliases = {};
for (const alias in aliases) {
  relativeAliases[alias] = path.relative(__dirname, aliases[alias]);
}

// Update _moduleAliases in package.json
packageJson._moduleAliases = relativeAliases;

// Write back to package.json
fs.writeFileSync(packageJsonPath, JSON.stringify(packageJson, null, 2));

console.log('✅ Synced _moduleAliases in package.json');
