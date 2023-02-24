#!/bin/bash

typeset fileName=users.db
typeset fileDir=./data
typeset filePath=$fileDir/$fileName

function add() {
    read -p "Enter username:" username
    while ! [[ "${username}" =~ ^[A-Za-z]+$ ]]
    do
        read -p "Enter username with alphabets " username
    done
    
    read -p "Enter role:" role
    
    while ! [[ "${role}" =~ ^[A-Za-z]+$ ]]
    do
        read -p "Enter role with alphabets " role
    done
    
    echo $username, $role >> $filePath
}

function backup() {
    backupFileName=$(date +'%Y-%m-%d-%H-%M-%S')-users.db.backup
    cp $filePath $fileDir/$backupFileName
    echo "Backup is created."
}

function restore {
    latestBackupFile=$(ls $fileDir/*-$fileName.backup | tail -n 1)
    
    if [[ ! -f $latestBackupFile ]]
    then
        echo "No backup file found."
        exit 1
    fi
    
    cat $latestBackupFile > $filePath
    
    echo "Backup is restored."
}

function defaultFunction() {
    echo "Manages users in db. It accepts a single parameter with a command name."
    echo
    echo "Syntax: db.sh [command]"
    echo
    echo "List of available commands:"
    echo
    echo "add       Adds a new line to the users.db. Script must prompt user to type a
                    username of new entity. After entering username, user must be prompted to
    type a role."
    echo "backup    Creates a new file, named" $filePath".backup which is a copy of
    current" $fileName
    echo "find      Prompts user to type a username, then prints username and role if such
                    exists in users.db. If there is no user with selected username, script must print:
                    “User not found”. If there is more than one user with such username, print all
    found entries."
    echo "list      Prints contents of users.db in format: N. username, role
                    where N – a line number of an actual record
                    Accepts an additional optional parameter inverse which allows to get
    result in an opposite order – from bottom to top"
}

function find() {
    read -p "Enter username to search: " username
    selectedUser=$(grep -wn "^$username," $filePath)
    
    [[ -z $selectedUser ]] &&  echo "User not found" || echo $selectedUser
}

function list {
    if [[ $1 == "--inverse" ]]  || [[ $1 == "inverse" ]]
    then
        cat -n $filePath | tac
    else
        cat -n $filePath
    fi
}


if [[ ! -f $filePath ]]
then
    read -p "user.db is not available. Can you create(Y/N)" userDBCreateFlag
    if [[ "$userDBCreateFlag" =~ [yY] ]]; then
        echo "Creating Users.db"
        mkdir -p $fileDir && touch $filePath
    else
        echo "Exciting the APP"
        exit;
    fi
fi

case $1 in
    add) add;;
    backup) backup;;
    restore) restore;;
    find) find;;
    list) list $2;;
    *) defaultFunction;;
esac