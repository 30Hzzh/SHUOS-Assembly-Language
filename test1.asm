data segment
    X    dw 1
    Y    dw 2
    W    dw 3
    Z    Dw 3

data ends

stack segment
    sss   dw 128 dup(?)
    top   DW length sss
stack ends

code segment
          assume cs:code,ds:data,ss:stack
    start:
          mov    ax,data
          mov    ds,ax
          MOV    AX,X
          SUB    AX,Y
          ADD    AX,W
          MOV    Z,AX
          mov    ax,4c00h
          int    21h
code ends
end start