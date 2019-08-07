#!/usr/bin/env python3

import threading
import subprocess
import time
import os
import pathlib
import signal

def diff_in_sec(target_hour, target_min):
    curr_time = time.gmtime() # Get UTC time
    
    curr_hour = curr_time.tm_hour
    curr_min = curr_time.tm_min

    diff_min  = target_min - curr_min
    diff_hour = target_hour - curr_hour

    if diff_min < 0:
        diff_min += 60
        diff_hour -= 1

    if diff_hour < 0:
        diff_hour += 24

    return diff_hour * 3600 + diff_min * 60

def sleep_until(target_hour, target_min):
    time.sleep(diff_in_sec(target_hour, target_min))

def for_each_git_dir(command, prefix):
    # Since the cache dir has 3 levels:
    #     Site level (github, gitlab, ...)
    #     User name level
    #     repo name level
    while True:
        for repo_path in pathlib.Path(prefix).glob("*/*/*"):
            print("[ git gc --aggressive ]: Running in mirror:", repo_path)

            p = subprocess.Popen(command, stdin = subprocess.DEVNULL, close_fds = True, cwd = repo_path, restore_signals = True)

            print("[ git gc --aggressive ]: Exit status of `git gc` in mirror", repo_path, ":", p.wait())
            yield False
        yield True

def run_daemon():
    def run():
        return subprocess.Popen("git-cache-http-server", stdin = subprocess.DEVNULL, close_fds = True, restore_signals = True)

    while True:
        print("[ git-cache-http-server ] Starting...")

        cache_server = run()
        ret_code = cache_server.wait()

        print("[ git-cache-http-server ] exited with status code", ret_code)

daemon_monitor = threading.Thread(target = run_daemon, name = "daemon_monitor")
daemon_monitor.start()

target_hour  = int(os.environ.get("HOUR", 1))
target_min   = int(os.environ.get("MIN",  30))
# 14400 seconds = 4 hours
wait_timeout = int(os.environ.get("WAIT_TIMEOUT", 14400)) * 1000000000 # In nano second. 1 sec = 1000000000 ns

gc_progress = for_each_git_dir(["/usr/bin/env", "git", "gc", "--aggressive"], "/var/cache/git")

# Limit CPU usage
os.nice(19)

while True:
    sleep_until(target_hour, target_min)

    start_time = time.time_ns()

    for is_finished in gc_progress:
        if is_finished or time.time_ns() - start_time >= wait_timeout:
            # sleep for 1 min in case of the git gc command finish within one min.
            # In this case, sleep_until with return immediately and the whole gc_progress will be started again
            time.sleep(60)
            break
