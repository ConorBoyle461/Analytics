#!/bin/bash
#This script will serve as the kdb plant admin script, start up, shut down, etc
while getopts ":w:a:c:d:" opt; do
  case $opt in
    a) ACTION="$OPTARG";;                  #The component(s) you want to start/stop
    c) COMPONENT="$OPTARG";;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done
WORKDIR=$HOME/Analytics/
cd $WORKDIR
CONFIG=$WORKDIR/config/advancedKdb/plantConfig.cfg
source $CONFIG

declare -A function_map

function_map[tp]=start_tickerplant
function_map[rdb]=start_rdb
function_map[loader]=start_loader

declare -A component_pids

component_pids[tp]=$(pgrep -f $tp_script)
component_pids[rdb]=$(pgrep -f $rdb_script)
component_pids[loader]=$(pgrep -f $loader_script)
 
action_component () {                       #This takes a component: "tp", "rdb" or "loader" and applies the input action to it 
  if [[  $2 == "START"  ]];
  then
    if [[ -z ${component_pids[$1]}  ]];then
       ${function_map[$1]}  $2
    else 
      echo "The $1 process is already running on pid ${component_pids[$1]}"
    fi
  elif [[ $2 == "KILL"  ]];
  then
    if [[ ! -z ${component_pids[$1]}  ]];then
      echo "Killing $1 process on ${component_pids[$1]}"
      kill ${component_pids[$1]}
    else
      echo "The process is already dead"
    fi
  elif [[ $2 == "TEST" ]];
  then
    if [[ ! -z ${component_pids[$1]} ]];then 
      echo "$1 process running on ${component_pids[$1]}"
    else
      echo "There is no $1 process running"
    fi
  else
    echo "You have entered an invalid action. Please use: START, TEST , KILL"
  fi
  }

start_tickerplant () {
    echo "Starting TP with command: $q_path $WORKDIR/$tp_script -action $tp_action -port $tp_port -tpLog $tp_log_dir &"
    $q_path $WORKDIR/$tp_script -action $1 -port $tp_port -tpLog $tp_log_dir &
    }

start_rdb () {
  echo "Starting RDB with command: $q_path $WORKDIR/$rdb_script -action $1 -schema $rdb_schema -port $2 -tpPort $tp_port -tables $3 &"
  $q_path $WORKDIR/$rdb_script -action $1 -schema $rdb_schema -port $2 -tpPort $tp_port -tables $3 &
  }

start_loader () {
  echo "Starting loader with command: $q_path $WORKDIR/$loader_script -action $1 -port $tp_port &"
  $q_path $WORKDIR/$loader_script -action $1 -port $tp_port &
  }

if [[  -z $COMPONENT  ]];then
  echo "No component supplied. Applying action to all components "
  echo "Executing $ACTION for $COMPONENT"
  action_tickerplant $ACTION 
  action_rdb $ACTION $rdb1_port "trade quote" 
  action_rdb $ACTION $rdb2_port "trade quote aggregation"
  action_loader $ACTION 
  echo "Completed"

else
  echo "Component $COMPONENT supplied. Applying $ACTION to $COMPONENT"
  action_component $COMPONENT $ACTION 
fi


