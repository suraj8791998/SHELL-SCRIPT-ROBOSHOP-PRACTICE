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

cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGS_FILE
VALIDATE $? "COPYING MONGO REPO"

yum install mongodb-org -y &>>$LOGS_FILE
VALIDATE $? "INSTALLING MONGODB"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$LOGS_FILE
VALIDATE $? "REPLACING THE PORT  NUMBER"

systemctl enable mongod &>>$LOGS_FILE
VALIDATE $? "ENABLING MONGODB"

systemctl restart mongod &>>$LOGS_FILE
VALIDATE $? "RESTARTING MONGODB"
