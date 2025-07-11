#!/bin/bash

source ./common.sh

check_root 

dnf install nginx -y &>>$logfile
VALIDATE $? "Installation of nginx"

systemctl enable nginx &>>$logfile
VALIDATE $? "Enabling nginx service"

systemctl start nginx &>>$logfile
VALIDATE $? "Starting nginx service"

rm -rf /usr/share/nginx/html/* &>>$logfile
VALIDATE $? "removing default nginx files"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$logfile
VALIDATE $? "extdownload frontend code to temp directory"

cd /usr/share/nginx/html &>>$logfile
unzip /tmp/frontend.zip &>>$logfile
VALIDATE $? "extracting frontend code"

cp /home/ec2-user/Expense-shell-1/expense.conf /etc/nginx/default.d/expense.conf &>>$logfile
VALIDATE $? "copied frontend.conf"

systemctl restart nginx &>>$logfile
VALIDATE $? "Restarting nginx service"

