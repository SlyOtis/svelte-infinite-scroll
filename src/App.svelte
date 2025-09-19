<script lang="ts">
  import { InfiniteScroll } from './lib';
  import LogLine from './LogLine.svelte';
  
  interface LogEntry {
    id: string;
    timestamp: number;
    level: 'debug' | 'info' | 'warn' | 'error';
    message: string;
    source: string;
    metadata?: Record<string, any>;
  }
  
  let logs = $state<LogEntry[]>([]);
  let cursor = $state<string>('');
  let logCounter = 0;
  
  const logSources = ['app.js', 'server.ts', 'database.js', 'auth.ts', 'api.js', 'worker.js', 'cache.ts'];
  const logMessages = {
    debug: [
      'Cache hit for key: user_123',
      'SQL query executed in 23ms',
      'Request headers validated',
      'Session token refreshed'
    ],
    info: [
      'Request processed successfully',
      'Database connection established',
      'User authenticated',
      'Background job completed',
      'Service health check passed'
    ],
    warn: [
      'API rate limit approaching',
      'Memory usage at 78%',
      'Deprecated method called',
      'Slow query detected (>500ms)'
    ],
    error: [
      'Failed to connect to Redis',
      'Authentication failed for user',
      'Database query timeout',
      'Invalid API response format'
    ]
  };
  
  function generateRandomLog(timestamp: number): LogEntry {
    const levels: LogEntry['level'][] = ['debug', 'info', 'warn', 'error'];
    const weights = [0.3, 0.45, 0.2, 0.05];
    const random = Math.random();
    let level: LogEntry['level'] = 'info';
    let cumulative = 0;
    for (let i = 0; i < weights.length; i++) {
      cumulative += weights[i];
      if (random < cumulative) {
        level = levels[i];
        break;
      }
    }
    
    const messages = logMessages[level];
    const message = messages[Math.floor(Math.random() * messages.length)];
    
    const log: LogEntry = {
      id: `log-${++logCounter}`,
      timestamp,
      level,
      message,
      source: logSources[Math.floor(Math.random() * logSources.length)]
    };
    
    if (Math.random() > 0.7) {
      log.metadata = {
        duration: Math.floor(Math.random() * 1000) + 'ms',
        user_id: `user_${Math.floor(Math.random() * 1000)}`,
        request_id: `req_${Math.random().toString(36).substr(2, 9)}`
      };
    }
    
    return log;
  }
  
  async function loadInitial() {
    await new Promise(r => setTimeout(r, 300));
    const now = Date.now();
    const newLogs = Array.from({ length: 50 }, (_, i) => 
      generateRandomLog(now - i * 2000)
    );
    logs = newLogs;
    cursor = btoa(newLogs[newLogs.length - 1].timestamp.toString());
  }
  
  async function loadMore() {
    if (!cursor) return [];
    
    if (logs.length >= 2000) return [];
    
    await new Promise(r => setTimeout(r, 300));
    const timestamp = parseInt(atob(cursor));
    const newLogs = Array.from({ length: 30 }, (_, i) => 
      generateRandomLog(timestamp - (i + 1) * 2000)
    );
    
    logs = [...logs, ...newLogs];
    cursor = newLogs.length > 0 ? btoa(newLogs[newLogs.length - 1].timestamp.toString()) : cursor;
    return newLogs;
  }
  
  $effect(() => {
    loadInitial();
  });
</script>

<div class="app">
  <header class="header">
    <div class="header-content">
      <h1>Device Console</h1>
      <div class="device-info">
        <span class="device-name">Production Server</span>
        <span class="status-indicator online"></span>
      </div>
    </div>
  </header>
  
  <div class="console-container">
    <div class="toolbar">
      <div class="toolbar-left">
        <button class="filter-btn active">All</button>
        <button class="filter-btn">Error</button>
        <button class="filter-btn">Warn</button>
        <button class="filter-btn">Info</button>
        <button class="filter-btn">Debug</button>
      </div>
      <div class="toolbar-right">
        <span class="log-count">Showing {logs.length} logs</span>
      </div>
    </div>
    
    <div class="log-scroll" style="height: calc(100vh - 140px); overflow-y: auto;">
      {#each logs as log (log.id)}
        <LogLine {log} />
      {/each}
      
      <InfiniteScroll onLoadMore={loadMore} threshold={200} />
    </div>
  </div>
</div>

<style>
  .app {
    display: flex;
    flex-direction: column;
    height: 100vh;
    margin: 0;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    background: #0a0e27;
    color: #cbd5e1;
  }
  
  .header {
    background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
    border-bottom: 1px solid #1e293b;
    padding: 1rem 1.5rem;
  }
  
  .header-content {
    display: flex;
    justify-content: space-between;
    align-items: center;
    max-width: 1400px;
    margin: 0 auto;
  }
  
  h1 {
    margin: 0;
    font-size: 1.5rem;
    font-weight: 600;
    color: #f1f5f9;
  }
  
  .device-info {
    display: flex;
    align-items: center;
    gap: 0.75rem;
  }
  
  .device-name {
    font-size: 0.875rem;
    color: #94a3b8;
  }
  
  .status-indicator {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    animation: pulse 2s infinite;
  }
  
  .status-indicator.online {
    background: #10b981;
    box-shadow: 0 0 0 2px rgba(16, 185, 129, 0.2);
  }
  
  @keyframes pulse {
    0%, 100% { opacity: 1; }
    50% { opacity: 0.5; }
  }
  
  .console-container {
    flex: 1;
    display: flex;
    flex-direction: column;
    background: #0f172a;
    overflow: hidden;
  }
  
  .toolbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0.75rem 1.5rem;
    background: #1e293b;
    border-bottom: 1px solid #334155;
  }
  
  .toolbar-left {
    display: flex;
    gap: 0.5rem;
  }
  
  .filter-btn {
    padding: 0.375rem 0.75rem;
    background: transparent;
    border: 1px solid #334155;
    border-radius: 6px;
    color: #94a3b8;
    font-size: 0.875rem;
    cursor: pointer;
    transition: all 0.2s;
  }
  
  .filter-btn:hover {
    background: #334155;
    color: #f1f5f9;
  }
  
  .filter-btn.active {
    background: #3b82f6;
    border-color: #3b82f6;
    color: white;
  }
  
  .log-count {
    font-size: 0.875rem;
    color: #64748b;
  }
  
  .log-scroll {
    background: #0f172a;
  }
</style>