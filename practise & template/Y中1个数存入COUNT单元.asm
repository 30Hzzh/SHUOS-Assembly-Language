data segment
    number dw 0ffffh
    addre  dw ?
    count  dw ?
data ends

code segment
           assume cs:code,ds:data
    start: 
           push   ds
           sub    ax,ax
           push   ax
           mov    ax,data
           mov    ds,ax

           call   main
           call   turn
           mov    ah,4ch
           int    21h
main proc near
           lea    ax,number
           mov    addre,ax
           mov    cx,0
           mov    bx,addre
           mov    ax,[bx]
    rpt:   
           test   ax,0ffffh
           jz     exit               ;如果本身就是0，就退出
           jns    shift              ;如果是正数，说明最高位（第一位）是0，就移位
           inc    cx                 ;如果是负数，说明最高位（第一位）是1，就不移位
    shift: 
           shl    ax,1               ;shl:逻辑左移
           jmp    rpt
    exit:  
           mov    count,cx
           ret
main endp

turn proc near
           mov    bx,count
           mov    ch,4
    rotate:
           mov    cl,4
           rol    bx,cl
           mov    al,bl
           and    al,0fh
           add    al,30h
           cmp    al,39h
           jl     print
           add    al,7
    print: 
           mov    dl,al
           mov    ah,2
           int    21h
           dec    ch
           jnz    rotate
           RET
turn endp

code ends
end start