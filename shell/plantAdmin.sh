#This script will serve as the kdb plant admin script, start up, shut down, etc
#!/bin/bash

while getopts ":w:a:" opt; do
  case $opt in
    w) WORKDIR="$OPTARG";;
    a) ACTION="$OPTARG";;
    c) COMPONENT="$OPTARG";;                  #The component(s) you want to start/stop
    t) TPLOGDIR="$OPTARG";;
    l) LOGDIR="$OPTARG";;
    p) PORT="$OPTARG";;
    q) TPPORT="$OPTARG";;
    h) HDBDIR="$OPTARG";;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

echo "The working directory for these plant components is: $WORKDIR"
echo "Action supplied is: $ACTION"
