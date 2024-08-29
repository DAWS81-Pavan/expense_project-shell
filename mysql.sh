#!/bin/bash
LOGS_FOLDER="/var/log/shell-script"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"
mkdir -p $LOGS_FOLDER

userid=$(id -u)
R="\e[31m" #RED
G="\e[32m" #GREEN
N="\e[0m"  #NARMAL
Y="\e[33m" #YELLOW

CHECK_ROOT(){

    if [ $userid -ne 0 ]
    then
        echo "Please run this script with root priveleges"| tee -a $LOG_FILE
        exit 1
    fi

}

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 is...$R FAILED $N" | tee -a $LOG_FILE
        exit 1
    else
        echo -e "$2 is...$G SUCCESS $N" | tee -a $LOG_FILE
    fi
}

echo "Script started executing at: $(date)" | tee -a $LOG_FILE

CHECK_ROOT


dnf install mysql-server -y &>>$LOG_FILE
VALIDATE $? "installing mysql-server"| tee -a $LOG_FILE

systemctl enable mysqld &>>$LOG_FILE
VALIDATE $? "enabling mysql-service"| tee -a $LOG_FILE

systemctl start mysqld &>>$LOG_FILE
VALIDATE $? "starting mysql-service"| tee -a $LOG_FILE

mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOG_FILE
VALIDATE $? "setting up mysql root password"| tee -a $LOG_FILE

