#!/bin/bash

SCRIPT_NAME=$0
LOGS_DIR=/home/centos/
DATE=$(date +%F)
LOGS_FILE=$LOGS_DIR/$SCRIPT_NAME-$DATE.log

USERID=$(id -u)
if [ $? -ne 0 ];
then
  echo "ERROR : PLEASE SWITCH TO ROOT USER"
  exit 1
fi 

VALIDATION(){
    if [ $1 -ne 0 ];
    then 
      echo "$2...IS FAILURE"
    else
        echo "$3...IS SUCCESS"
    fi 
}

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGS_FILE
VALIDATION $? "SETTING UP NODEJS REPO"

yum install nodejs -y  &>> $LOGS_FILE
VALIDATION $? "INSTALLING NODEJS APPLICATION"


USER_NAME=$(id roboshop)
if [ $? -ne 0 ];
then 
    echo "USER DOES NOT EXISTS; LETS CREATE USER"
    useradd roboshop &>> $LOGS_FILE
else
    echo "USER IS ALREADY EXISTS"
fi 

DIRECTORY_PATH=$(cd /app)
if [ $? -ne 0 ];
then
    echo "DIRECTORY DOES NOT EXISTS"
    mkdir /app &>>$LOGS_FILE
else
    echo "DIRECTORY ALREADY EXISTS"
fi 

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>>$LOGS_FILE
VALIDATION $? "DOWNLOADING THE APPLICATION"

cd /app  &>>$LOGS_FILE
VALIDATION $? "MOVE TO APP DIRECTORY" 

unzip /tmp/catalogue.zip &>>$LOGS_FILE
VALIDATION $? "UNZIPPING THE APPLICATION HERE"

npm install  &>>$LOGS_FILE
VALIDATION $? "INSTALLING THE DEPENDENCIES"

cp /home/centos/SHELL-SCRIPT-ROBOSHOP-PRACTICE/catalogue.service  /etc/systemd/system/catalogue.service  &>>$LOGS_FILE
VALIDATION $? "COPYING CATALOGUE.SERVICE"

systemctl daemon-reload &>>$LOGS_FILE
VALIDATION $? "DEAMON RELOADING" 

systemctl enable catalogue  &>>$LOGS_FILE
VALIDATION $? "ENABLING CATALOGUE"

systemctl start catalogue  &>>$LOGS_FILE
VALIDATION $? "STARTING CATALOGUE"

cp /home/centos/SHELL-SCRIPT-ROBOSHOP-PRACTICE/mongo.repo  /etc/yum.repos.d/mongo.repo  &>>$LOGS_FILE
VALIDATION $? "COPYING MONGO.REPO"

yum install mongodb-org-shell -y   &>>$LOGS_FILE
VALIDATION $? "INSTALLING MONGO CLIENT"

mongo --host mongodb.suraj.website </app/schema/catalogue.js  &>>$LOGS_FILE
VALIDATION $? "LOADING SCHEMA"

