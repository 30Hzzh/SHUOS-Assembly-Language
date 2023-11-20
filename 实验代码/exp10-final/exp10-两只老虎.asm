data segment
    frequency dw 2 dup(262,300,330,262)            ;两只老虎*2
              dw 2 dup(330,349,392)                ;真奇怪*2
              dw 2 dup(392,440,392,349,330,262)    ;一只没有耳朵*2
              dw 2 dup(294,196,262),-1             ;真奇怪*2

    play_time dw 10 dup(400)                       ;时间表
              dw 800                               ;“怪”字发长音
              dw 2 dup(400)
              dw 800
              dw 4 dup(200)                        ;两句连续短音
              dw 2 dup(400)
              dw 4 dup(200)
              dw 4 dup(400)
              dw 800
              dw 2 dup(400)
              dw 800
data ends

stack segment
          db 64 dup(?)
stack ends

code segment
             assume cs:code,ss:stack,ds:data
    start:   

             mov    ax,data
             mov    ds,ax
             lea    si,frequency                ;导入频率表
             lea    bp,ds:play_time             ;导入时间表
    play_one:
             mov    di,[si]
             cmp    di,-1                       ;判断是否最后一个音符
             je     exit
             mov    bx,ds:[bp]
             call   sound                       ;播放一个音符
             add    si,2                        ;寻找下一个音符
             add    bp,2
             jmp    play_one
    exit:    
             mov    ax,4c00h
             int    21h

sound proc near
             assume cs:code

             push   ax
             push   bx
             push   cx
             push   dx
             push   di

             mov    al,0b6h                     ;改变计时器工作模式
             out    43h,al
             mov    dx,12h                      ;计算播放频率
             mov    ax,348ch
             div    di

             out    42h,al                      ;写入高字节
             mov    al,ah
             out    42h,al                      ;写入低字节

             in     al,61h                      ;打开扬声器与门
             or     al,3
             out    61h,al

    wait1:   mov    cx,2800                     ;根据时间表计算延迟时间
    delay:   loop   delay
             dec    bx
             jnz    wait1

             in     al,61H                      ;关闭与门
             and    al,0FCH
             out    61H,al

             pop    di
             pop    dx
             pop    cx
             pop    bx
             pop    ax
             ret
sound endp
code ends
end start