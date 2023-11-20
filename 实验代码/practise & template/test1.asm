code segment
    start:
        jmp short s
        db 128 dup(0)
        s:mov ax,0ffffh
        code
code ends

