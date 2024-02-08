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

yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $LOGS_FILE
VALIDATE $? "INSTALLING REDIS REPO FILE"

yum module enable redis:remi-6.2 -y &>> $LOGS_FILE
VALIDATE $? "ENABLING REDIS 6.2"

yum install redis -y  &>> $LOGS_FILE
VALIDATE $? "INSTALLING REDIS"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/redis.conf &>> $LOGS_FILE
VALIDATE $? "REPLACING THE PORT NUMBER"

systemctl enable redis &>> $LOGS_FILE
VALIDATE $? "ENABLING REDIS"

systemctl start redis &>> $LOGS_FILE
VALIDATE $? "STARTING REDIS SERVER"


#FIND MONGODB LOGS PATH IS /var/log/redis/redis.log