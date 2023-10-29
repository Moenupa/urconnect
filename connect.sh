#!/bin/bash

# default settings
DEFAULT_MACHINE=2
DEFAULT_GPU=5
HELPED=false

help()
{
	if $HELPED; then
		return
	fi
	HELPED=true
	echo "usage: connect.sh [netid] [port] [machineNo:1-4] [gpuNo:1-6]"
}

if [ $# -lt 2 ]; then
	help
	exit 1
fi

# cyclemachines ranged 1-4
if [[ ! -z "$3" && $3 -ge 1 && $3 -le 4 ]]
then
	machine=$3
else
	help
	machine=$DEFAULT_MACHINE
fi

# gpu ranged 1-6
if [[ ! -z "$4" && $4 -ge 1 && $4 -le 6 ]]
then
	gpu=$4
else
	help
	gpu=$DEFAULT_GPU
fi

netid=$1
port=$2
cpu_addr="cycle$machine.csug.rochester.edu"
gpu_addr="gpu-node0$gpu.csug.rochester.edu"

echo "netid=$netid, port=$port"
echo "  -> $cpu_addr"
echo "  -> $gpu_addr"
ssh -L $port:localhost:$port $netid@$cpu_addr -t ssh -L $port:localhost:$port $netid@$gpu_addr
