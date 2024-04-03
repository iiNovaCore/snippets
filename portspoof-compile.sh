#!/bin/bash
sudo apt-get update -y
sudo apt-get install build-essentials git tmux iptables -y

git clone https://github.com/drk1wi/portspoof.git && cd portspoof
sudo ./configure --sysconfdir=/etc/ && make && make install

nic = route | grep '^default' | grep -o '[^ ]*$'
sudo iptables -t nat -A PREROUTING -i $nic -p tcp -m tcp --dport 1:65535 -j REDIRECT --to-ports 4444
 
tmux new-session -d -s portspoof 'portspoof -c /etc/portspoof.conf -s /etc/portspoof_signatures -D'
