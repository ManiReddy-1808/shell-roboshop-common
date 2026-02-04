#!/bin/bash

source ./common.sh
app_name=rabbitmq

check_root


cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$LOGS_FILE
VALIDATE $? "Copying RabbitMQ Repo File"

dnf list installed rabbitmq-server &>>$LOGS_FILE
if [ $? -eq 0 ]; then
    echo -e "RabbitMQ Server already installed ... $Y SKIPPING $N"
else
    dnf install rabbitmq-server -y &>>$LOGS_FILE
    VALIDATE $? "Installing RabbitMQ Server"
fi

systemctl enable rabbitmq-server &>>$LOGS_FILE
VALIDATE $? "Enabling RabbitMQ Server"

systemctl start rabbitmq-server &>>$LOGS_FILE
VALIDATE $? "Starting RabbitMQ Server"

rabbitmqctl list_users | grep -i "roboshop" &>>$LOGS_FILE
if [ $? -eq 0 ]; then
    echo -e "RabbitMQ Application User already exists ... $Y SKIPPING $N"
else
    rabbitmqctl add_user roboshop roboshop123 &>>$LOGS_FILE
    VALIDATE $? "Adding RabbitMQ Application User"

    rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOGS_FILE
    VALIDATE $? "Setting Permissions to Application User"
fi

print_total_time
