.model small
.stack 100h

.data
    ; Input buffers for name and department:
    ; First byte = max size (20)
    ; Second byte = actual length (filled by DOS)
    ; Then 20 bytes reserved for input characters
    nameBuf db 20,0,20 dup(?)
    deptBuf db 20,0,20 dup(?)

    promptName db 'Enter your name: $'
    promptAge  db 'Enter your age (one digit): $'
    promptDept db 'Enter your department: $'
    newline db 13,10,'$'           ; carriage return + line feed (new line)

    ; Labels for displaying results
    nameLabel db 'Name: $'
    ageLabel  db 'Age: $'
    deptLabel db 'Department: $'

.code
start:
    mov ax, @data      ; Load data segment address into AX
    mov ds, ax         ; Set DS register to point to data segment

    ; ---- Input Name ----
    mov ah, 09h        ; DOS print string function
    lea dx, promptName ; Load offset of promptName into DX
    int 21h            ; Call DOS interrupt to print prompt

    lea dx, nameBuf    ; Load offset of nameBuf (input buffer) into DX
    mov ah, 0Ah        ; DOS buffered input function
    int 21h            ; Call DOS interrupt to read string input

    ; Print a newline after input
    mov ah, 09h
    lea dx, newline
    int 21h

    ; ---- Input Age ----
    mov ah, 09h
    lea dx, promptAge
    int 21h

    mov ah, 01h        ; DOS function to read single character from keyboard
    int 21h
    mov bl, al         ; Save the entered age character in BL register

    ; Newline after age input
    mov ah, 09h
    lea dx, newline
    int 21h

    ; ---- Input Department ----
    mov ah, 09h
    lea dx, promptDept
    int 21h

    lea dx, deptBuf
    mov ah, 0Ah
    int 21h

    ; Newline after department input
    mov ah, 09h
    lea dx, newline
    int 21h

    ; ---- Display "Name: " ----
    mov ah, 09h
    lea dx, nameLabel
    int 21h

    ; Print the name string character by character
    mov cl, [nameBuf+1]     ; Length of the entered name string
    mov si, offset nameBuf + 2  ; Point SI to first character of name
print_name_loop:
    cmp cl, 0
    je print_name_done
    mov dl, [si]            ; Move character to DL for printing
    mov ah, 02h             ; DOS print single character function
    int 21h
    inc si
    dec cl
    jmp print_name_loop
print_name_done:

    ; Print newline
    mov ah, 09h
    lea dx, newline
    int 21h

    ; ---- Display "Age: " ----
    mov ah, 09h
    lea dx, ageLabel
    int 21h

    ; Print the age character saved earlier
    mov dl, bl
    mov ah, 02h
    int 21h

    ; Newline after age
    mov ah, 09h
    lea dx, newline
    int 21h

    ; ---- Display "Department: " ----
    mov ah, 09h
    lea dx, deptLabel
    int 21h

    ; Print the department string character by character
    mov cl, [deptBuf+1]     ; Length of department input
    mov si, offset deptBuf + 2  ; Point SI to first character of department
print_dept_loop:
    cmp cl, 0
    je print_dept_done
    mov dl, [si]
    mov ah, 02h
    int 21h
    inc si
    dec cl
    jmp print_dept_loop
print_dept_done:

    ; Print newline
    mov ah, 09h
    lea dx, newline
    int 21h

    ; ---- Exit program ----
    mov ah, 4Ch         ; DOS terminate program function
    int 21h

end start
