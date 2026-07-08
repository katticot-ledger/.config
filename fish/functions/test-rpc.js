#!/usr/bin/env node

/**
 * Simple test to see what events pi RPC mode actually emits
 */

const { spawn } = require('child_process');
const { StringDecoder } = require('string_decoder');

console.log('Starting pi in RPC mode...');
console.log('========================================\n');

const agent = spawn('pi', ['--mode', 'rpc', '--no-session']);

// Proper JSONL reader
const decoder = new StringDecoder('utf8');
let buffer = '';

agent.stdout.on('data', (chunk) => {
  buffer += typeof chunk === 'string' ? chunk : decoder.write(chunk);

  while (true) {
    const newlineIndex = buffer.indexOf('\n');
    if (newlineIndex === -1) break;

    let line = buffer.slice(0, newlineIndex);
    buffer = buffer.slice(newlineIndex + 1);

    if (line.endsWith('\r')) line = line.slice(0, -1);
    if (line.length > 0) {
      try {
        const data = JSON.parse(line);
        console.log(JSON.stringify(data, null, 2));
      } catch (e) {
        console.log(`[RAW] ${line}`);
      }
      console.log('----------------------------------------');
    }
  }
});

agent.on('error', (err) => console.error('Process error:', err));
agent.on('exit', (code, signal) => console.log(`\nProcess exited: ${code} (${signal})`));

// Send a prompt after a short delay
setTimeout(() => {
  console.log('\n>>> Sending prompt...\n');
  const cmd = JSON.stringify({ type: 'prompt', message: 'Hello, what is 2+2?' });
  agent.stdin.write(cmd + '\n');
}, 500);

// Wait for response, then exit
setTimeout(() => {
  console.log('\n>>> Exiting...\n');
  agent.stdin.end();
  setTimeout(() => agent.kill(), 500);
}, 10000);
