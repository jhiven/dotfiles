#!/usr/bin/env bash

username=$(id -u -n 1000)

sudo apt install nala
sudo su - <<EOF
apt update
apt upgrade -y 

apt install sudo nala -y
adduser $username sudo
EOF

echo "halaoalsdadsf"
