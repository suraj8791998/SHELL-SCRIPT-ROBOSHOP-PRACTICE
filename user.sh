#!/bin/bash

SCRIPT_NAME=$0
LOGS_DIR=/home/centos/
DATE=$(date +%F)
LOGS_FILE=$LOGS_DIR/$SCRIPT_NAME-$DATE.log

USERID=$(id -u)
if [ $? -ne 0 ];
then
  echo "ERROR:: PLEASE SWITCH TO ROOT USER"
  exit1
fi 

VALIDATE(){
    if [ $1 -ne 0 ];
    then 
      echo "$2...IS FAILURE"
    else
      echo "$2...IS SUCCESS"
    fi 
}

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOGS_FILE
VALIDATE $? "SETTING UP NODEJS"

yum install nodejs -y  &>> $LOGS_FILE
VALIDATE $? "INSTALLING NODEJS"


USER_NAME=$(id roboshop) &>> $LOGS_FILE
if [ $? -ne 0 ];
then 
    echo "USER DOES NOT EXISTS; LETS CREATE USER"
    useradd roboshop &>> $LOGS_FILE
else
    echo "USER IS ALREADY EXISTS"
fi 

DIRECTORY_PATH=$(cd /app) &>> $LOGS_FILE
if [ $? -ne 0 ];
then
    echo "DIRECTORY DOES NOT EXISTS"
    mkdir /app &>>$LOGS_FILE
else
    echo "DIRECTORY ALREADY EXISTS"
fi 

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip  &>> $LOGS_FILE
VALIDATE $? "DOWNLOADING THE APPLICATION"

cd /app  &>> $LOGS_FILE
VALIDATE $? "MOVING INTO APPLICATION DIRECTORY"

unzip /tmp/user.zip &>> $LOGS_FILE
VALIDATION $? "UNZIPPING THE APPLICATION"

npm install  &>> $LOGS_FILE
VALIDATE $? "INSTALLING DEPENDENCIES"

cp /home/centos/SHELL-SCRIPT-ROBOSHOP-PRACTICE/user.service /etc/systemd/system/user.service
VALIDATE $? "COPYING USER SERVICE"

systemctl daemon-reload &>> $LOGS_FILE
VALIDATION $? "DEAMON RELOADING"

systemctl enable user  &>> $LOGS_FILE
VALIDATE $? "ENABLING USER"

systemctl start user &>> $LOGS_FILE
VALIDATE $? "STARTING USER"

cp /home/centos/SHELL-SCRIPT-ROBOSHOP-PRACTICE/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATION $? "COPYING MONGO.REPO"

yum install mongodb-org-shell -y &>> $LOGS_FILE
VALIDATION $? "INSTALLING MONOGO ORG SHELL"

mongo --host mongodb.suraj.website </app/schema/user.js &>> $LOGS_FILE
VALIDATION $? "LOADING THE SCHEMA"