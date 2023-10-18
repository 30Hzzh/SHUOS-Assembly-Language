code segment
main proc far
    assume cs:code
start:
    push ds
    sub bx,bx
    push ax
    mov bx,1111111111111111b
    mov ch,4
rotate:
    mov cl,4
    rol bx,cl
    mov al,bl
    and al,0fh
    add al,30h
    cmp al,39h
    jl print
    add al,7
print:
    mov dl,al
    mov ah,2
    int 21h
    dec ch
    jnz rotate
    RET
main endp
code ends
end