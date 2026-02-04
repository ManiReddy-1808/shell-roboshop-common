#!/bin/bash

source ./common.sh

app_name=redis
check_root

dnf list installed redis &>>$LOGS_FILE
if [ $? -eq 0 ];then
    echo -e "Redis already installed... $Y SKIPPING $N"
else
    dnf module disable redis -y &>>$LOGS_FILE
    VALIDATE $? "Disabling Redis Module"

    dnf module enable redis:7 -y &>>$LOGS_FILE
    VALIDATE $? "Enabling Redis 7 Module"

    dnf install redis -y &>>$LOGS_FILE
    VALIDATE $? "Installing Redis Server"
fi

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
VALIDATE $? "Allowing remote connections"

systemctl enable redis &>>$LOGS_FILE
VALIDATE $? "Enabling Redis Service"

systemctl start redis &>>$LOGS_FILE
VALIDATE $? "Starting Redis Service"

print_total_time