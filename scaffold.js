const fs = require('fs-extra');
const path = require('path');

const services = ['user-service', 'mail-service'];

const baseServiceFiles = {
  'index.js': `console.log("Service started.");`,
  'Dockerfile': `
FROM node:18
WORKDIR /app
COPY . .
RUN npm install
CMD ["node", "index.js"]
`.trim(),
  'package.json': (name) => JSON.stringify({
    name,
    version: "1.0.0",
    main: "index.js",
    scripts: {
      start: "node index.js"
    }
  }, null, 2)
};

const dockerComposeBase = {
  version: '3.8',
  services: {}
};

async function scaffold() {
  const rootDir = path.resolve('./microservices');
  await fs.ensureDir(rootDir);

  for (const service of services) {
    const servicePath = path.join(rootDir, service);
    await fs.ensureDir(servicePath);

    // Create index.js and Dockerfile
    await fs.writeFile(path.join(servicePath, 'index.js'), baseServiceFiles['index.js']);
    await fs.writeFile(path.join(servicePath, 'Dockerfile'), baseServiceFiles['Dockerfile']);
    await fs.writeFile(path.join(servicePath, 'package.json'), baseServiceFiles['package.json'](service));

    // Add to docker-compose config
    dockerComposeBase.services[service] = {
      build: `./${service}`,
      ports: service === 'user-service' ? ['3001:3000'] : ['3002:3000']
    };
  }

  // Write docker-compose.yml
  const yaml = require('yaml');
  const composePath = path.join(rootDir, 'docker-compose.yml');
  await fs.writeFile(composePath, yaml.stringify(dockerComposeBase));

  console.log('✅ Services scaffolded successfully in ./microservices');
}

scaffold().catch(console.error);
