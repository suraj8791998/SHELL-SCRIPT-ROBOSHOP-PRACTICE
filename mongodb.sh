#!/bin/bash

sh common.sh

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "COPYING MONGO REPO"

yum install mongodb-org -y
VALIDATE $? "INSTALLING MONGODB"

sed -i 's?127.0.0.1/0.0.0.0/g>' /etc/mongod.conf
VALIDATE $? "REPLACING THE PORT  NUMBER"

systemctl enable mongod
VALIDATE $? "ENABLING MONGODB"

systemctl restart mongod
VALIDATE $? "RESTARTING MONGODB"
