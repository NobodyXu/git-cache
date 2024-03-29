.PHONY: build run
build:
	docker build . --tag="nobodyxu/git-cache" $(${NO_APT_PROXY} && echo "--build-arg APT_PROXY_PORT=''")

run:
	./run_cache.sh git-caching nobodyxu/git-cache 8080 /var/cache/git git-cache

SHELL: /bin/bash
