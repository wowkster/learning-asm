global main

extern printf

section .data
    is_prime_format db "%d is prime", 0x0a, 0x00

section .text
; ===========================================
; Main Function
; ===========================================
main:
    push ebp
    mov ebp, esp

    sub esp, 4  ; Allocate loop counter

    mov dword [ebp - 4], 0   ; initialize loop counter to 0

main_loop:
    ; Check the loop counter is less than 100
    cmp dword [ebp - 4], 100
    je main_loop_end

    ; Call is_prime with the current loop counter
    push dword [ebp - 4]
    call is_prime

    ; If the numebr is prime, print it
    cmp eax, 1
    jne main_loop_again

    push dword [ebp - 4]
    push is_prime_format
    call printf
    add esp, 8
    
main_loop_again:
    ; Increment loop counter
    inc dword [ebp - 4]
    jmp main_loop

main_loop_end:
    mov eax, 0               ; return 0 exit code

    mov esp, ebp
    pop ebp
    ret

; ===========================================
; Function to determine if a number is prime    
; ===========================================
;
; Based on the following C code:
;
; ```
; #include <math.h>
; #include <stdbool.h>
; 
; bool is_prime(int num) {
;     if (num <= 1) {
;         return false;
;     }
;
;     for (int i = 2; i <= sqrt(num); i++) {
;         if (num % i == 0) {
;             return false;
;         }
;     }
;
;     return true;
; }
; ```
is_prime:
    push ebp
    mov ebp, esp

    ; Check trivial solution
    cmp dword [ebp + 8], 1   ; check if num is <= 1
    jle is_composite_result  ; if it is, then the number cannot be prime

    ; Allocate stack variables
    sub esp, 4               ; Allocate space for sqrt(num) on the stack

    ; Compute the value of sqrt(num) into eax
    mov eax, [ebp + 8]       ; store argument (num) in eax
    cvtsi2sd  xmm0, eax      ; convert num to double
    sqrtsd    xmm0, xmm0     ; calculate sqrt
    cvttsd2si  eax, xmm0     ; convert double back to int
    mov [ebp - 4], eax       ; store the value of sqrt(num) into stack variable

    ; Initialize loop counter to 2
    mov ecx, 2 

start_loop:
    ; Check loop condition
    cmp ecx, [ebp - 4] 
    jg is_prime_result       ; Break if i > sqrt(num)

    ; Check if is factor
    mov eax, [ebp + 8]       ; move num into eax 
    cdq                      ; convert dword to quadword
    idiv ecx                 ; divide num by i
    cmp edx, 0               ; check remainder against 0
    je is_composite_result   ; if it is, then a factor was found

    ; Increment loop counter
    inc ecx
    jmp start_loop

is_prime_result:
    ; Return true (no factors found)
    mov eax, 1
    jmp end_is_prime

is_composite_result:
    ; Return false (factor found)
    mov eax, 0
    jmp end_is_prime

end_is_prime:
    mov esp, ebp
    pop ebp    
    ret