data segment
x db 12h
y dw x
z dd y
data ends

code segment
assume cs:code, ds:data
start:
mov ax,data
mov ds,ax

mov ax,1
ror ax,2

mov ax,4c00h
int 21h
code ends
end start
