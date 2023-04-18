global _start

section .data 

    msg db "Hello, World!", 0xa
    msg_len equ $ - msg

section .text
_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, msg_len
    int 0x80

    mov eax, 1
    mov ebx, 0
    int 0x80
