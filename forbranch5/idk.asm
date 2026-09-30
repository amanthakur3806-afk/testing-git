section .data
    ; Initialize a constant string. 10 represents the newline character (\n).
    msg db "Hello from the Assembly Line!", 10
    ; Calculate the string length dynamically by subtracting the starting address
    msg_len equ $ - msg

section .text
    global _start

_start:
    ; 1. PREPARE THE WRITE SYSTEM CALL
    mov rax, 1        ; Linux system call number 1 is 'sys_write'
    mov rdi, 1        ; File descriptor 1 is 'stdout' (Standard Output)
    mov rsi, msg      ; Load the memory pointer address of our string into RSI
    mov rdx, msg_len  ; Pass the string length count into RDX
    syscall           ; Invoke the kernel to execute the write operation

    ; 2. PREPARE THE EXIT SYSTEM CALL
    mov rax, 60       ; Linux system call number 60 is 'sys_exit'
    xor rdi, rdi      ; Clear RDI (sets it to 0), returning a 'Success' status code
    syscall           ; Invoke the kernel to cleanly terminate the program

section .text
    global _start

_start:
    ; 1. INITIALIZE REGISTERS
    mov rax, 0        ; Use RAX as our running total (accumulator), start at 0
    mov rcx, 5        ; Use RCX as our loop counter index, start at 5

.loop_start:
    ; 2. EXECUTE REPETITIVE MATH
    add rax, rcx      ; Add the value currently in RCX directly into RAX
    dec rcx           ; Decrement the loop counter index in RCX by 1

    ; 3. CONDITIONAL BRANCHING
    cmp rcx, 0        ; Compare the value in RCX to 0
    jg .loop_start    ; If RCX is Jump-Greater-Than 0, jump back to .loop_start

    ; 4. EXIT WITH RESULTS
    ; The final calculation is: 5 + 4 + 3 + 2 + 1 = 15 (0xF in hex)
    mov rdi, rax      ; Move our calculation total (15) into the exit status code register
    mov rax, 60       ; Prepare sys_exit
    syscall           ; Exit the app (type 'echo $?' in your terminal to see the 15!)
