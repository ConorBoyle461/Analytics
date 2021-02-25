#This script will serve as the kdb plant admin script, start up, shut down, etc
#!/bin/bash
while getopts ":w:a:c:d:" opt; do
  case $opt in
    w) WORKDIR=${OPTARG:="."};;
    a) ACTION=${OPTARG:="START"};;
    c) CONFIG="$OPTARG";;                  #The component(s) you want to start/stop
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done


action_tickerplant () {                       #Needs script, action ,port, tplog dir and logFile
  echo "Applying action to kdb+ Ticker Plant"
  pwd
  cmd="/q/l64/q $1 -action $2 -port $3 -tpLog $4"
  echo "Running command: \"q $1 -action $2 -port $3 -tpLog $4 \" "	
  $cmd
	}


if [[  "" == $WORKDIR  ]]; then
  WORKDIR=~
else 
  echo "Moving to supplied working directory: $WORKDIR"
  cd $WORKDIR
fi

if [[  "" == $ACTION  ]];then
echo "No ACTION -a supplied. Executing config"

while IFS=\, read component action port script log_dir 
do
 echo "Executing $action for $component"
if [[ "ticker_plant" == $component ]];then
  cd $WORKDIR 
  pwd
  action_tickerplant $script $action $port $log_dir
fi
done<"$CONFIG"
fi

