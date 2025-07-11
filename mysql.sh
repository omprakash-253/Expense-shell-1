#!/bin/bash

source ./common.sh

check_root

echo "Please enter DB password:"
read -s mysql_root_password

dnf install mysql-server -y &>>$logfile
VALIDATE $? " Installation of mysql server"

systemctl enable mysqld &>>$logfile
VALIDATE $? "enabling of mysql server"

systemctl start mysqld &>>$logfile
VALIDATE $? "starting of mysql server"

#mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$logfile
# VALIDATE $? "Setting up root password"

#Below code will be useful for idempotent nature (replace 43 & 44 line)
mysql -h db.omansh.fun -uroot -p${mysql_root_password} -e 'show databases;' &>>$logfile
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$logfile
    VALIDATE $? "My sql root password setup"
else
    echo -e "Mysql root password is already setup.. $Y SKIPPING $N"
fi
    






