data segment
x dw 100
y dw 1
result dw ?
data ends

code segment
    assume cs:code, ds:data
start:
    mov ax, data
    mov ds, ax

    mov ax,x
    cmp ax,50
    jg TOO_HIGH
    jmp EXIT
TOO_HIGH:
    sub ax,y
    jo OVERFLOW
    jns NO_OVERFLOW
    NEG AX
OVERFLOW:
nop
jmp EXIT
NO_OVERFLOW:
nop
jmp EXIT
EXIT:
    mov result,ax
    mov ah,4ch
    int 21h
code ends
end start



    