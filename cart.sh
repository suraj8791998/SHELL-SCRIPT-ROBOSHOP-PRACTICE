#!/bin/bash

DATE=$(date +%F)
LOGSDIR=/home/centos
# /home/centos/shellscript-logs/script-name-date.log
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$0-$DATE.log
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

if [ $USERID -ne 0 ];
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ];
    then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOGFILE
VALIDATE $? "SETTING UP NODEJS"

yum install nodejs -y  &>> $LOGFILE
VALIDATE $? "INSTALLING NODEJS"

useradd roboshop &>> $LOGFILE
VALIDATE $? "ADDING USER"

mkdir /app 
VALIDATE $? "CREATING APP DIRECTORY"

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip
VALIDATE $? "DOWNLOADING THE APPLICATION CODE"

cd /app 
VALIDATE "MOVING INTO APP DIRECTORY"

unzip /tmp/cart.zip
VALIDATE $? "UNZIPPING THE APPLICATION"

npm install 
VALIDATE $? "INSTALLING THE DEPENDENCIES"

systemctl daemon-reload
VALIDATE $? "DEAMON RELOADING"

systemctl enable cart 
VALIDATE $? "ENABLING CART"

systemctl start cart
VALIDATE $? "STARTING CART SERVICE"



