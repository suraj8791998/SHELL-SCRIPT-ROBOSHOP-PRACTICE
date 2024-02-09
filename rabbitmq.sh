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


curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> $LOGS_FILE
VALIDATION $? "CONFIGURING YUM REPO"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash  &>> $LOGS_FILE
VALIDATION $? "CONFIGURING YUM REPO FOR RABBITMQ"

yum install rabbitmq-server -y  &>> $LOGS_FILE
VALIDATION $? "INSTALLING RABBITMQ SERVER"

systemctl enable rabbitmq-server  &>> $LOGS_FILE
VALIDATION $? "ENABLING RABBITMQ SERVER"

systemctl start rabbitmq-server  &>> $LOGS_FILE
VALIDATION $? "STARTING RABBITMQ SERVER"

rabbitmqctl add_user roboshop roboshop123  &>> $LOGS_FILE
VALIDATION $? "CREATING USER FOR APPLICATION"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>> $LOGS_FILE
VALIDATION $? "SETTING PERMISSIONS FOR THE USER"

