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


yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$LOGS_FILE
VALIDATION $? "REDIS RPM FILE" 

yum module enable redis:remi-6.2 -y &>>$LOGS_FILE
VALIDATION $? "ENABLING REDIS 6.2"

yum install redis -y  &>>$LOGS_FILE
VALIDATION $? "INSTALLING REDIS"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/redis.conf   /etc/redis/redis.conf &>> $LOGS_FILE
VALIDATION $? "REPLACING ADDRESS IN REDIS.CONF"

systemctl enable redis &>> $LOGS_FILE
VALIDATION $? "ENABLING REDIS"

systemctl start redis &>> $LOGS_FILE
VALIDATION $? "STARTING REDIS"