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
      exit 1
    else
        echo "$2...IS SUCCESS"
    fi 
}

curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>> $LOGS_FILE
VALIDATION $? "SETTING UP NODEJS REPO"

yum install nodejs -y  &>> $LOGS_FILE
VALIDATION $? "INSTALLING NODEJS APPLICATION"


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

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip  &>> $LOGS_FILE
VALIDATION $? "DOWNLOADING THE APPLICATION CODE"

cd /app &>> $LOGS_FILE
VALIDATION $? "MOVING INTO THE APPLICATION"

unzip /tmp/cart.zip  &>> $LOGS_FILE
VALIDATION $? "UNZIPPING THE APPLICATION"

npm install &>> $LOGS_FILE
VALIDATION $? "INSTALLING THE DEPENDENCIES"

