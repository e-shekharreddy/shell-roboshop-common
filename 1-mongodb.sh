#!/bin/bash

source ./common.sh

check_root

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copying Mongo Repo"  # $? = privious command output and " <anything> " == $2 / # $? is $1 and " <anything> " considor as $2

dnf install mongodb-org -y &>>$LOGS_FILE
VALIDATE $? "Instaling MongoDB server" # $? is $1 and " <anything> " considor as $2

systemctl enable mongod &>>$LOGS_FILE
VALIDATE $? "Enable MongoDB" # $? == $1 and " <anything> " == $2

systemctl start mongod 
VALIDATE $? "start MongoDB"  # $? == $1 and " <anything> " == $2 / # $? is $1 and " <anything> " considor as $2

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Allowing remote connections"

systemctl restart mongod
VALIDATE $? "Restarted MongoDB" # $? == $1 and " <anything> " == $2 / # $? is $1 and " <anything> " considor as $2

print_total_time