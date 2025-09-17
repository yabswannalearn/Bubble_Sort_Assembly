section .data
    array db 2, 6, 15, 8, 4, 9, 99, 100, 255, 0, 220, 248, 137, 254  ; numbers to sort
    n equ 14       ; number of elements
    digit db 0
    space db ' '
    newline db 10

section .text
    global _start

_start:
    ; Bubble Sort
    mov rcx, n
outer_loop:
    mov rbx, n
    dec rbx
    mov rsi, array

inner_loop:
    ; load as unsigned (0–255)
    movzx eax, byte [rsi]       ; current
    movzx edx, byte [rsi+1]     ; next
    cmp eax, edx
    jle no_swap

    ; swap
    mov al, [rsi]
    mov dl, [rsi+1]
    mov [rsi], dl
    mov [rsi+1], al

no_swap:
    inc rsi
    dec rbx
    jnz inner_loop
    loop outer_loop

    ; Print sorted array
    xor rbx, rbx        ; index = 0

print_loop:
    cmp rbx, n
    jge done_printing

    ; load number into RAX
    movzx rax, byte [array+rbx]

    ; --- divide by 100 to check for 3 digits ---
    xor rdx, rdx
    mov rcx, 100
    div rcx              ; RAX ÷ 100 → quotient in RAX, remainder in RDX

    mov r8, rax          ; hundreds
    mov r9, rdx          ; remainder

    cmp r8, 0
    je check_two_digits

    ; print hundreds digit
    add r8b, '0'
    mov [digit], r8b
    mov rax, 1
    mov rdi, 1
    lea rsi, [digit]
    mov rdx, 1
    syscall

    ; now process remainder for tens and ones
    mov rax, r9
    xor rdx, rdx
    mov rcx, 10
    div rcx              ; quotient = tens, remainder = ones
    mov r8, rax
    mov r9, rdx

    ; print tens digit
    add r8b, '0'
    mov [digit], r8b
    mov rax, 1
    mov rdi, 1
    lea rsi, [digit]
    mov rdx, 1
    syscall

    ; print ones digit
    add r9b, '0'
    mov [digit], r9b
    mov rax, 1
    mov rdi, 1
    lea rsi, [digit]
    mov rdx, 1
    syscall

    jmp print_space

check_two_digits:
    ; check for 2 digits (divide by 10)
    mov rax, r9          ; remainder from 100 div
    xor rdx, rdx
    mov rcx, 10
    div rcx
    mov r8, rax          ; tens
    mov r9, rdx          ; ones

    cmp r8, 0
    je one_digit

    ; print tens
    add r8b, '0'
    mov [digit], r8b
    mov rax, 1
    mov rdi, 1
    lea rsi, [digit]
    mov rdx, 1
    syscall

one_digit:
    ; print ones
    add r9b, '0'
    mov [digit], r9b
    mov rax, 1
    mov rdi, 1
    lea rsi, [digit]
    mov rdx, 1
    syscall

print_space:
    ; space
    mov rax, 1
    mov rdi, 1
    lea rsi, [space]
    mov rdx, 1
    syscall

    inc rbx
    jmp print_loop

done_printing:
    ; newline
    mov rax, 1
    mov rdi, 1
    lea rsi, [newline]
    mov rdx, 1
    syscall

    ; exit
    mov rax, 60
    xor rdi, rdi
    syscall
