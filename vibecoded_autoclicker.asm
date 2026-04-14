; nasm -f win32 vibecoded_autoclicker.asm -o vibecoded_autoclicker.obj
; gcc vibecoded_autoclicker.obj -o vibecoded_autoclicker.exe -luser32
; .\vibecoded_autoclicker.exe


global _main
extern _GetAsyncKeyState@4
extern _Sleep@4
extern _printf
extern _mouse_event@20

section .data
    msgClick     db "[CLICK] Left click sent", 10, 0
    msgOn        db "[TOGGLE ON]  Clicking every 0.05 seconds", 10, 0
    msgOff       db "[TOGGLE OFF] Paused", 10, 0

section .text
_main:
    xor ebx, ebx                 ; ebx = toggle state (0=off, 1=on)

.loop:
    ; Detect edge press of P using low-order bit from GetAsyncKeyState
    push dword 0x50              ; VK_P
    call _GetAsyncKeyState@4
    test eax, 1
    jz .afterToggleCheck

    ; Flip toggle: 0->1 or 1->0
    xor ebx, 1
    cmp ebx, 1
    je .printOn

.printOff:
    push dword msgOff
    call _printf
    add esp, 4
    jmp .afterToggleCheck

.printOn:
    push dword msgOn
    call _printf
    add esp, 4

.afterToggleCheck:
    cmp ebx, 1
    jne .sleepShort              ; if toggle off, just poll keys

    ; Toggle ON: simulate left click down
    ; mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0)
    push dword 0                 ; dwExtraInfo
    push dword 0                 ; dwData
    push dword 0                 ; dy
    push dword 0                 ; dx
    push dword 0x0002            ; MOUSEEVENTF_LEFTDOWN
    call _mouse_event@20

    ; simulate left click up
    ; mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0)
    push dword 0
    push dword 0
    push dword 0
    push dword 0
    push dword 0x0004            ; MOUSEEVENTF_LEFTUP
    call _mouse_event@20

    ; print click message
    push dword msgClick
    call _printf
    add esp, 4

    ; wait 0.05 seconds
    push dword 1
    call _Sleep@4
    jmp .loop

.sleepShort:
    push dword 50                ; light polling while OFF
    call _Sleep@4
    jmp .loop
