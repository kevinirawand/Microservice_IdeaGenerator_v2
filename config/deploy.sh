#!/bin/bash

# This deploy script will pull the latest on the server from the specified branch,
# and compile the static assets. You need your public key in the authorized_keys
# file for the deploy user.

server_user="ubuntu"
repo_url="git@github.com:okyzaprabowo/ideageneratorv2.git"

if [ ! -z $1 ]
then
    server_address=$1
else
    server_address="13.229.233.83"
fi

ssh_port="22"

repo_path="/var/www/html/ideageneratorv2/"
branch="development"

ssh $server_user@$server_address -p $ssh_port \
    "echo 'Starting deploy...' && \
    cd $repo_path && \
    git checkout $branch && \
    git pull && \
    sudo service nginx restart && \
    echo 'Finished!'"