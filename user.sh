#!/bin/bash

source ./common.sh

app_name=user

check_root
nodejs_setup
app_setup

cp $SCRIPT_DIR/user.service /etc/systemd/system/user.service
VALIDATE $? "Copying service file"

systemd_setup
print_total_time