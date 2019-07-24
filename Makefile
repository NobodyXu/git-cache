.PHONY: build run
build:
	docker build . --tag="git-cache" $(${NO_APT_PROXY} && echo "--build-arg APT_PROXY_PORT=''")

run:
	./run_cache.sh git-caching git-cache 8080 /var/cache/git

SHELL: /bin/bash
