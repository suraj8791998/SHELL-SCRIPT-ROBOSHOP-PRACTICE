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

VALIDATE(){
    if [ $1 -ne 0 ];
    then 
      echo "$2...IS FAILURE"
    else
      echo "$2...IS SUCCESS"
    fi 
}

yum install nginx -y  &>> $LOGS_FILE
VALIDATE $? "INSTALLING NGINX"

systemctl enable nginx &>> $LOGS_FILE
VALIDATE $? "ENABLING NGINX"

systemctl start nginx &>> $LOGS_FILE
VALIDATE $? "STARTING NGINX"

rm -rf /usr/share/nginx/html/* &>> $LOGS_FILE
VALIDATE $? "REMOVING BY DEFAULT HTML FILES"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>> $LOGS_FILE
VALIDATE $? "DOWNLOADING THE APPLICATION" 

cd /usr/share/nginx/html  &>> $LOGS_FILE
VALIDATE $? "GO TO HTML PATH"

unzip /tmp/web.zip &>> $LOGS_FILE
VALIDATE $? "UNZIPPING THE APPLICATION"

CP /home/centos/SHELL-SCRIPT-ROBOSHOP-PRACTICE/roboshop.conf   /etc/nginx/default.d/roboshop.conf  &>> $LOGS_FILE
VALIDATE $? "COPYING FILES"

systemctl restart nginx &>> $LOGS_FILE
VALIDATE $? "RESTARTING NGINX SERVER"

