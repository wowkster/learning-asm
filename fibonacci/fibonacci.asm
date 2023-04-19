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

    ; Allocate Stack Variables
    sub esp, 4               ; Allocate space for n

    ; Early return
    mov eax, [ebp + 8]
    
    cmp eax, 0 
    je return                ; If n == 0, return 0
    
    cmp eax, 2
    jle early_return         ; If n is <= 2, return 1

    ; Move n into the local stack
    dec eax                  ; Compute n - 1
    mov dword [ebp - 4], eax ; Store n - 1 on the stack

    ; Call fib(n - 1)
    push eax
    call fib
    add esp, 4            

    push eax

    ; Call fib(n - 2)
    mov eax, [ebp - 4]       ; Bring n - 1 back
    dec eax                  ; Compute n - 2

    push eax
    call fib           
    add esp, 4

    ; Bring fib(n - 1) back from the stack
    pop ebx             

    ; Add fib(n - 1) (ebx) to fib(n - 2) (eax)
    add eax, ebx

    jmp return

early_return:
    mov eax, 1

return:
    mov esp, ebp
    pop ebp
    ret
