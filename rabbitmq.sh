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

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> $LOGS_FILE
VALIDATE $? "CONFIGURING YUM REPO BY SCRIPT PROVIDER"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> $LOGS_FILE
VALIDATE $? "CONFIGURE YUM REPO BY RABBITMQ"

yum install rabbitmq-server -y  &>> $LOGS_FILE
VALIDATE $? "INSTALLING RABBITMQ SERVER"

systemctl enable rabbitmq-server  &>> $LOGS_FILE
VALIDATE $? "ENABLING RABBITMQ SERVER"
 
systemctl start rabbitmq-server  &>> $LOGS_FILE
VALIDATE $? "STARTING RABBITMQ SERVER"

rabbitmqctl add_user roboshop roboshop123 &>> $LOGS_FILE
VALIDATE $? "ADDING USER FOR APPLICATION"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOGS_FILE
VALIDATE $? "SETTING PERMISSIONS"