#!/bin/bash

source ./common.sh

check_root

echo "Please enter DB password:"
read -s mysql_root_password

dnf module disable nodejs -y &>>$logfile
VALIDATE $? "disabling nodejs default module"

dnf module enable nodejs:20 -y &>>$logfile
VALIDATE $? "enablish nodejs:20 version"

dnf install nodejs -y &>>$logfile
VALIDATE $? "installing nodejs"

id expnese &>>$logfile
if [ $? -ne 0 ]
then
    useradd expense &>>$logfile
    VALIDATE $? "Creating expense user"
else
    echo -e "expense user already created $Y.. SKIPPING $N"
fi

mkdir -p /app &>>$logfile  ## this command will create /app directory if not exist, -p checks if direcoty exist and it not it creates it
VALIDATE $? "Creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$logfile
VALIDATE $? "Downloding application code to temp directory"

cd /app &>>$logfile
rm -rf /app/*
unzip /tmp/backend.zip &>>$logfile
VALIDATE $? "unzip backend.zip file located on /tmp to /app directory"

npm install &>>$logfile
VALIDATE $? "installation of nodejs dependencies"

cp /home/ec2-user/Expense-shell-1/backend.service /etc/systemd/system/backend.service &>>$logfile
VALIDATE $? "copied backend services"

systemctl daemon-reload &>>$logfile
VALIDATE $? "Daemon reload"

systemctl enable backend &>>$logfile
VALIDATE $? "Enabling backend"

systemctl start backend &>>$logfile
VALIDATE $? "Starting backend service"

dnf install mysql -y &>>$logfile
VALIDATE $? "installing of mysql client"

mysql -h db.omansh.fun -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$logfile
VALIDATE $? "Schema loading"


systemctl restart backend &>>$LOGFILE
VALIDATE $? "Restarting Backend"










    






