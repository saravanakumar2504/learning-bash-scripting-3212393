#!/bin/bash

alertPercent=30

# Program to calculate free disk space alert
if [[ $# -gt 0 ]] && [[ $1 =~ ^-?[0-9]+([0-9]+)?$ ]]
then
    alertPercent=$1
fi

echo "Current threshold value: $alertPercent"

df -H | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5,$1 }' | while read data;
do
    used=$(echo $data | awk '{print $1}'| sed s/%//g)
    process=$(echo $data | awk '{print $2}')
    if [ $used -ge $alertPercent ]
    then
        echo "WARNING: The partition \"$process\" has used $used% of total available space - Date: $(date)"
    fi
done
