#!/bin/bash


USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop" # full path
LOGS_FILE="/var/log/shell-roboshop/$0.log" # or we can write it as $LOGS_FOLODER/$0.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"

START_TIME=$(date +%s)

mkdir -p $LOGS_FOLDER

echo "$(date "+%Y-%m-%d %H:%M:%S") | Script started executing at: $(date)" | tee -a $LOGS_FILE





check_root(){
if [ $USERID -ne 0 ]; then
    echo -e " $R Please run this script with root user access $N" | tee -a $LOGS_FILE
    exit 1
fi 
}



VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$(date "+%Y-%m-%d %H:%M:%S") $2... $R FAILURE $N " | tee -a $LOGS_FILE
        exit 1
    else
        echo -e "(date "+%Y-%m-%d %H:%$M:%S") $2... $G SUCCESS $N " | tee -a $LOGS_FILE
    fi
}

print_total_time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(( $END_TIME - $START_TIME ))
    echo -e "$(date "+%Y-%m-%d %H:%M:%S") | Script Excute in: $G $TOTAL_TIME seconds $N" | tee -a $LOGS_FILE
}


    
