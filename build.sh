#!/bin/bash

# Get the directory path passed as an argument

if [ -z "$1" ]; then
    echo "Please pass the directory path as an argument"
    exit 1
fi

# Check to see if the directory exists 

if [ ! -d "$1" ]; then
    echo "Directory does not exist"
    exit 1
fi

# Change to the directory

cd "$1"

# Assemble and link

mkdir -p target

nasm -f elf32 $1.asm -o ./target/$1.o
ld -m elf_i386 -s -o ./target/$1 ./target/$1.o

# Run if "run" is passed as an argument

if [ "$2" = "run" ]; then
    "./target/$1"

    # Print the exit code
    echo "Exit code: $?"
fi