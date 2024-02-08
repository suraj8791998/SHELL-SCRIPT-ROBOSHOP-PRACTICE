#!/bin/bash

DATE=$(date +%F)
LOGS_DIR=/home/centos/
SCRIPT_NAME=$0
LOGS_FILE=$LOGS_DIR/$SCRIPT_NAME-$DATE.log

USERID=$(id -u)
if [ $USERID -ne 0 ]
then
   echo "ERROR:: PLEASE SWITCH TO ROOT USER"
   exit 1
fi 

VALIDATE(){
if [ $1 -ne 0 ]
then
  echo "$2 ...IS FAILURE"
else
  echo "$2 ...IS SUCCESS"
fi 
}

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOGS_FILE
VALIDATE $? "SETUP NODEJS REPO"

yum install nodejs -y &>> $LOGS_FILE
VALIDATE $? "INSTALLING NODEJS"

useradd roboshop &>> $LOGS_FILE
VALIDATE $? "CREATING AN USER"

mkdir /app &>> $LOGS_FILE
VALIDATE $? "CREATING APP DIRECTORY"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGS_FILE
VALIDATE $? "DOWNLOADING THE APPLICATION"

cd /app &>> $LOGS_FILE
VALIDATE $? "MOVING INTO APPLICATION FOLDER" &>> $LOGS_FILE

unzip /tmp/catalogue.zip &>> $LOGS_FILE
VALIDATE $? "UNZIIPING THE APPLICATION"

npm install  &>> $LOGS_FILE
VALIDATE $? "DOWNLOADING THE DEPENDENCIES"

cp catalogue.sh /etc/systemd/system/catalogue.service &>> $LOGS_FILE
VALIDATE $? "COPYING CATALOGUE SERVICE"

systemctl daemon-reload &>> $LOGS_FILE
VALIDATE $? "DEAMON RELOADING"

systemctl start catalogue &>> $LOGS_FILE
VALIDATE $? "STARTING CATALOGUE"

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGS_FILE
VALIDATE $? "COPYING MONGO REPO"

yum install mongodb-org-shell -y &>> $LOGS_FILE
VALIDATE $? "INSTALLING MONGO REPO"

mongo --host 172.31.31.225 < /app/schema/catalogue.js &>> $LOGS_FILE
VALIDATE $? "LOADING THE SHCEMA"



