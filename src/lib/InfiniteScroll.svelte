<script lang="ts">
  import { onMount } from 'svelte';
  
  interface Props<T = any> {
    onLoadMore: () => Promise<T[]>;
    threshold?: number;
  }
  
  let {
    onLoadMore,
    threshold = 100
  }: Props = $props();
  
  let element: HTMLElement;
  let loading = $state(false);
  let hasMore = $state(true);
  let observer: IntersectionObserver;
  
  async function handleIntersection(entries: IntersectionObserverEntry[]) {
    const entry = entries[0];
    if (entry.isIntersecting && !loading && hasMore) {
      loading = true;
      try {
        const items = await onLoadMore();
        if (items.length === 0) {
          hasMore = false;
          observer.disconnect();
        }
      } finally {
        loading = false;
      }
    }
  }
  
  onMount(() => {
    let scrollParent = element.parentElement;
    while (scrollParent) {
      const style = getComputedStyle(scrollParent);
      if (style.overflowY === 'auto' || style.overflowY === 'scroll') {
        break;
      }
      scrollParent = scrollParent.parentElement;
    }
    
    observer = new IntersectionObserver(handleIntersection, {
      root: scrollParent,
      rootMargin: `0px 0px ${threshold}px 0px`
    });
    
    observer.observe(element);
    
    return () => {
      observer.disconnect();
    };
  });
</script>

<div bind:this={element} class="load-more-indicator">
  {#if loading}
    <div class="spinner"></div>
    <span>Loading more...</span>
  {/if}
</div>

<style>
  .load-more-indicator {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 0.5rem;
    padding: 1rem;
    min-height: 60px;
  }
  
  .spinner {
    width: 16px;
    height: 16px;
    border: 2px solid rgba(148, 163, 184, 0.3);
    border-top: 2px solid #94a3b8;
    border-radius: 50%;
    animation: spin 1s linear infinite;
  }
  
  @keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
  }
</style>