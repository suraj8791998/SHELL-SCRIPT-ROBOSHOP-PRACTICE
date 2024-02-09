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

yum install maven -y &>> $LOGS_FILE
VALIDATION $? "INSTALLING MAVEN"


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

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip  &>> $LOGS_FILE
VALIDATION $? "DOWNLOADING THE APPLICATION"

cd /app &>> $LOGS_FILE
VALIDATION $? "MOVING INTO APPLICATION DIRECTORY"

unzip /tmp/shipping.zip   &>> $LOGS_FILE
VALIDATION $? "UNZIPPING THE APPLICATION"

mvn clean package &>> $LOGS_FILE
VALIDATION $? "DOWNLOADING THE DEPENDENCIES"

mv target/shipping-1.0.jar shipping.jar  &>> $LOGS_FILE
VALIDATION $? "RENAMING THE JAR APPLICATION"

cp /home/centos/SHELL-SCRIPT-ROBOSHOP-PRACTICE/shipping.service  /etc/systemd/system/shipping.service
VALIDATION $? "COPYING SHIPPING.SERVICE"

systemctl daemon-reload &>> $LOGS_FILE
VALIDATION $? "DEAMON RELOADING"

systemctl enable shipping  &>> $LOGS_FILE
VALIDATION $? "ENABLE SHIPPING"

systemctl start shipping &>> $LOGS_FILE
VALIDATION $? "START SHIPPING"

yum install mysql -y   &>> $LOGS_FILE
VALIDATION $? "INSTALLING MYSQL CLIENT"

mysql -h mysql.suraj.website -uroot -pRoboShop@1 < /app/schema/shipping.sql &>> $LOGS_FILE
VALIDATION $? "LOADING THE SHCEMA"

systemctl restart shipping &>> $LOGS_FILE
VALIDATION $? "RESTART SHIPPING"



