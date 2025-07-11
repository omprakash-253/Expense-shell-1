#!/bin/bash

userid=$(id -u)
time_stamp=$(date +%F-%H-%M-%S)
script_name=$(echo $0 | cut -d "." -f1)
logfile=/tmp/$script_name-$time_stamp.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE() {
    if [ $1 -ne 0 ]
    then 
        echo -e "$2 is.. $R Failed $N"
        exit 1
    else
        echo -e "$2 is.. $G SUCCESSFUL $N"
    fi
}

check_root() {
    if [ $userid -ne 0 ]
    then
        echo "Please run the script with root user"
        exit 1
    else
        echo " you are root user"
    fi
}
