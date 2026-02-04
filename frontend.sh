#!/bin/bash

source ./common.sh

app_name=frontend
app_dir=/usr/share/nginx/html

check_root

dnf list installed nginx &>>$LOGS_FILE
if [ $? -ne 0 ]; then
    dnf module disable nginx -y &>>$LOGS_FILE
    VALIDATE $? "Disabling NGINX Module"

    dnf module enable nginx:1.24 -y &>>$LOGS_FILE
    VALIDATE $? "Enabling NGINX 1.24 Module"

    dnf install nginx -y &>>$LOGS_FILE
    VALIDATE $? "Installing NGINX..."
else
    echo -e "NginX already installed.... $Y SKYPPING $N"
fi
systemctl enable nginx &>>$LOGS_FILE
VALIDATE $? "Enabling NGINX"

systemctl start nginx &>>$LOGS_FILE
VALIDATE $? "Starting NGINX"

rm -rf $app_dir/* &>>$LOGS_FILE
VALIDATE $? "Remove default content."

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$LOGS_FILE
VALIDATE $? "Downloading frontend code"

cd $app_dir &>>$LOGS_FILE
VALIDATE $? "Going to html folder"

unzip /tmp/frontend.zip &>>$LOGS_FILE
VALIDATE $? "Unziping frontend code"

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf &>>$LOGS_FILE
VALIDATE $? "Copying NGINX Config File"

systemctl restart nginx  &>>$LOGS_FILE
VALIDATE $? "Restarting NGINX Service"

print_total_time