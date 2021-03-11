#!/bin/bash
#This script will serve as the kdb plant admin script, start up, shut down, etc
while getopts ":a:c:" opt; do
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
function_map[rdb1]=start_rdb
function_map[rdb2]=start_rdb
function_map[cep]=start_cep
function_map[loader]=start_loader

declare -A component_pids

component_pids[tp]=$(pgrep -f $tp_script)
component_pids[rdb1]=$(lsof -i:$rdb1_port | tail -1| awk '{print $2}')
component_pids[rdb2]=$(lsof -i:$rdb2_port | tail -1| awk '{print $2}')
component_pids[loader]=$(pgrep -f $loader_script)
component_pids[cep]=$(pgrep -f $cep_script)

declare -A port_map
port_map[tp]=$tp_port
port_map[rdb1]=$rdb1_port
port_map[rdb2]=$rdb2_port

declare -A rdb_sub
rdb_sub[rdb1]=$rdb1_tables
rdb_sub[rdb2]=$rdb2_tables
rdb_sub[cep]=$rdb2_tables
 
function action_component () {                       #This takes a component: "tp", "rdb" or "loader" and applies the input action to it 
  if [[  $2 == "START"  ]];
  then
    if [[ -z ${component_pids[$1]}  ]];then
       echo $4
       ${function_map[$1]}  $2 $3 "$4"
    else 
      echo "The $1 process is already running on pid ${component_pids[$1]}"
    fi
  elif [[ $2 == "KILL"  ]];
  then
    if [[ ! -z ${component_pids[$1]}  ]];then
      echo "Killing $1 process on ${component_pids[$1]}"
      kill ${component_pids[$1]}
    else
      echo "The $1 process is already dead"
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

function start_tickerplant () {
    echo "Starting TP with command: $q_path $WORKDIR/$tp_script -action $tp_action -port $tp_port -tpLog $tp_log_dir &"
    $q_path $WORKDIR/$tp_script -action $1 -port $tp_port -tpLog $tp_log_dir &
    }

function start_rdb () {
  echo "Starting RDB with command: $q_path $WORKDIR/$rdb_script -action $1 -schema $rdb_schema -port $2 -tpPort $tp_port -tables $3 &"
  $q_path $WORKDIR/$rdb_script -action $1 -schema $rdb_schema -port $2 -tpPort $tp_port -tables $3 &
  }

function start_cep () {
  echo "Starting CEP with command: $q_path $WORKDIR/$cep_script -action $1 -schema $rdb_schema -tpPort $tp_port -tables $3 &"
  $q_path $WORKDIR/$cep_script -action $1 -schema $rdb_schema -tpPort $tp_port -tables $3 &
  }

function start_loader () {
  echo "Starting loader with command: $q_path $WORKDIR/$loader_script -action $1 -port $tp_port &"
  $q_path $WORKDIR/$loader_script -action $1 -port $tp_port &
  }

if [[  -z $COMPONENT  ]];then
  echo "No component supplied. Applying action to all components "
  echo "Executing $ACTION for all components"
  action_component tp $ACTION 
  action_component rdb1 $ACTION  ${port_map[rdb1]} "${rdb_sub[rdb1]}"
  action_component rdb2 $ACTION  ${port_map[rdb2]} "${rdb_sub[rdb2]}"
  action_component loader $ACTION  
  action_component cep $ACTION  ${port_map[cep]} "${rdb_sub[rdb2]}"
  echo "Completed"

else
  echo "Component $COMPONENT supplied. Applying $ACTION to $COMPONENT"
  action_component $COMPONENT $ACTION  ${port_map[$COMPONENT]} "${rdb_sub[$COMPONENT]}"
fi


