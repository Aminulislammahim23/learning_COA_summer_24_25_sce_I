.model small
.stack 100h

.data
    message db 'Hello, World!$'

.code
start:
    mov ax, @data    ; load address of data segment
    mov ds, ax

    mov ah, 09h       ; DOS print function
    lea dx, message   ; load address of message into DX
    int 21h           ; call DOS interrupt to print

    mov ah, 4Ch       ; DOS terminate program function
    int 21h           ; return to DOS

end start
