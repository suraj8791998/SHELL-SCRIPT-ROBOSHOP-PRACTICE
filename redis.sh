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

yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $LOGFILE
VALIDATE $? "INSTALLING REDIS REPO FILE"

yum module enable redis:remi-6.2 -y &>> $LOGFILE
VALIDATE $? "ENABLING REDIS 6.2"

yum install redis -y  &>> $LOGFILE
VALIDATE $? "INSTALLING REDIS"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/redis.conf &>> $LOGFILE
VALIDATE $? "REPLACING THE PORT NUMBER"

systemctl enable redis &>> $LOGFILE
VALIDATE $? "ENABLING REDIS"

systemctl start redis &>> $LOGFILE
VALIDATE $? "STARTING REDIS SERVER"
