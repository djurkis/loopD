#!/usr/bin/env bash

usage() { echo "Usage: jobmaker.sh [options] [file]
OPTIONS
-h, --help        Prints help.
-l, --list        List jobs.
-j, --jobfile     Sets path for jobfile. (Default jobs)
-f pathtofile     Specifies file as an inupt for updating jobs.


Format:
* stands for a wildcard which is every instance of a time unit.

#  ┌───────────── minute (00 - 59)
#  │ ┌───────────── hour (00 - 23)
#  │ │ ┌───────────── day of month (01 - 31)
#  │ │ │ ┌───────────── month (01 - 12)
#  │ │ │ │ ┌───────────── day of week (1 - 7) (Monday to Sunday);
#  │ │ │ │ │
#  │ │ │ │ │
#  │ │ │ │ │
#  * * * * *  some-script

Where some-script is a single word name of an **executable** file
to be executed in a new shell.

Examples of usage:    ./jobmaker.sh -f jobsduringweekend -l
                      ./jobmaker.sh -j ~/mystuff/secretjobs -f forkbomb -l -h

" 1>&2; exit 1; }

kontrola(){

  #kontroluje jednotlive riadky v update file ci su v spravnom formate

  while read min hour day month weekday job; do
    r=$(echo "$min" | sed -E 's/^([0-9]|[0-5][0-9])$/suc/')

    if [[ "$r" != "suc" ]] && [[ "$min" != \* ]]; then
      echo "Invalid job format minutes"
      exit 1
    fi

    r=$(echo "$hour" | sed -E 's/^([0-9]|[0-2][0-3])$/suc/')

    if [[ "$r" != "suc" ]] && [[ "$hour" != \* ]]; then
      echo "Invalid job format hours"
      exit 1
    fi
    # know your month-days
    r=$(echo "$day" | sed -E 's/^([0-2][0-9]|3[0-1])$/suc/')

    if [[ "$r" != "suc" ]] && [[ "$day" != \* ]]; then
      echo "Invalid job format days"
      exit 1
    fi

    r=$(echo "$month" | sed -E 's/^([0-9]|1[0-2])$/suc/')

    if [[ "$r" != "suc" ]] && [[ "$month" != \* ]]; then
      echo "Invalid job format months"
      exit 1
    fi
    r=$(echo "$weekday" | sed -E 's/^([1-7])$/suc/')

    if [[ "$r" != "suc" ]] && [[ "$weekday" != \* ]]; then
      echo "Invalid job format weekdays"
      exit 1
    fi
  done < "$1"
}



updatejobs(){
  cat "$2" >> "$1"
  echo 'Update succesfull'
}


new=""
jobfile="jobs"

while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help)
      usage
      exit
      ;;
    -j|--jobfile)
      shift && jobfile="$1" && shift && continue
      ;;
    -l|--list)
      # check if log exists
      cat "$jobfile" && shift && continue
      ;;
    -f)
      shift
      new="$1"
      if [ -z "$new" ]; then
        usage
        exit 1
      fi
      if kontrola "$new" ; then
        updatejobs "$jobfile" "$new"
      else
        echo "Invalid inputfile"
        exit 1
      fi
      shift
      ;;
    *)
      usage
      exit 0
      ;;
  esac
done
