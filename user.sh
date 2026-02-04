#!/bin/bash

source ./common.sh

app_name=user

check_root
nodejs_setup
app_setup
systemd_setup
