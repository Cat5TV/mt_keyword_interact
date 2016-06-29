#!/bin/bash
# Call this script via cron to automatically change your interact keyword
# The minimum time between update should be reasonable (eg., don't update more than once per hour)
# On The Pixel Shadow servers, we have this run in our daily backup script (once per day)
# Keep in mind this also updates tps_signs with the new keyword
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ $1 == 'random' ]]
then
  rand=$(`which timeout` 15s `which strings` /dev/urandom | `which grep` -o '[[:alnum:]]' | `which head` -n 4 | `which tr` '[:upper:]' '[:lower:]' | `which tr` -d '\n'; echo)
  echo $rand > $DIR/keyword.txt
elif [[ $1 == 'keyword' ]]
then
  shuf -n 1 $DIR/keywords.txt > $DIR/keyword.txt
else
  echo "Usage: $0 type"
  echo '  Where "type" is either random or keyword'
  echo
fi
