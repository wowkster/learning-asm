global _start

section .text

_start:
    ; Put the nth fibonacci number in eax
    push 8          ; n
    call fib

    push eax

    mov eax, 1
    pop ebx
    int 0x80

fib:
    push ebp
    mov ebp, esp

    ; Move the argument (n) into eax
    mov eax, [ebp + 8]

    ; If n == 0, return 0
    cmp eax, 0
    je return

    ; If n is <= 2, return 1
    cmp eax, 2
    jle early_return

    ; Call fib(n - 1)
    dec eax             ; n - 1 in eax
    push eax            ; stack: (n-1)
    call fib            ; eax: fib(n - 1)

    pop ebx             ; ebx: n - 1

    push eax            ; stack: fib(n-1)

    ; Call fib(n - 2)
    dec ebx
    push ebx
    call fib            ; eax: fib(n - 2)

    pop ecx             ; ecx: n - 2
    pop ebx             ; ebx: fib(n - 1)

    ; Add fib(n - 1) (ebx) to fib(n - 2) (eax)
    add eax, ebx

    jmp return

early_return:
    mov eax, 1

return:
    mov esp, ebp
    pop ebp
    ret
