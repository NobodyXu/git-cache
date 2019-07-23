# git-cache

A docker image for caching git clone/pull based on [jonasmalacofilho/git-cache-http-server][1].

# Usage

## How to build

If you have [NobodyXu/apt-cache][2] installed, just run `make` to build it.


## How to run

After building the image, type `make run` to run the container, which also creates a volume for storing cache and publish a port on 8080.

## How to use

To use the cache, simply run

```
git config --global url."http://$HOST_IP:$PORT_NUMBER/".insteadOf https://
```

in the container or on other machines.

Reference:

 1. [jonasmalacofilho/git-cache-http-server][1]

[1]: https://github.com/jonasmalacofilho/git-cache-http-server
[2]: https://github.com/NobodyXu/apt-cache
