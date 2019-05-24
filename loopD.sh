#!/usr/bin/env bash


usage() { echo "Usage: loopD.sh [options] start

OPTIONS
-h, --help        Prints help.
-j, --jobfile     Path to associated jobfile. (Default jobs in current Dir)
-v, --verbose     Print jobs when being performed.
-i, --inteval     Sets interval in seconds (Default 60 seconds).
-l, --log         Sets logging filepath (Default off).


COMMANDS
start             Starts a scheduling cycle
          				Executes due jobs and sleeps.




Examples of usage:    (loopD.sh -j ~/jobs -i 60 start)&

" 1>&2; exit 1; }



checkforjobs(){

  #nastavi current cas
	verb="$2"
	jbs="$1"
	lg="$3"

	cas=`date '+%M %H %d %m %u'`
  set $cas
  currmin=$1
  currhour=$2
  currday=$3
  currmonth=$4
	currweekday=$5

  while read min hour day month weekday job; do

    #kontrola ci sedia zadane casi s realnym casom

    if [ "$min" = \* -o "$min"  = "$currmin" ] &&
    [ "$hour" = \* -o "$hour" = "$currhour" ] &&
    [ "$day" = \* -o "$day" = "$currday" ] &&
    [ "$month" = \* -o "$month" = "$currmonth" ] &&
    [ "$weekday" = \* -o "$week" = "$currweekday" ]; then

      eval "$job"
      if [ -n "$verb" ]; then
        echo "started $job"
      fi
      if [ -n "$lg" ]; then
        echo "${job}	$(date)" >> "$lg"
      fi

    fi
  done < "$jbs"
}


jobfile="jobs"
interval=60
log=""
verbose=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help)
      usage
      exit
      ;;
    -i|--interval)
      shift && interval="$1" && shift && continue
      ;;
    -j|--jobfile)
      shift && jobfile="$1" && shift && continue
      ;;
    -l|--log)
      # check if log exists
      shift && log="$1" && echo -n > "$log" && shift && continue
      ;;
    -v|--verbose)
      verbose="verbose" && shift && continue
      ;;
    start)
      if [ -z "$jobfile" ];then
        echo "please specify a jobfile"
        exit
      fi
      while :; do
        checkforjobs "$jobfile" "$verbose" "$log"
        sleep "$interval"
      done
      ;;
    *)
      usage
      exit
      ;;
  esac
done
