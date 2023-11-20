data segment
    MEM       dw 1,2,0,3,4,0,5,6,0,7
              dw 90 dup(1)
    changerow db 0dh,0ah,'$'
    cnt       dw 0
data ends

stack segment
          dw 128 dup(0)
stack ends
code segment
          assume cs:code,ds:data,ss:stack
    start:
          mov    ax,data
          mov    ds,ax

          mov    si,100*2-2
          mov    bx,-2
          mov    cx,100
    loop1:
          add    bx,2
          cmp    MEM[bx],0
          je     deal
          loop   loop1
          jmp    exit
    deal: 
          mov    di,bx
    ; 开始向前移动
    loop2:
    ;看是否到了最后一个元素
          cmp    di,si
          je     add_0
          mov    ax,MEM[di+2]
          mov    MEM[di],ax
          add    di,2
          jmp    loop2
    add_0:
          mov    word ptr MEM[si],0
          loop   loop1

    exit: 
          mov    ah,4ch
          int    21h
code ends
end start
