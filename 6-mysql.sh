#!/bin/bash

source ./common.sh
app_name=mysql

check_root

dnf install mysql-server -y &>>$LOGS_FILE
VALIDATE $? "Installed MySQL server"

systemctl enable mysqld &>>$LOGS_FILE
systemctl start mysqld 
VALIDATE $? "Enable and started MySQL"

mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "root password set"


print_total_time