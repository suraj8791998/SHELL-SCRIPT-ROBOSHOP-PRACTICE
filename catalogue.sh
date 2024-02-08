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

yum install nodejs -y  &>>$LOGS_FILE
VALIDATION $? "INSTALLING NODEJS APPLICATION"


USER_NAME=$(id roboshop)
if [ $? -ne 0 ];
then 
    echo "USER DOES NOT EXISTS; LETS CREATE USER"
    useradd roboshop
else
    echo "USER IS ALREADY EXISTS"
fi 

DIRECTORY_PATH=$(cd /app)
if [ $? -ne 0 ];
then
    echo "DIRECTORY DOES NOT EXISTS"
    mkdir /app
else
    echo "DIRECTORY ALREADY EXISTS"
fi 

