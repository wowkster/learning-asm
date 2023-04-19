global main

extern strcmp
extern snprintf
extern memset
extern strncat

section .data
    fizz db "Fizz", 0x00
    fizz_len equ  $ - fizz

    buzz db "Buzz", 0x00
    buzz_len equ  $ - buzz

    empty_string db 0x00
    newline db 0x0a, 0x00
    format_str db "%i", 0x00

section .bss
    buffer: resb 10  ; Holds our text
    num: resb 4      ; Used for loop

section .text

main:
    push ebp
    mov ebp, esp

    mov dword [num], 1  ; start counting from 1

fb_loop:
    ; Call fizz_buzz with the current number
    push dword [num]
    call fizz_buzz
    add esp, 4

    ; Print result
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, 10
    int 0x80

    ; Increment the number
    mov eax, [num]
    inc eax
    mov [num], eax

    ; Keep looping until we hit 100
    cmp eax, 100
    jl fb_loop

    ; Exit
    mov eax, 0
    mov esp, ebp
    pop ebp
    ret


fizz_buzz:
    push ebp
    mov ebp, esp

    ; Memset the buffer to 0
    push 10                 ; num
    push 0                  ; value
    push buffer             ; ptr
    call memset

test_fizz:
    ; jump to buzz if (n % 3 != 0)
    mov eax, [ebp + 8]  ; n
    mov ecx, 3
    cdq
    idiv ecx
    cmp edx, 0
    jne test_buzz

fizz_strategy:
    ; Concat "Fizz" to the buffer 
    push fizz_len            ; num 
    push fizz                ; source
    push buffer              ; destination
    call strncat

test_buzz:
    ; jump to check_string if (n % 5 != 0)
    mov eax, [ebp + 8]       ; n
    mov ecx, 5
    cdq
    idiv ecx
    cmp edx, 0
    jne check_string

buzz_strategy:
    ; Concat "Buzz" to the buffer
    push buzz_len           ; num
    push buzz               ; source
    push buffer             ; destination
    call strncat

check_string:
    ; If string is not empty, return
    push empty_string       ; str2
    push buffer             ; str1
    call strcmp
    cmp eax, 0
    jne append_newline

number_strategy:
    ; Format the number into the buffer
    push dword [ebp + 8]    ; arg
    push format_str         ; format
    push 10                 ; n 
    push buffer             ; s
    call snprintf

append_newline:
    ; Concat a newline character to the buffer
    push 1                  ; num
    push newline            ; source
    push buffer             ; destination
    call strncat

return:
    mov esp, ebp
    pop ebp
    ret
