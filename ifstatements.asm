; Build:
; wsl bash -c "cd /mnt/c/Users/dismay/Documents/GitHub/asm-learning && nasm -f elf64 ifstatements.asm -o hello.o && gcc -no-pie hello.o -o hello && ./hello"
; https://trickingrockstothink.com/blog_posts/2019/08/17/c_to_assembly.html
global main
extern printf
section .text

main:
    mov  EAX, [rel input1]   ; Load the inputs
    mov  EBX, [rel input2]

    cmp EAX, EBX         ; input1 - input2 <25 - 43 = -18> so if negative must be less than or equal to 0
    jle _else_start      ; Jump to else_start condition if 0 or negative

_if_start: ; if jle a postive number, we are here
    mov ECX, 7 ; place 7 in ECX
    jmp _after_if ; jump to after_if

_else_start:
    mov ECX, [rel output] ; jle is 0 or negative, we are here
    imul ECX, 2 ; output * 2

_after_if:
    add ECX, 5 ; output + 5, or (output * 2) + 5 depending on the branch taken
    mov [rel output], ECX ; place value to output variable

    ; print to console
    lea rdi, [rel fmt]         ; arg1: pointer to format string
    mov esi, ecx               ; arg2: integer value for %d
    xor eax, eax               ; variadic-call ABI requirement: AL = number of XMM args (0 here)
    call printf

    xor eax, eax               ; return 0 from main
    ; end print to console

    ; We are done executing - return control to the operating system
    retn

; ----------------------------------------------------------------------------
; Global Variables

section .data
    fmt    db "output = %d", 10, 0  ; C string: "output = %d\n\0"
    output      DD 5
    input1      DD 25
    input2      DD 43

section .note.GNU-stack noalloc noexec nowrite progbits ; remove executable permissions from the stack
