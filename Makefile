.PHONY: build run
build:
	docker build . --tag="git-cache"

run: build
	./run_cache.sh git-caching git-cache 8080 /var/cache/git
