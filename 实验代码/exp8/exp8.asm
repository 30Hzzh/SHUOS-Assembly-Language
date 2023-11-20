data segment
    table       dw routine_1
                dw routine_2
                dw routine_3
                dw routine_4
    menu        db "********************************************************",0DH,0AH
                db "Please input",0DH,0AH
                db "1 print hello world!",0DH,0AH
                db "2 adder",0DH,0AH
                db "3 display current time",0DH,0AH
                db "4 quit",0DH,0AH
                db "********************************************************",0DH,0AH,'$'
    str1        db "hello world!",0DH,0AH,'$'
    str2        db "Please X:",0DH,0AH,'$'
    str3        db "Please Y:",0DH,0AH,'$'
    ChangeRow   db 0DH,0ah,'$'
    X           db 6,0,6 dup(?)
    Y           db 6,0,6 dup(?)
    x1          dw 0
    y1          dw 0
    res         dw 0
    temp        db 0
    time_hour   db 0
    time_minute db 0
    time_second db 0

data ends

code segment
                   assume cs:code, ds:data
    start:         
                   mov    ax, data
                   mov    ds, ax

    memu_display:  
                   sub    ax,bX
                   sub    bx,bX
                   sub    cx,cX
                   sub    dx,dX

                   lea    dx, menu
                   mov    ah,09h
                   int    21h

                   mov    ah,01h
                   int    21h
                   call   change

                   sub    ah,ah
                   sub    al,'0'
                   sub    al,1
                   shl    al,1
                
                   mov    si,ax
                   jmp    table[si]

    routine_1:     
                   lea    dx, str1
                   mov    ah,09h
                   int    21h
                   jmp    memu_display

    routine_2:     
                   lea    dx, str2
                   call   put_str

                   lea    dx,X
                   call   get_str
                   call   change

                   lea    dx, str3
                   call   put_str

                   lea    dx,Y
                   call   get_str
                   call   change

                   lea    si,X+1
                   mov    bx,offset x1
                   call   str2num

                   lea    si,Y+1
                   mov    bx,offset y1
                   call   str2num

                   mov    ax,x1
                   add    ax,y1
                   mov    res,ax
                   call   display_result
                   call   change
                   jmp    memu_display

    routine_3:     
                   call   GetTime1
                   call   display_time
                   jmp    memu_display
    
    routine_4:     mov    ah,4CH
                   int    21h
put_str proc far
                   push   ax
                   mov    ah,09h
                   int    21h
                   pop    ax
                   ret
put_str endp

get_str proc far
                   push   ax
                   mov    ah,0Ah
                   int    21h
                   pop    ax
                   ret
get_str endp

str2num proc far
                   push   bx
                   sub    ax,ax
                   sub    cx,cx
                   sub    dx,dx

                   mov    cl,[si]
                   mov    bx,10
    l1:            
                   add    si,1
                   mov    dl,[si]
                   sub    dh,dh
                   sub    dl,'0'
                   mov    temp,dl
                   mul    bx
                   add    ax,word ptr temp
                   loop   l1
                   pop    bx
                   mov    [bx],ax
                   ret
str2num endp

display_result proc far
                
                   MOV    AH,00H                 ;     清空AH，AH中可能由02，01这样调用int21的残留
                   XOR    CX,CX                  ;      CX记录十进制位数
                   MOV    BL,10                  ;      除数
    LOOP1:         
                   DIV    BL                     ;         出发操作，余数在AH，商在AL
                   INC    CX                     ;         位数加1
                   PUSH   AX                     ;        入栈保存
                   MOV    AH,00H                 ;     清除余数
                   XOR    AL,00H                 ;     检查是否变为0
                   JNZ    LOOP1                  ;      若还有的除，继续

                   MOV    AH,02H                 ;     AH=02H 输出字符
    LOOP2:         
                   POP    DX                     ;
                   MOV    DL,DH                  ;      DH里是要输出的余数
                   ADD    DL,30H                 ;     转ASCII码
                   INT    21H                    ;        输出
                   LOOP   LOOP2                  ;     CX = CX-1 JNZ
                   ret
display_result endp

change proc far
                   mov    dx,OFFSET ChangeRow
                   mov    ah,09h
                   int    21H
                   RET
change endp

GetTime1 PROC far
                   sub    ax,AX
                   MOV    AH, 2Ch                ; 功能号2Ch - 获取系统时间
                   INT    21h

                   MOV    time_hour, CH          ; 小时
                   MOV    time_minute, CL        ; 分钟
                   MOV    time_second, DH        ; 秒
                   RET
                
GetTime1 ENDP

display_time proc far
                    
                   MOV    AL, time_hour
                   call   display_result

                   mov    ah,02H
                   MOV    DL, ':'                ; 显示冒号分隔符
                   INT    21h
    
                   MOV    AL, time_minute        
                   call   display_result

                   mov    ah,02H
                   MOV    DL, ':'                
                   INT    21h

                   MOV    AL, time_second       
                   call   display_result
                   call   change
                   RET
display_time endp
code ends
end start

