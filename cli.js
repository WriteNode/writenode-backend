// cli.js
import fs from 'fs';
import path from 'path';
import inquirer from 'inquirer';
import { execSync } from 'child_process';

const templates = {
  'user-service': 'templates/user-service',
  'mail-service': 'templates/mail-service'
};

const createService = async () => {
  const { serviceName } = await inquirer.prompt([
    {
      name: 'serviceName',
      type: 'list',
      message: 'Choose a service to scaffold:',
      choices: Object.keys(templates)
    }
  ]);

  const destPath = path.resolve(process.cwd(), serviceName);
  const srcPath = path.resolve(process.cwd(), templates[serviceName]);

  if (fs.existsSync(destPath)) {
    console.error(`Directory ${serviceName} already exists.`);
    return;
  }

  fs.cpSync(srcPath, destPath, { recursive: true });

  console.log(`✔️  ${serviceName} scaffolded.`);

  // Optional Docker setup
  execSync(`docker-compose up -d --build ${serviceName}`, { stdio: 'inherit' });
  console.log(`🚀 ${serviceName} started via Docker Compose.`);
};

createService();
