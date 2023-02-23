#!/bin/bash

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
}

function defaultFunction() {
    echo "defaultFunction"
}

dog=dogdog
cat=catcat
if [[ $cat =~ ^(dog|cat)?$ ]]
then
    echo "true"
else
    echo "false"
fi

case $1 in
    add) add;;
    *) defaultFunction;;
esac