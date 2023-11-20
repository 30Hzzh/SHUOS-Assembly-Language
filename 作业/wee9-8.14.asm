data segment
    hour1   db ?
    minute1 db ?
    second1 db ?
    hour2   db ?
    minute2 db ?
    second2 db ?
    h_diff db ?
    m_diff db ?
    s_diff db ?
    mess1 db "Time before running program",0dh,0ah,'$'
    mess2 db "Time after running program",0dh,0ah,'$'
    mess3 db "Time difference",0dh,0ah,'$'
    ctrl db 0dh,0ah,'$'
data ends

code segment
assume cs:code, ds:data
start:
    mov ax,data
    mov ds,ax

    lea dx, mess1
    mov ah, 09h
    int 21h

    call get_time
    mov hour1, ch
    mov minute1, cl
    mov second1, dh
    
    call display_time1
    call program
    
    lea dx, mess2
    mov ah, 09h
    int 21h

    call get_time
    mov hour2, ch
    mov minute2, cl
    mov second2, dh

    call display_time2
    lea dx, mess3
    mov ah, 09h
    int 21h

    mov al, hour2
    sub al, hour1
    mov h_diff, al

    mov al, minute2
    sub al, minute1
    mov m_diff, al

    mov al, second2
    sub al, second1
    mov s_diff, al

    call display_time3
    mov ah,4ch
    int 21h

get_time proc near
    mov ah,2ch
    int 21h
    ret
get_time endp

program proc near
    mov dx,0002fh
ll1:
    mov cx,0ffffh
l1:
    loop l1
    dec dx
    jnz ll1
    ret
program endp

display proc far
                
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
display endp

display_time1 proc far
                    
                   MOV    AL, hour1
                   call   display

                   mov    ah,02H
                   MOV    DL, ':'                ; 显示冒号分隔符
                   INT    21h
    
                   MOV    AL, minute1     
                   call   display

                   mov    ah,02H
                   MOV    DL, ':'                
                   INT    21h

                   MOV    AL, second1     
                   call   display
                   call   change
                   RET
display_time1 endp

display_time2 proc far
                    
                   MOV    AL, hour2
                   call   display

                   mov    ah,02H
                   MOV    DL, ':'                ; 显示冒号分隔符
                   INT    21h
    
                   MOV    AL, minute2      
                   call   display

                   mov    ah,02H
                   MOV    DL, ':'                
                   INT    21h

                   MOV    AL, second2      
                   call   display
                   call   change
                   RET
display_time2 endp

display_time3 proc far
                    
                   MOV    AL, h_diff
                   call   display

                   mov    ah,02H
                   MOV    DL, ':'                ; 显示冒号分隔符
                   INT    21h
    
                   MOV    AL, m_diff      
                   call   display

                   mov    ah,02H
                   MOV    DL, ':'                
                   INT    21h

                   MOV    AL, s_diff      
                   call   display
                   call   change
                   RET
display_time3 endp


change proc near
    lea dx, ctrl
    mov ah, 09h
    int 21h
    ret
change endp

code ends
end start
