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

USER_NAME=$(id roboshop) &>> $LOGS_FILE
if [ $USER_NAME -ne 0 ]
then  
  echo "USER IS NOT CREATED YET, LETS CREATE USER"
   useradd roboshop &>> $LOGS_FILE
else
  echo "USER IS ALREADY EXISTS"
fi 

DIRECTORY=$(ls /app) &>> $LOGS_FILE
if [ $DIRECTORY -ne 0 ]
then
  echo "APP DIRECTORY IS NOT AVAILBLE, LETS CREATE IT"
  mkdir /app &>> $LOGS_FILE
else
  echo "APP DIRECTORY IS ALREADY EXISTS"
fi 

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip
VALIDATE $? "DOWNLOADING THE APPLICATION"

cd /app 
VALIDATE $? "MOVING INTO APPLICATION FOLDER"

unzip /tmp/catalogue.zip
VALIDATE $? "UNZIIPING THE APPLICATION"

npm install 
VALIDATE $? "DOWNLOADING THE DEPENDENCIES"

cp catalogue.sh /etc/systemd/system/catalogue.service
VALIDATE $? "COPYING CATALOGUE SERVICE"

systemctl daemon-reload
VALIDATE $? "DEAMON RELOADING"

systemctl start catalogue
VALIDATE $? "STARTING CATALOGUE"

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "COPYING MONGO REPO"

yum install mongodb-org-shell -y
VALIDATE $? "INSTALLING MONGO REPO"

mongo --host 172.31.31.225 < /app/schema/catalogue.js
VALIDATE $? "LOADING THE SHCEMA"



