#!/bin/bash

#THIS SCRIPT USED FOR 1) ASSEMBLE CODE 
#                     2) LINK 
#                     3) RUN THE BINARY
#                     4) PRINT THE OUTPUT
#SCRIPT WORKS WITH X86_ASSEMBLY AT&T SYNTAX

args=("$@")
files=()
options=("asm" "link" "asm-link" "all")
option=""

function parse() {
    echo "assembling..."
        # as --32 -g -I $(pwd) $path_file.s -o out/$file_name.o
    for i in "${args[@]}"; do
    if [[ ! ${options[*]} =~ "$i" ]]; then
        echo $i
        files+=($i)
    fi
    done
    echo $files
    echo "done"
    exit
}

function assemble() {
    echo "assembling..."
        # as --32 -g -I $(pwd) $path_file.s -o out/$file_name.o
    for arg in "$args"
    do
        echo "$arg"
    done
    echo "done"
    exit
}

function verify() {
    if [[ ! ${options[*]} =~ "$option" ]]; then
        echo "Please enter valid option: asm | link | asm-link | all"
        exit
    fi

    file_arg=$1
    path_file=""
    file_name=""

    if [ -n "$file_arg" ]; then
        path_file=${file_arg::-2}           # remove extension .s if exits
        file_name=$(basename ${path_file})  # get file name without path
    else
        echo "Please enter the assembly file as an argument"
        exit 1
    fi

    if [ ! -d out ]
    then
        mkdir out
    fi
}

parse

if [[ $option == "asm" ]]; then
    assemble

elif [[ $option == "link" ]]; then
    echo "linking..."
    ld -melf_i386 out/$file_name.o -o out/$file_name
    echo "done"

elif [[ $option == "asm-link" ]]; then
    echo "assembling-linking..."
    as --32 -g -I $(pwd) $path_file.s -o out/$file_name.o && ld -melf_i386 out/$file_name.o -o out/$file_name 
    echo "done"

elif [[ $option == "all" ]]; then
    as --32 -g -I $(pwd) $path_file.s -o out/$file_name.o && ld -melf_i386 out/$file_name.o -o out/$file_name && ./out/$file_name "${*:2}"; echo $?
fi


# END
