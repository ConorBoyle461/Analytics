#!/bin/bash
#This script will serve as the kdb plant admin script, start up, shut down, etc
while getopts ":w:a:c:d:" opt; do
  case $opt in
    a) ACTION="$OPTARG";;                  #The component(s) you want to start/stop
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done
WORKDIR=$HOME/Analytics/

action_tickerplant () {                       #Needs script, action ,port, tplog dir and logFile
  echo "Applying action to kdb+ Ticker Plant"
  echo "Running command: $QHOME/l64/q $WORKDIR/$1 -action $2 -port $3 -tpLog $4 &"
  $QHOME/l64/q $WORKDIR/$1 -action $2 -port $3 -tpLog $4 &
  #echo "Running command: $cmd "	
  }

if [[  "RUN_CONFIG" == $ACTION  ]];then
  cd $WORKDIR 
  echo " RUN_CONFIG action(-a) supplied. Executing config."
  while IFS=\, read component action port script log_dir 
  do
  echo "Executing $action for $component"
  if [[ "ticker_plant" == $component ]];then
    action_tickerplant $script $action $port $log_dir
  
  elif [[  "realtime_db" == $component ]];then
    action_rdb $script $action $port $log_dir
 
  fi
  echo "Continuing"
  done<"config/advancedKdb/plantConfig.txt"
fi
