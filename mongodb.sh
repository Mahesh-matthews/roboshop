#!/bin/bash

# Logs and redirecting output to log file
USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"



if [ $USERID -ne 0 ]; then
    echo -e "$R You are not running as root.$N" | tee -a $LOGS_FILE
    exit 1
 fi  

 mkdir -p $LOGS_FOLDER

   validate(){

    if [ $1 -ne 0 ]; then
        echo -e "$R $2 ... Failure$N" | tee -a $LOGS_FILE
        exit 1
    else
        echo -e "$G $2 ... Success$N" | tee -a $LOGS_FILE
    fi

   }

cp mongo.repo /etc/yum.repos.d/mongodb.repo &>>$LOGS_FILE
validate $? "Copying MongoDB repo"

dnf install mongodb-org -y >>"$LOGS_FILE" 2>&1
validate $? "Installing MongoDB Server"

systemctl enable mongod >>"$LOGS_FILE" 2>&1
validate $? "Enabling MongoDB Service"

systemctl start mongod >>"$LOGS_FILE" 2>&1
validate $? "Starting MongoDB Service"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf >>"$LOGS_FILE" 2>&1
validate $? "Allowing remote connections to MongoDB"

systemctl restart mongod >>"$LOGS_FILE" 2>&1
validate $? "Restarting MongoDB Service"


