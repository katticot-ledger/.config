#!/usr/bin/env node

/**
 * pi RPC Client
 * A proper RPC client for pi's JSONL protocol over stdin/stdout
 */

const { spawn } = require('child_process');

class PiRPCClient {
  constructor(args = ['--mode', 'rpc', '--no-session']) {
    this.agent = spawn('pi', args);
    this.pendingRequests = new Map();
    this.eventHandlers = new Map();
    this.requestId = 0;
    this.isReady = false;

    // Attach stdout reader with proper JSONL framing
    this.attachJsonlReader(this.agent.stdout, (line) => this.handleLine(line));

    // Handle errors
    this.agent.on('error', (err) => {
      console.error('Process error:', err);
      process.exit(1);
    });

    this.agent.on('exit', (code, signal) => {
      if (code !== 0) {
        console.error(`Process exited with code ${code}, signal ${signal}`);
      }
    });
  }

  /**
   * Proper JSONL reader - splits on LF only, not Unicode separators
   * Important: Do not use Node's readline module for RPC mode!
   */
  attachJsonlReader(stream, onLine) {
    const { StringDecoder } = require('string_decoder');
    const decoder = new StringDecoder('utf8');
    let buffer = '';

    stream.on('data', (chunk) => {
      buffer += typeof chunk === 'string' ? chunk : decoder.write(chunk);

      while (true) {
        const newlineIndex = buffer.indexOf('\n');
        if (newlineIndex === -1) break;

        let line = buffer.slice(0, newlineIndex);
        buffer = buffer.slice(newlineIndex + 1);

        // Handle optional CRLF
        if (line.endsWith('\r')) {
          line = line.slice(0, -1);
        }

        if (line.length > 0) {
          onLine(line);
        }
      }
    });

    stream.on('end', () => {
      buffer += decoder.end();
      if (buffer.length > 0) {
        let line = buffer.endsWith('\r') ? buffer.slice(0, -1) : buffer;
        if (line.length > 0) {
          onLine(line);
        }
      }
    });

    stream.on('error', (err) => {
      console.error('Stream error:', err);
    });
  }

  /**
   * Handle incoming JSON lines
   */
  handleLine(line) {
    try {
      const data = JSON.parse(line);

      // Handle responses to commands
      if (data.type === 'response' && data.id) {
        const pending = this.pendingRequests.get(data.id);
        if (pending) {
          this.pendingRequests.delete(data.id);
          if (data.success) {
            pending.resolve(data);
          } else {
            pending.reject(new Error(data.error || 'Command failed'));
          }
        }
      }

      // Handle extension UI requests (need response)
      else if (data.type === 'extension_ui_request') {
        this.handleExtensionUIRequest(data);
      }

      // Handle agent events
      else {
        this.emit(data.type, data);
      }

    } catch (err) {
      console.error('Failed to parse line:', line, err);
    }
  }

  /**
   * Handle extension UI requests (dialogs)
   */
  handleExtensionUIRequest(request) {
    const { id, method } = request;

    // Auto-respond to non-dialog methods (fire-and-forget)
    if (['notify', 'setStatus', 'setWidget', 'setTitle', 'set_editor_text'].includes(method)) {
      // These don't need a response
      this.emit('extension_ui_request', request);
      return;
    }

    // For dialog methods, respond with cancelled by default
    // Real implementation would prompt user or use custom logic
    const response = { type: 'extension_ui_response', id, cancelled: true };
    this.send(response);
  }

  /**
   * Send a JSON command to the agent
   */
  send(data) {
    const json = JSON.stringify(data);
    this.agent.stdin.write(json + '\n');
  }

  /**
   * Send a command and wait for response
   */
  async sendCommand(data) {
    return new Promise((resolve, reject) => {
      const id = data.id || `req-${++this.requestId}`;
      data.id = id;

      this.pendingRequests.set(id, { resolve, reject });
      this.send(data);

      // Timeout after 60 seconds
      setTimeout(() => {
        if (this.pendingRequests.has(id)) {
          this.pendingRequests.delete(id);
          reject(new Error(`Command ${id} timed out`));
        }
      }, 60000);
    });
  }

