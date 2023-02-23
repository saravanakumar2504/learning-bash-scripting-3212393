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
    echo "defaultFunction"
}

function find() {
    read -p "Enter username to search: " username
    selectedUser=$(grep -wn "^$username," $filePath)
    
    [[ -z $selectedUser ]] &&  echo "User not found" || echo $selectedUser
}

dog=dogdog  # ^(dog|cat)+$
cat=cat # ^(dog|cat)?$
if [[ $cat =~ ^(dog|cat)?$ ]]
then
    echo "true"
else
    echo "false"
fi


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
    find) find $2;;
    *) defaultFunction;;
esac