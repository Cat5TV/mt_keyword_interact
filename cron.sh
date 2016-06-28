#!/bin/bash
# Call this script via cron to automatically change your interact keyword
# The minimum time between update should be reasonable (eg., don't update more than once per hour)
# Keep in mind this also updates tps_signs with the new keyword
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
shuf -n 1 $DIR/keywords.txt > $DIR/keyword.txt
