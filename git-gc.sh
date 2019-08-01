#!/usr/bin/env bash

for_each_git_dir() {
    run_when_success="$1"
    prefix="$2"

    # Since the cache dir has 3 levels:
    #     Site level (github, gitlab, ...)
    #     User name level
    #     repo name level
    for repo in ${prefix}/*/*/*; do
        cd "${repo}" && eval "${run_when_success}"
    done
}

sleep_until() {
    target_hour="$1"
    target_min="$2"

    # In case of race condition:
    #  1. After fetching hour when fetching min, hour and min changed. E.x., 16:59->17:00, the process will get 16:00.
    #  2. Vice versa.
    # In the first  situation, the process may be sleep for an additional hour.
    # In the second situation, the process may be sleep for an additional min.
    HM=($(date +'%H %M'))
    let diff_hour=target_hour-${HM[0]}
    let diff_min=target_min-${HM[1]}
    [ $diff_min -lt 0 ] && let diff_min=diff_min+60 && let diff_hour=diff_hour-1
    [ $diff_hour -lt 0 ] && let diff_hour=diff_hour+24

    sleep "${diff_hour}h" "${diff_min}m"
}

hour=1
[ -n "$HOUR" ] && hour=$HOUR
min=30
[ -n "$MIN" ] && min=$MIN

while true; do
    sleep_until $hour $min
    for_each_git_dir "git gc --aggressive" "/var/cache/git"
done
