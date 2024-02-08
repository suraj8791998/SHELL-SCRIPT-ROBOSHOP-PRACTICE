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

yum module disable mysql -y &>> $LOGS_FILE
VALIDATE $? "DISABLING PRESENT MYSQL VERSION"

cp mysql.repo /etc/yum.repos.d/mysql.repo &>> $LOGS_FILE
VALIDATE $? "COPYING MYSQL REPO"

yum install mysql-community-server -y &>> $LOGS_FILE
VALIDATE $? "INSTALLING MYSQL COMMUNITY SERVER" &>> $LOGS_FILE

systemctl enable mysqld &>> $LOGS_FILE
VALIDATE $? "ENABLING MYSQLD"

systemctl start mysqld &>> $LOGS_FILE
VALIDATE $? "STARTING MYSQLD"

mysql_secure_installation --set-root-pass RoboShop@1 &>> $LOGS_FILE
VALIDATE $? "CHANGING DEFAULT ROOT PASSWORD"

