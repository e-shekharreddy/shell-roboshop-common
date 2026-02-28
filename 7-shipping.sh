#!/bin/bash

source ./common.sh
app_name=shipping
MYSQL_HOST="mysql.tsmvr.fun"

check_root
app_setup
java_setup
systemd_setup




dnf install mysql -y &>>$LOGS_FILE
VALIDATE $? "Installed MySQL"

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 -e 'USE cities' 

if [ $? -ne 0 ]; then 

    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql &>>$LOGS_FILE
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql &>>$LOGS_FILE
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$LOGS_FILE
    VALIDATE $? "Loaded data into MySQL"
else
    echo -e "Data already exist... $Y SKIPPING $N"
fi

app_restart
print_total_time
