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
CONFIG=$WORKDIR/config/advancedKdb/plantConfig.cfg
source $CONFIG

action_tickerplant () {                       #Needs script, action ,port, tplog dir and logFile
  echo "Applying action to TP"
  echo "Running command: $QHOME/l64/q $WORKDIR/$tp_script -action $tp_action -port $tp_port -tpLog $tp_log_dir &"
  $QHOME/l64/q $WORKDIR/$tp_script -action $tp_action -port $tp_port -tpLog $tp_log_dir &
  }

action_rdb1 () {
  echo "Applying action to RDB"
  echo "Running command: $QHOME/l64/q $WORKDIR/$rdb_script -action $rdb1_acton -schema $rdb_schema -port $rdb1_port -tpPort $tp_port -tables $rdb1_tables &"
  $QHOME/l64/q $WORKDIR/$rdb_script -action $rdb1_acton -schema $rdb_schema -port $rdb1_port -tpPort $tp_port -tables $rdb1_tables &
  }

action_rdb2 () {
  echo "Applying action to RDB"
  echo "Running command: $QHOME/l64/q $WORKDIR/$rdb_script -action $rdb2_acton -schema $rdb2_schema -port $rdb2_port -tpPort $tp_port -tables $rdb2_tables &"
  $QHOME/l64/q $WORKDIR/$rdb_script -action $rdb2_acton -schema $rdb2_schema -port $rdb2_port -tpPort $tp_port -tables $rdb2_tables &
  }

action_loader () {
  echo "Applying action to loader"
  echo "Running command: $QHOME/l64/q $WORKDIR/$feed_script -action $load_action -port $tp_port &"
  $QHOME/l64/q $WORKDIR/$feed_script -action $load_action -port $tp_port &
  }



if [[  "RUN_CONFIG" == $ACTION  ]];then
  cd $WORKDIR 
  echo " RUN_CONFIG action(-a) supplied. Reading and executing config."
  source $CONFIG 
  echo "Executing $action for $component"
  action_tickerplant 
  action_rdb1 
  echo "Completed"
fi
