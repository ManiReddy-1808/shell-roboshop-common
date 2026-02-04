#!/bin/bash

USER_ID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

check_root(){
    if [ $USER_ID -gt 0 ]; then
        echo -e " $R Please run this script with root user :) $N" | tee -a $LOGS_FILE
        exit 3;
    fi
}

START_TIME=$(date +%s)
mkdir -p $LOGS_FOLDER
echo "$(date "+%Y-%m-%d %H:%M:%S") | Script started executing at: $(date)" | tee -a $LOGS_FILE


# tee command is used to write the output to log file as well as to the console
VALIDATE(){  
    if [ $1 -eq 0 ]; then
        echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $2 ... $G SUCCESS $N" | tee -a $LOGS_FILE
    else 
        echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $2 ... $R FAILURE $N" | tee -a $LOGS_FILE
    fi
}


print_total_time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(($END_TIME - $START_TIME))
    echo -e "$(date "+%Y-%m-%d %H:%M:%S") | Script executed in: $G $TOTAL_TIME seconds $N" | tee -a $LOGS_FILE
}