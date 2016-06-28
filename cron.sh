#!/bin/bash
# Call this script via cron to automatically change your interact keyword
# The minimum time between update should be reasonable (eg., don't update more than once per hour)
# Keep in mind this also updates tps_signs with the new keyword
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ $1 == 'random' ]]
then
  rand=$(strings /dev/urandom | grep -o '[[:alnum:]]' | head -n 4 | tr '[:upper:]' '[:lower:]' | tr -d '\n'; echo)
  echo $rand > $DIR/keyword.txt
elif [[ $1 == 'keyword' ]]
then
  shuf -n 1 $DIR/keywords.txt > $DIR/keyword.txt
else
  echo "Usage: $0 type"
  echo '  Where "type" is either random or keyword'
  echo
fi
