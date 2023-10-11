data segment
    x    dw 1234H
    y    dw 2345H
    z    dw -1234H
    ans  dw ?
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

           mov    ax,stack
           mov    ss,ax
           mov    sp,top

           mov    ax,z
           push   ax
           mov    ax,y
           push   ax
           mov    ax,x
           push   ax

           call   maxnum
           mov    ah,4ch
           int    21H
           
maxnum proc near
           mov    bp,sp
           mov    ax,[bp+2]
           cmp    ax,[bp+4]
           jge    l1
           mov    ax,[bp+4]
    l1:    cmp    ax,[bp+6]
           jge    l2
           mov    ax,[bp+6]
    l2:    mov    [ans],ax
    done:  ret
maxnum endp
code ends
end start