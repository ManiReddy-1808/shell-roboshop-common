#!/bin/bash


source ./common.sh
app_name=shipping

check_root
app_setup
java_setup
systemd_setup

dnf list installed mysql &>>$LOGS_FILE
if [ $? -eq 0 ]; then
    echo -e "MySQL client already installed ... $Y SKIPPING $N"
else
    dnf install mysql -y &>>$LOGS_FILE
    VALIDATE $? "Installing MySQL Client"
fi

mysql -h $MYSQL_HOST -uroot -p${mysql_root_password} -e 'use cities' &>>$LOGS_FILE
if [ $? -ne 0 ]; then
    mysql -h $MYSQL_HOST -uroot -p${mysql_root_password} < /app/db/schema.sql &>>$LOGS_FILE
    VALIDATE $? "Creating Shipping Database Schema and loading data"

    mysql -h $MYSQL_HOST -uroot -p${mysql_root_password} < /app/db/app-user.sql &>>$LOGS_FILE
    VALIDATE $? "Creating Shipping App User & loading data"

    mysql -h $MYSQL_HOST -uroot -p${mysql_root_password} < /app/db/master-data.sql &>>$LOGS_FILE
    VALIDATE $? "Creating Shipping Master Data & loading data"
else
    echo -e "Shipping Database schema is already created ...$Y SKIPPING $N"
fi

app_restart
print_total_time