#1/bin/bash

source ./common.sh
app_name=redis

check_root

systemd_setup

dnf module disable redis -y &>>$LOGS_FILE
VALIDATE $? "Disable redis default version"

dnf module enable redis:7 -y &>>$LOGS_FILE
VALIDATE $? "Enableing redis:7"

dnf install redis -y &>>$LOGS_FILE
VALIDATE $? "Installing redis"              #sed -i 's/127.0.0.1/0.0.0.0/g'

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e  '/protected-mode/ c protected-mode no' /etc/redis/redis.conf 
VALIDATE $? "updating changes allowinfg remote connections"

print_total_time