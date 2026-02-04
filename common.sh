#!/bin/bash

USER_ID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
MONGODB_HOST=dawsmani.site

SCRIPT_DIR=$PWD

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

START_TIME=$(date +%s)
mkdir -p $LOGS_FOLDER
echo "$(date "+%Y-%m-%d %H:%M:%S") | Script started executing at: $(date)" | tee -a $LOGS_FILE

check_root(){
    if [ $USER_ID -gt 0 ]; then
        echo -e " $R Please run this script with root user :) $N" | tee -a $LOGS_FILE
        exit 3;
    fi
}

# tee command is used to write the output to log file as well as to the console
VALIDATE(){  
    if [ $1 -eq 0 ]; then
        echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $2 ... $G SUCCESS $N" | tee -a $LOGS_FILE
    else 
        echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $2 ... $R FAILURE $N" | tee -a $LOGS_FILE
    fi
}

nodejs_setup(){
    dnf list installed nodejs &>>$LOGS_FILE
    if [ $? -eq 0 ]; then
        echo -e "NodeJS already installed ... $Y SKIPPING $N"
    else
        dnf module disable nodejs -y &>>$LOGS_FILE
        VALIDATE $? "Disabling NodeJS Module"

        dnf module enable nodejs:20 -y &>>$LOGS_FILE
        VALIDATE $? "Enabling NodeJS 20 Module"

        dnf install nodejs -y &>>$LOGS_FILE
        VALIDATE $? "Installing NodeJS"

        npm install &>>$LOGS_FILE
        VALIDATE $? "Installing NodeJS Dependencies"
    fi
}

app_setup(){
    id roboshop &>>$LOGS_FILE
    if [ $? -ne 0 ]; then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOGS_FILE
        VALIDATE $? "Roboshop User Created"
    else
        echo -e "roboshop user already exists ...$Y SKIPPING $N"
    fi

    mkdir -p /app 

    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$LOGS_FILE
    VALIDATE $? "Downloading $app_name App"

    cd /app 
    VALIDATE $? "Changing Directory to /app"

    rm -rf /app/* &>>$LOGS_FILE
    VALIDATE $? "Removing Old App Content"

    unzip /tmp/$app_name.zip &>>$LOGS_FILE
    VALIDATE $? "Extracting $app_name App Code"
}

systemd_setup(){
    #Currently we are in app directory, so moving to script dir
    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service
    VALIDATE $? "Copying $app_name SystemD Service File"

    systemctl daemon-reload &>>$LOGS_FILE
    VALIDATE $? "Reloading SystemD"

    systemctl enable $app_name &>>$LOGS_FILE
    VALIDATE $? "Enabling $app_name Service"

    systemctl start $app_name &>>$LOGS_FILE
    VALIDATE $? "Starting $app_name Service"
}

app_restart(){
    systemctl restart $app_name &>>$LOGS_FILE
    VALIDATE $? "Restarting $app_name Service"
}

print_total_time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(($END_TIME - $START_TIME))
    echo -e "$(date "+%Y-%m-%d %H:%M:%S") | Script executed in: $G $TOTAL_TIME seconds $N" | tee -a $LOGS_FILE
}