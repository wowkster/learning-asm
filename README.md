# Learning Assembly

This repository contains a number of coding exercises I did to practice programming in x86 assembly

## Required Tools

To assemble and run the code in this repository, you will need to use the linux `nasm` assembler (WSL 2 is recommended on windows)

### NASM

For assembling our code into an object file

```console
$ sudo apt install nasm
```

### BinUtils

For static standalone linking

```console
$ sudo apt install binutils
```

### GCC

For linking some of our programs with libc

```console
$ sudo apt install gcc gcc-multilib libc6:i386
```

