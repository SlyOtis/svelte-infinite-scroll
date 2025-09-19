<div align="center">
  <img src="./logo.svg" alt="Sly Svelte Infinite Scroll Logo" width="200" height="200">
  
  <h1>Sly Svelte Infinite Scroll</h1>
  
  <span><i>Dead simple infinite scroll for Svelte 5 - just add to the end of any list</i></span>
  
  <img src="https://img.shields.io/npm/v/sly-svelte-infinite-scroll.svg" alt="npm version">
  <img src="https://img.shields.io/bundlephobia/minzip/sly-svelte-infinite-scroll" alt="bundle size">
  <img src="https://img.shields.io/badge/Svelte-5-FF3E00.svg" alt="Svelte 5">
  <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="MIT License">
</div>

<div align="center">
  
  [About](#about) • [Features](#features) • [Installation](#installation) • [Usage](#usage) • [Examples](#examples)
  
</div>

## About

A minimal infinite scroll component that you simply add to the end of your list. When it becomes visible, it calls your load function. When that function returns an empty array, it stops. No complex configuration, no managing state - it just works.

## Features

- **Drop-in Component** - Add to the end of any list, no wrapper needed
- **Auto-detection** - Automatically stops when you return an empty array
- **Performance First** - Uses IntersectionObserver for efficient scroll detection
- **Zero Dependencies** - Just Svelte 5, nothing else

## Installation

```bash
pnpm add sly-svelte-infinite-scroll
```

```bash
npm install sly-svelte-infinite-scroll
```

```bash
yarn add sly-svelte-infinite-scroll
```

### Requirements
- Svelte 5.0.0 or higher
- Modern browser with IntersectionObserver support

## Usage

```svelte
<script lang="ts">
  import { InfiniteScroll } from 'sly-svelte-infinite-scroll';
  
  let items = $state([]);
  
  async function loadMore() {
    const response = await fetch('/api/items?offset=' + items.length);
    const newItems = await response.json();
    
    items = [...items, ...newItems];
    return newItems; // Return empty array to stop
  }
</script>

<div class="list">
  {#each items as item}
    <div>{item.name}</div>
  {/each}
  
  <InfiniteScroll onLoadMore={loadMore} />
</div>
```

### Technologies

The component leverages modern web APIs and Svelte's latest features for optimal performance:

- **Svelte 5 Runes** - Using the new reactivity system with `$state` and `$props` [docs](https://svelte.dev/docs/svelte/runes)
- **IntersectionObserver API** - Efficient visibility detection without scroll listeners [docs](https://developer.mozilla.org/en-US/docs/Web/API/IntersectionObserver)
- **TypeScript** - Full type safety with generic item types [docs](https://www.typescriptlang.org/)

## Examples

### Basic List with API Pagination

```svelte
<script lang="ts">
  import { InfiniteScroll } from 'sly-svelte-infinite-scroll';
  
  interface Post {
    id: number;
    title: string;
    body: string;
  }
  
  let posts = $state<Post[]>([]);
  let page = $state(1);
  
  async function loadMore() {
    const res = await fetch(`/api/posts?page=${page}&limit=20`);
    const newPosts = await res.json();
    
    posts = [...posts, ...newPosts];
    page++;
    
    return newPosts; // Component stops when this is empty
  }
</script>

<div class="posts">
  {#each posts as post (post.id)}
    <article>
      <h2>{post.title}</h2>
      <p>{post.body}</p>
    </article>
  {/each}
  
  <InfiniteScroll onLoadMore={loadMore} threshold={300} />
</div>
```

### Log Viewer with Maximum Items

```svelte
<script lang="ts">
  import { InfiniteScroll } from 'sly-svelte-infinite-scroll';
  import LogLine from './LogLine.svelte';
  
  let logs = $state([]);
  let cursor = $state('');
  
  async function loadMore() {
    // Stop after 2000 items
    if (logs.length >= 2000) return [];
    
    const res = await fetch(`/api/logs?cursor=${cursor}`);
    const { items, nextCursor } = await res.json();
    
    logs = [...logs, ...items];
    cursor = nextCursor;
    
    return items;
  }
  
  $effect(() => {
    loadMore(); // Load initial data
  });
</script>

<div class="log-viewer">
  {#each logs as log (log.id)}
    <LogLine {log} />
  {/each}
  
  <InfiniteScroll onLoadMore={loadMore} threshold={200} />
</div>
```

Check out the full [example app](./src/App.svelte) in the repository for a complete implementation with a device console log viewer.