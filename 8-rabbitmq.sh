#!/bin/bash

source ./common.sh
app_name=rabbitmq

check_root
systemd_setup




cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$LOGS_FILE
VALIDATE $? "Copied repos"

dnf install rabbitmq-server -y &>>$LOGS_FILE
VALIDATE $? "Installing rabbitmq Server"

systemctl enable rabbitmq-server &>>$LOGS_FILE
systemctl start rabbitmq-server
VALIDATE $? "Enabled and started rabbitmq Server"

if [ $? -ne 0 ]; then
    rabbitmqctl add_user roboshop roboshop123
    rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
    VALIDATE $? "created user and given permissions"
else
    echo -e "User already exist... $Y SKIPPING $N"
fi

app_restart
print_total_time