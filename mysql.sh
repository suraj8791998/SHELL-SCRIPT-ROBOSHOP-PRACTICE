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

yum module disable mysql -y &>> $LOGS_FILE
VALIDATION $? "DISABLING DEFAULT MYSQL"

cp /home/centos/SHELL-SCRIPT-ROBOSHOP-PRACTICE  /etc/yum.repos.d/mysql.repo
VALIDATION $? "COPYING MYSQL.REPO"

yum install mysql-community-server -y &>> $LOGS_FILE
VALIDATION $? "INSTALLING MYSQL COMMUNTIY SERVER"

systemctl enable mysqld &>> $LOGS_FILE
VALIDATION $? "ENABLING MYSQLD"

systemctl start mysqld &>> $LOGS_FILE
VALIDATION $? "STARTING MYSQLD SERVER"

mysql_secure_installation --set-root-pass RoboShop@1 &>> $LOGS_FILE
VALIDATION $? "CHANGING DEFAULT ROOT PASSWORD"

