#!/bin/bash

source ./common.sh

check_root

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copying mongo.repo file"

dnf install mongodb-org -y &>>$LOGS_FILE
VALIDATE $? "Installing MongoDB server"

systemctl enable mongod &>>$LOGS_FILE
VALIDATE $? "Enabling mongodb"

systemctl start mongod &>>$LOGS_FILE
VALIDATE $? "Started mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Allowing Remote Connection"

systemctl restart mongod &>>$LOGS_FILE
VALIDATE $? "Restarted MongoDB"

print_total_time