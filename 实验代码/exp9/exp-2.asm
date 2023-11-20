data segment
    ratetable DW 524,588,660,698,784,880,988,1048             ;频率表
    mess      DB 'Please input char 1 ~ 8'                    ;提示信息
              DB 'to get the corresponding voice!',0ah,0dh
              DB 'Quit with (ctrl C):',0ah,0dh,'$'
data ends

code segment
          assume cs:code,ds:data
    start:
          mov    ax,data
          mov    ds,ax

          mov    ah,9
          lea    dx,mess
          int    21h

    loop1:
          mov    ah,1
          int    21h

          cmp    al,03H
          je     quit
    
          cmp    al,31H
          jge    jg2
          jmp    loop1
    jg2:  
          cmp    al,38H
          jle    jg3
          jmp    loop1
    jg3:  
          call   voice
          jmp    loop1
    quit: 
          mov    ah,4CH
          int    21H

voice proc near
          xor    ah,ah
          sub    al,'0'
          sub al,1
          mov    di,ax
          add    di,di
          mov    bx,[di]
          mov    dx,1000

          in     al,61H
          and    al,11111100B

    trig: 
          xor    al,2
          out    61h,al
          mov    cx,bx
    delay:
          loop   delay
          dec    dx
          jne    trig
          ret
voice endp
code ends
end start

    

