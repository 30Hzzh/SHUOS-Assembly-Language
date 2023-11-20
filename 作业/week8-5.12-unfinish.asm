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

              mov    si,4*2-2
              mov    bx,-2
              mov    cx,4
    loop1:    
              add    bx,2
              cmp    MEM[bx],0
              je     deal
              loop   loop1
              jmp    display
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

    display:  
              mov    cx,4
              mov    bx,-2
    loop3:    
              add    bx,2
              mov    ax,MEM[bx]
              call   print
              cmp    cnt,10
              je     next_line
              loop   loop3
    exit:     
              mov    ax,4c00h
              int    21h
    next_line:
              mov    cnt,0
              call   change
              loop   loop3

change PROC
              mov    dx,OFFSET changerow
              mov    ah,09h
              int    21H
              RET
change ENDP

print proc near
              push   bx
              push   cx

              mov    bl,10
    print1:   
              sub    dx,dx
              div    bl
              add    dl,'0'
              push   dx
              dec    cx
              jnz    print1

              mov    cx,4
    print2:   
              pop    dx
              mov    ah,2
              int    21h
              loop   print2

              pop    cx
              pop    bx
              inc    cnt
              ret
print ENDP
code ends
end start
