#!/bin/bash
# Call this script only when Minetest is not running (eg., just before running your daily backup).
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
shuf -n 1 $DIR/keywords.txt > $DIR/keyword.txt
