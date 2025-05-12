/**
 * transport-worker.js — Worker used by pino.transport()
 * Adds monthly log rotation, gzip, and symlinks
 */

const path = require('path');
const rfs = require('rotating-file-stream');
const { workerData, parentPort } = require('worker_threads');

const { level, logDir } = workerData;

const stream = rfs.createStream(`${level}-%Y-%m.log`, {
  interval: '1M',
  path: logDir,
  compress: 'gzip',
  maxFiles: 12,
  createSymlink: true,
  symlinkName: `${level}.log`,
});

parentPort.on('message', (chunk) => {
  stream.write(chunk);
});