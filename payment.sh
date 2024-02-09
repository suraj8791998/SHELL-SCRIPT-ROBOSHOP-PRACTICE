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
VALIDATION(){
    if [ $1 -ne 0 ];
    then 
      echo "$2...IS FAILURE"
      exit 1
    else
        echo "$2...IS SUCCESS"
    fi 
}

yum install python36 gcc python3-devel -y  &>> $LOGS_FILE
VALIDATION $? "INSTALLING PYTHON 3.6"

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

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>> $LOGS_FILE
VALIDATION $? "DOWNLOADING THE APPLICATION"

cd /app  &>> $LOGS_FILE
VALIDATION $? "MOVING INTO APPLICATION"

unzip /tmp/payment.zip &>> $LOGS_FILE
VALIDATION $? "UNZIPPING THE APPLICATION"

pip3.6 install -r requirements.txt &>> $LOGS_FILE
VALIDATION $? "INSTALLING DEPENDENCIES"

cp /home/centos/SHELL-SCRIPT-ROBOSHOP-PRACTICE/payment.service /etc/systemd/system/payment.service
VALIDATION $? "COPYING PAYMENT.SERVICE"

systemctl daemon-reload &>> $LOGS_FILE
VALIDATION $? "DEAMON RELOADING" 

systemctl enable payment  &>> $LOGS_FILE
VALIDATION $? "ENABLING PAYMENT"

systemctl start payment &>> $LOGS_FILE
VALIDATION $? "STARTING PAYMENT"