  /**
   * Event emitter pattern
   */
  on(event, handler) {
    if (!this.eventHandlers.has(event)) {
      this.eventHandlers.set(event, []);
    }
    this.eventHandlers.get(event).push(handler);
  }

  emit(event, data) {
    const handlers = this.eventHandlers.get(event);
    if (handlers) {
      for (const handler of handlers) {
        handler(data);
      }
    }
  }

  /**
   * Send a prompt and collect response text
   */
  async prompt(message, options = {}) {
    const response = await this.sendCommand({
      type: 'prompt',
      message,
      ...options
    });

    if (!response.success) {
      throw new Error(`Prompt failed: ${response.error}`);
    }

    return new Promise((resolve, reject) => {
      let fullText = '';
      let agentEnded = false;

      const handleTextDelta = (event) => {
        if (event.assistantMessageEvent?.type === 'text_delta') {
          fullText += event.assistantMessageEvent.delta;
          process.stdout.write(event.assistantMessageEvent.delta);
        }
      };

      const handleAgentEnd = (event) => {
        if (!agentEnded) {
          agentEnded = true;
          this.off('message_update', handleTextDelta);
          this.off('agent_end', handleAgentEnd);
          process.stdout.write('\n');
          resolve({ text: fullText, messages: event.messages });
        }
      };

      const handleError = (event) => {
        if (!agentEnded) {
          agentEnded = true;
          this.off('message_update', handleTextDelta);
          this.off('agent_end', handleAgentEnd);
          reject(new Error(event.message || 'Agent error'));
        }
      };

      this.on('message_update', handleTextDelta);
      this.on('agent_end', handleAgentEnd);
      this.on('extension_error', handleError);

      // Safety timeout
      setTimeout(() => {
        if (!agentEnded) {
          handleAgentEnd({ messages: [] });
        }
      }, 120000);
    });
  }

  /**
   * Get current state
   */
  async getState() {
    const response = await this.sendCommand({ type: 'get_state' });
    return response.data;
  }

  /**
   * Get available models
   */
  async getAvailableModels() {
    const response = await this.sendCommand({ type: 'get_available_models' });
    return response.data.models;
  }

  /**
   * Set model
   */
  async setModel(provider, modelId) {
    const response = await this.sendCommand({
      type: 'set_model',
      provider,
      modelId
    });
    return response.data;
  }

  /**
   * Abort current operation
   */
  async abort() {
    const response = await this.sendCommand({ type: 'abort' });
    return response.success;
  }

  /**
   * Close the client
   */
  close() {
    this.agent.stdin.end();
    setTimeout(() => {
      this.agent.kill();
    }, 1000);
  }
}

// Example usage
async function main() {
  const client = new PiRPCClient();

  // Listen to events
  client.on('agent_start', () => console.log('[Agent started]'));
  client.on('turn_start', () => console.log('[Turn started]'));
  client.on('tool_execution_start', (e) => console.log(`[Tool: ${e.toolName}]`));

  // Handle extension UI (for reference)
  client.on('extension_ui_request', (req) => {
    if (req.method === 'notify') {
      console.log(`\n[Notification] ${req.message}\n`);
    }
  });

  try {
    // Send a prompt
    const result = await client.prompt('Analyze the current directory. What files are here?');

    console.log('\n=== Complete ===');
    console.log('Response length:', result.text.length);

    // Get state
    const state = await client.getState();
    console.log('Model:', state.model?.name);
    console.log('Messages:', state.messageCount);

  } catch (err) {
    console.error('Error:', err);
  } finally {
    client.close();
  }
}

// CLI interface
if (require.main === module) {
  const args = process.argv.slice(2);
  if (args.length > 0) {
    // Run single prompt from CLI args
    const message = args.join(' ');
    const client = new PiRPCClient();

    client.on('agent_start', () => {});
    client.on('tool_execution_start', (e) => {
      console.log(`\n[Running: ${e.args.command || e.toolName}]\n`);
    });

    client.prompt(message)
      .then(() => client.close())
      .catch((err) => {
        console.error('Error:', err);
        client.close();
        process.exit(1);
      });
  } else {
    // Run example
    main();
  }
}

module.exports = PiRPCClient;
