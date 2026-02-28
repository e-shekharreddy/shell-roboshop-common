#!/bin/bash


USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop" # full path
LOGS_FILE="/var/log/shell-roboshop/$0.log" # or we can write it as $LOGS_FOLODER/$0.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"
SCRIPT_DIR=$PWD
START_TIME=$(date +%s)
MONGODB_HOST="mongodb.tsmvr.fun"
MYSQL_HOST="mysql.tsmvr.fun"

mkdir -p $LOGS_FOLDER

echo "$(date "+%Y-%m-%d %H:%M:%S") | Script started executing at: $(date)" | tee -a $LOGS_FILE

check_root(){
    if [ $USERID -ne 0 ]; then
        echo -e "$R Please run this script with root user access $N" | tee -a $LOGS_FILE
        exit 1
    fi
}

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $2... $R FAILURE $N" | tee -a $LOGS_FILE
        exit 1
    else
        echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $2... $G SUCCESS $N" | tee -a $LOGS_FILE
    fi
}

nodejs_setup(){
    dnf module disable nodejs -y &>>$LOGS_FILE
    VALIDATE $? "Disabling NodeJS Default version" # $? = privious command output and " <anything> " == $2 / # $? is $1 and " <anything> " considor as $2

    dnf module enable nodejs:20 -y &>>$LOGS_FILE
    VALIDATE $? "Enabling NodeJS:20" # $? == $1 and " <anything> " == $2 / # $? is $1 and " <anything> " considor as $2

    dnf install nodejs -y &>>$LOGS_FILE
    VALIDATE $? "Install NodeJS" # $? == $1 and " <anything> " == $2 / # $? is $1 and " <anything> " considor as $2
    
    npm install &>>$LOGS_FILE
    VALIDATE $? "Installing npm Dependencies"
}

java_setup(){

    dnf install maven -y &>>$LOGS_FILE
    VALIDATE $? "Installing maven"

    cd /app 
    mvn clean package &>>$LOGS_FILE
    VALIDATE $? "Installing and Building $app_name"


    mv target/$app_name-1.0.jar $app_name.jar &>>$LOGS_FILE
    VALIDATE $? "Moving and renamaing $app_name"

}


python_setup(){
    dnf install python3 gcc python3-devel -y &>>$LOGS_FILE
    VALIDATE $? "Installing Python"

    cd /app 
    pip3 install -r requirements.txt &>>$LOGS_FILE
    VALIDATE $? "Installing Dependencies"
}

app_setup(){
    #creating system user

    id roboshop &>>$LOGS_FILE
    if [ $? -ne 0 ]; then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOGS_FILE
        VALIDATE $? "Adding system user" # $? == $1 and " <anything> " == $2 / # $? is $1 and " <anything> " considor as $2
    else 
        echo -e "Roboshop user already exist ... $Y SKIPPING $N"
    fi

    mkdir -p /app 
    VALIDATE $? "making app directory" # $? == $1 and " <anything> " == $2 / # $? is $1 and " <anything> " considor as $2

    curl -L -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$LOGS_FILE
    VALIDATE $? "Downloading $app_name code" # $? == $1 and " <anything> " == $2 / # $? is $1 and " <anything> " considor as $2

    cd /app
    VALIDATE $? "Moving to app directory"

    rm -rf /app/* &>>$LOGS_FILE
    VALIDATE $? "Removing existing code"

    unzip /tmp/$app_name.zip &>>$LOGS_FILE
    VALIDATE $? "Unzipping $app_name code"

}

systemd_setup(){
    
     cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service &>>$LOGS_FILE
    VALIDATE $? "Created systtemctl service"

    systemctl daemon-reload &>>$LOGS_FILE
    VALIDATE $? "$app_name reloaded"

    systemctl enable $app_name &>>$LOGS_FILE
    VALIDATE $? "Enabling $app_name"

    systemctl start $app_name &>>$LOGS_FILE
    VALIDATE $? "Started $app_name"
}

app_restart(){
    systemctl restart $app_name &>>$LOGS_FILE
    VALIDATE $? "Restarted $app_name"
}

print_total_time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(( $END_TIME - $START_TIME ))
    echo -e "$(date "+%Y-%m-%d %H:%M:%S") | Script Excute in: $G $TOTAL_TIME seconds $N" | tee -a $LOGS_FILE
}


    
