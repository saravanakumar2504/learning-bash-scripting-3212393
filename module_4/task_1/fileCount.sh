#!/bin/bash

defaultPath='**/*'
declare -i fileCount=0

# Program to calculate file count in diretory/sub-directory
getFileCount() {
    for file in $@
    do
        if [[ -f "$file" ]]; then
            echo "File are in $file"
            ((fileCount++))
        else
            getFileCount $file/*
        fi
    done
}

if [[ -d "$1" ]]; then
    getFileCount $1
else
    getFileCount $defaultPath
fi
echo "File count = $fileCount"