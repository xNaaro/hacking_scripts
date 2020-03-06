#/bin/bash

NAME=$1
IP=$2

if [ -z "$1" ] || [ -z "$2" ];
then
	echo "Missing positional arguments: HOSTNAME IP"
	echo "Usage: bash basic_enum.sh localhost 127.0.0.1"
	exit 1

fi
echo "Running script with target $NAME/$IP"
echo "[*] Creating directory $NAME structure"
mkdir -p $NAME/{nmap,content,exploits,scripts}

echo "[*] Running NMAP all ports to $IP"
nmap -p- --open -T5 -v -n $IP -oN $NAME/nmap/allPorts

echo "[*] Running NMAP scripts to open ports"
open_ports=$(cat $NAME/nmap/allPorts | awk -v ORS=, '/ open/ {print $1}' FS='/' | sed 's/,$//')
nmap -sC -sV -p$open_ports $IP -oN $NAME/nmap/scriptPorts
