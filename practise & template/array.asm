data segment
    array db 100 dup(?)
data ends

code segment
        assume ds:data,cs:code
    start:
        mov ax, data
        mov ds, ax

        mov si,offset array
        mov cx,100
        mov bl,0
    main:
        mov [si],bl
        inc si
        inc bl
        loop main
    
        mov ah,4ch
        int 21h
code ends
end start
