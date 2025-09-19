# Development
dev:
	pnpm dev

# Build the library for distribution
build:
	pnpm build-svelte

# Build the demo app
build-demo:
	pnpm build

# Run type checking
check:
	pnpm check

# Clean build artifacts
clean:
	rm -rf dist
	rm -rf node_modules/.vite
	rm -rf .svelte-kit

# Install dependencies
install:
	pnpm install

# Run the preview server
preview:
	pnpm preview

# Publish to npm (after running checks and build)
publish:
	pnpm check
	pnpm build-svelte
	npm publish

# Publish a dry run (to see what would be published)
publish-dry:
	pnpm check
	pnpm build-svelte
	npm publish --dry-run

# Watch for changes and rebuild
watch:
	pnpm build-svelte --watch

# Format code
format:
	pnpm prettier --write .

# Link locally for testing in other projects
link:
	pnpm build-svelte
	npm link

# Unlink from local testing
unlink:
	npm unlink

# Run all checks before committing
pre-commit: check build-svelte
	@echo "✅ All checks passed!"

# Update dependencies
update:
	pnpm update

# Update dependencies interactively
update-interactive:
	pnpm update -i

.PHONY: dev build build-demo check clean install preview publish publish-dry watch format link unlink pre-commit update update-interactive