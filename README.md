# git-cache

A docker image for caching git clone/pull based on [jonasmalacofilho/git-cache-http-server][1].

# Usage

Use `make` to build the image and `make run` to run the container, which also creates a volume for storing cache and publish a port on 8080.

To use the cache, simply run

```
git config --global url."http://$HOST_IP:$PORT_NUMBER/".insteadOf https://
```

in the container or on other machines.

Reference:

 1. [jonasmalacofilho/git-cache-http-server][1]

[1]: https://github.com/jonasmalacofilho/git-cache-http-server
