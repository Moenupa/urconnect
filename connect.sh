#!/bin/bash

# default settings
DEFAULT_MACHINE=2
DEFAULT_GPU=5
DEFAULT_PORT=6664
HELPED=false

help()
{
	if $HELPED
	then
		return
	fi
	HELPED=true
	echo "usage: connect.sh [netid] [cycleNo] [gpuNo] [port]"
	echo "		  [netid]	- your netid"
	echo "		  [cycleNo]	- cycle machine no. [1-4] (default=2)"
	echo "		  [gpuNo]	- gpu machine no. [1-6] (default=5)"
	echo "		  [port]	- forward port no. [1024-65535] (default=8888)"
}

# if no arguments, print help
if [ $# -eq 0 ]
then
	echo "ERROR: No Arguments"
	help
	exit 1
fi

# cyclemachines ranged 1-4
if [[ ! -z "$2" && $2 -ge 1 && $2 -le 4 ]]
then
	machine=$2
else
	if [[ ! -z "$2" ]]
	then
		help
	fi
	machine=$DEFAULT_MACHINE
fi

# gpu ranged 1-6
if [[ ! -z "$3" && $3 -ge 1 && $3 -le 6 ]]
then
	gpu=$3
else
	if [[ ! -z "$3" ]]
	then
		help
	fi
	gpu=$DEFAULT_GPU
fi

# port ranged 1024-65535
if [[ ! -z "$4" && $4 -ge 1024 && $3 -le 65535 ]]
then
	port=$4
else
	if [[ ! -z "$4" ]]
	then
		help
	fi
	port=$DEFAULT_PORT
fi

netid=$1
cpu_addr="cycle$machine.csug.rochester.edu"
gpu_addr="gpu-node0$gpu.csug.rochester.edu"

if [ $# -lt 3 ]
then
	echo "netid=$netid"
	echo "  -> $cpu_addr"
	ssh $netid@$cpu_addr
else
	echo "netid=$netid, port=$port"
	echo "  -> $cpu_addr"
	echo "  -> $gpu_addr"
	ssh -L $port:localhost:$port $netid@$cpu_addr -t ssh -L $port:localhost:$port $netid@$gpu_addr
fi
