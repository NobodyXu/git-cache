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

    let diff_hour=target_hour-$(date +%H)
    [ $diff_hour -lt 0 ] && let diff_hour=diff_hour+24
    let diff_min=target_min-$(date +%M)
    [ $diff_min -lt 0 ] && let diff_min=diff_min+60 && let diff_hour=diff_hour-1

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
