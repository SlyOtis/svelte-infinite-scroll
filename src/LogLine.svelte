<script lang="ts">
  interface LogEntry {
    id: string;
    timestamp: number;
    level: 'debug' | 'info' | 'warn' | 'error';
    message: string;
    source: string;
    metadata?: Record<string, any>;
  }
  
  let { log }: { log: LogEntry } = $props();
  let expanded = $state(false);
  
  const levelColors = {
    debug: '#64748b',
    info: '#3b82f6',
    warn: '#f59e0b',
    error: '#ef4444'
  };
  
  const levelBgColors = {
    debug: 'rgba(100, 116, 139, 0.1)',
    info: 'rgba(59, 130, 246, 0.1)',
    warn: 'rgba(245, 158, 11, 0.1)',
    error: 'rgba(239, 68, 68, 0.1)'
  };
  
  function formatTime(timestamp: number): string {
    const date = new Date(timestamp);
    return date.toLocaleTimeString('en-US', {
      hour12: false,
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit'
    });
  }
  
  function formatMillis(timestamp: number): string {
    return String(new Date(timestamp).getMilliseconds()).padStart(3, '0');
  }
</script>

<div class="log-line {log.level}" class:expanded>
  <button 
    class="expand-toggle"
    onclick={() => expanded = !expanded}
    aria-label={expanded ? 'Collapse' : 'Expand'}
    disabled={!log.metadata}
  >
    {#if log.metadata}
      <svg width="12" height="12" viewBox="0 0 12 12" class:rotated={expanded}>
        <path d="M3 5L6 8L9 5" stroke="currentColor" stroke-width="1.5" fill="none"/>
      </svg>
    {/if}
  </button>
  
  <span class="timestamp">
    <span class="time">{formatTime(log.timestamp)}</span>
    <span class="millis">.{formatMillis(log.timestamp)}</span>
  </span>
  
  <span 
    class="level-badge" 
    style="background: {levelBgColors[log.level]}; color: {levelColors[log.level]}"
  >
    {log.level.toUpperCase()}
  </span>
  
  <span class="source">{log.source}</span>
  
  <span class="message">{log.message}</span>
  
  {#if expanded && log.metadata}
    <div class="metadata">
      {#each Object.entries(log.metadata) as [key, value]}
        <div class="metadata-item">
          <span class="metadata-key">{key}:</span>
          <span class="metadata-value">{value}</span>
        </div>
      {/each}
    </div>
  {/if}
</div>

<style>
  .log-line {
    display: grid;
    grid-template-columns: 24px 120px 60px 100px 1fr;
    align-items: center;
    padding: 0.5rem 1rem;
    font-family: 'SF Mono', Monaco, 'Cascadia Code', monospace;
    font-size: 0.8125rem;
    transition: background 0.15s;
    position: relative;
    border-bottom: 1px solid #1e293b;
  }
  
  .log-line:hover {
    background: rgba(30, 41, 59, 0.4);
  }
  
  .log-line.expanded {
    background: rgba(30, 41, 59, 0.6);
  }
  
  .expand-toggle {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 20px;
    height: 20px;
    padding: 0;
    background: transparent;
    border: none;
    color: #64748b;
    cursor: pointer;
    border-radius: 4px;
    transition: all 0.15s;
  }
  
  .expand-toggle:not(:disabled):hover {
    background: rgba(100, 116, 139, 0.2);
    color: #94a3b8;
  }
  
  .expand-toggle:disabled {
    cursor: default;
  }
  
  .expand-toggle svg {
    transition: transform 0.2s;
  }
  
  .expand-toggle svg.rotated {
    transform: rotate(180deg);
  }
  
  .timestamp {
    display: flex;
    align-items: baseline;
    color: #64748b;
    font-variant-numeric: tabular-nums;
  }
  
  .time {
    color: #94a3b8;
  }
  
  .millis {
    font-size: 0.75rem;
    color: #475569;
    margin-left: 1px;
  }
  
  .level-badge {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 0.125rem 0.375rem;
    border-radius: 4px;
    font-size: 0.6875rem;
    font-weight: 600;
    letter-spacing: 0.025em;
  }
  
  .source {
    color: #22d3ee;
    font-size: 0.75rem;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
  
  .message {
    color: #e2e8f0;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
  
  .log-line.error .message {
    color: #fca5a5;
  }
  
  .log-line.warn .message {
    color: #fcd34d;
  }
  
  .metadata {
    grid-column: 2 / -1;
    margin-top: 0.5rem;
    padding: 0.5rem;
    background: rgba(15, 23, 42, 0.5);
    border-radius: 4px;
    border-left: 2px solid #334155;
    display: flex;
    flex-wrap: wrap;
    gap: 1rem;
  }
  
  .metadata-item {
    display: flex;
    gap: 0.375rem;
  }
  
  .metadata-key {
    color: #64748b;
    font-size: 0.75rem;
  }
  
  .metadata-value {
    color: #94a3b8;
    font-size: 0.75rem;
  }
</style>