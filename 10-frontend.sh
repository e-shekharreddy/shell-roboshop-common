#!/bin/bash

source ./common.sh
app_name=frontend

check_root

dnf module disable nginx -y &>>$LOGS_FILE
dnf module enable nginx:1.24 -y &>>$LOGS_FILE
dnf install nginx -y &>>$LOGS_FILE
VALIDATE $? "Installed Nginx"


systemctl enable nginx &>>$LOGS_FILE
systemctl start nginx &>>$LOGS_FILE
VALIDATE $? "Enabled and started Nginx"

rm -rf /usr/share/nginx/html/* &>>$LOGS_FILE
VALIDATE $? " Removing default Code"


curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$LOGS_FILE
VALIDATE $? "Downloaded frontend code"


cd /usr/share/nginx/html 
unzip /tmp/frontend.zip &>>$LOGS_FILE
VALIDATE $? "Unzinping the frontend code"

rm -rf /etc/nginx/nginx.conf/*
VALIDATE $? "Removed default Configuration file"

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf  &>>$LOGS_FILE
VALIDATE $? "Copying Nginx configuration file"

systemctl restart nginx &>>$LOGS_FILE
VALIDATE $? "Restarted nginx"


print_total_time
