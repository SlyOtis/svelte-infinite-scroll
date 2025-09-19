# List available recipes
default:
    @just --list

# Start development server
dev:
    pnpm dev

# Build the library for distribution
build:
    pnpm check
    pnpm build-svelte

# Deploy to npm
deploy: build
    npm publish