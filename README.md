# git-cache

![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/nobodyxu/git-cache.svg)
![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/nobodyxu/git-cache.svg)

![MicroBadger Size (tag)](https://img.shields.io/microbadger/image-size/nobodyxu/git-cache/latest)

A docker image for caching git clone/pull based on [jonasmalacofilho/git-cache-http-server][1], with

 1. git compression level turned to 9.
 2. `git gc --aggressive` run on every cached repository every night at 1:30 (can be overriden by environment variables `HOUR` and `MIN`, in 24 hour format).
 3. After `WAIT_TIMEOUT` (default to 4 hours, can be overloaded by environment variables), no new `git gc --aggressive` process will be spawned. In the next day, gc process will start from where it was left.
 4. The `git gc` process and the gc thread that account for monitoring and spawning `git gc` process is limited by:
     - nice set to 19
     - Using `SCHED_BATCH` scheduler.

*NOTE*:

The time inside container maybe is *different* from your host due to different timezone.

# Usage

## Pull from docker hub

Simply run `docker pull nobodyxu/git-cache`.

## How to build

Just run `make` to build it.

Optionally, you can run the docker image from [NobodyXu/apt-cache][2] to enable apt-cache.

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


If you have any problem using this repository or have advices on how to improve, please open a github issue and I will answer you as soon 
as possible.

# Reference:

 1. [jonasmalacofilho/git-cache-http-server][1]

[1]: https://github.com/jonasmalacofilho/git-cache-http-server
[2]: https://github.com/NobodyXu/apt-cache
