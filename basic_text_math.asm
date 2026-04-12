; Build:
; nasm -f elf64 basic_text_math.asm -o hello.o
; gcc -no-pie hello.o -o hello
;
; Memory/addressing:
; [input2] means "dereference": read/write memory at label input2
; mov = copies data between operands (register/memory/immediate, depending on form)
; lea = Load Effective Address: computes an address, does NOT read memory (similar to: base address + offset)
; rel = RIP-relative addressing (x86-64), useful for referring to nearby labels 
;
; Math instructions:
; add  = integer addition
; imul = signed integer multiplication
;
; Registers / ABI notes:
; eax = low 32 bits of rax (often used for integer math/return values)
; esi = low 32 bits of rsi (argument register #2 in SysV x86-64 ABI)
; rdi = 64-bit register for argument #1 in SysV x86-64 ABI
; edi is the low 32-bit subregister of rdi
; Writing a 32-bit register (like eax/esi/edi) zero-extends into its 64-bit parent
;
; Operand order in Intel syntax:
; destination, source
; Example: mov eax, [input2]  ; copy value at input2 into eax
;
; Learning resources:
; https://trickingrockstothink.com/blog_posts/2019/08/17/c_to_assembly.html
; https://www.cs.virginia.edu/~evans/cs216/guides/x86.html
; https://cs.brown.edu/courses/cs033/docs/guides/x64_cheatsheet.pdf
; https://stackoverflow.com/questions/5738595/can-someone-please-explain-to-me-in-very-simple-terms-what-the-difference-betw
;
global main                    ; export symbol so linker can resolve main
extern printf                  ; printf is provided by libc at link/runtime

section .text
main:                          ; process entry point for C runtime call into your code
    mov eax, [rel input2]      ; eax = input2
    imul eax, 5                ; eax = eax * 5
    add eax, [rel input1]      ; eax = eax + input1
    mov [rel output], eax      ; output = eax

    ; Print: printf("output = %d\n", eax)
    lea rdi, [rel fmt]         ; arg1: pointer to format string
    mov esi, eax               ; arg2: integer value for %d
    xor eax, eax               ; variadic-call ABI requirement: AL = number of XMM args (0 here)
    call printf

    xor eax, eax               ; return 0 from main
    ret

section .data
    ; NASM data directives:
    ; db = define byte(s)
    ; dd = define doubleword (32-bit)
    fmt    db "output = %d", 10, 0  ; C string: "output = %d\n\0"
    output dd 0                      ; int output = 0
    input1 dd 25                     ; int input1 = 25
    input2 dd 43                     ; int input2 = 43
