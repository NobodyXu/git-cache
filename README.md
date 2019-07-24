# git-cache

A docker image for caching git clone/pull based on [jonasmalacofilho/git-cache-http-server][1].

# Usage

## How to build

Just run `make` to build it.

Optionally, you can run the docker image from [NobodyXu/apt-cache][2].

### *NOTE* 

The image will automatically test whether port 8000 on your machine is open, so if you run something else on 8000 that is not a squid-deb-proxy, run `env NO_APT_PROXY=true make`.

## How to run

After building the image, type `make run` to run the container, which also creates a volume for storing cache and publish a port on 8080.

## How to use

To use the cache, simply run

```
git config --global url."http://$HOST_IP:$PORT_NUMBER/".insteadOf https://
```

in the container or on other machines.

# Reference:

 1. [jonasmalacofilho/git-cache-http-server][1]

[1]: https://github.com/jonasmalacofilho/git-cache-http-server
[2]: https://github.com/NobodyXu/apt-cache
