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

cp /home/centos/SHELL-SCRIPT-ROBOSHOP-PRACTICE/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGS_FILE
VALIDATION $? "COPYING MONGO.REPO"

yum install mongodb-org -y &>> $LOGS_FILE
VALIDATION $? "INSTALLING MONGODB" 

systemctl enable mongod  &>> $LOGS_FILE
VALIDATION $? "ENABLING MONGODB"

systemctl start mongod &>> $LOGS_FILE
VALIDATION $? "STARTING MONGODB"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> $LOGFILE
VALIDATION $? "REPLACING ADDRESS IN MONGOD.CONF"

systemctl restart mongod &>> $LOGFILE
VALIDATION $? "RESTARTING MONGODB"