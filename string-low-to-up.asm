data segment
    mess         db 'Enter a sentence:',0DH,0AH,'$'
    mess1        db 'The sum of the chars:',0DH,0AH,'$'
    mess2        db 'The running time:',0DH,0AH,'$'
    MaxLength    db 100
    ActualLength db ?
    String       db 100 dup(?)
    ChangeRow    db 0DH,0ah,'$'
    time1_hour   DB ?
    time1_minute DB ?
    time1_second DB ?
    time2_hour   DB ?
    time2_minute DB ?
    time2_second DB ?
    diff_hour    DB ?
    diff_minute  DB ?
    diff_second  DB ?
data ends
;数据段定义
stack segment
          dw 128 dup(?)
stack ends

code segment
                 assume cs:code,ds:data,ss:stack

    Start:       
                 mov    ax,data
                 mov    ds,ax
                 push   cx
                 push   dx
                 call   GetTime1
                 pop    dx
                 pop    cx
    Ask:         
                 mov    dx,OFFSET mess
                 mov    ah,09h
                 int    21H
    ;输入字符串
    Input:       
                 mov    dx,OFFSET MaxLength
                 mov    ah,0ah
                 int    21H
    ;设置循环次数
    Count:       
                 mov    bx,OFFSET String
                 mov    ch,0
                 mov    cl,ActualLength
    ;循环处理字符串中的每个字符
    Deal:        
                 mov    al,[bx]
                 call   l_to_u
                 mov    [bx],al
                 inc    bx
                 loop   Deal
    ;在字符串末尾加上结束符号
    Deal_tail:   
                 mov    bx,OFFSET string
                 mov    dh,0
                 mov    dl,ActualLength
                 add    bx,dx

                 mov    al,24H                      ;'$'
                 mov    [bx],al
    ;显示字符串,字符统计结果，时间统计结果
    Output:      
                 call   change

                 mov    dx,OFFSET String
                 mov    ah,09h
                 int    21H
              
                 call   change

                 mov    dx,OFFSET mess1
                 mov    ah,09h
                 int    21H
            
                 mov    DX,OFFSET ActualLength
                 mov    dl,ds:[ActualLength]
                 add    dl,'0'
                 mov    ah,02h
                 int    21H
              
                 call   change

                 call   GetTime2
                 call   display_time
                 call   change

    Over:        
                 mov    ah,4CH
                 int    21H
;换行子程序
change PROC
                 mov    dx,OFFSET ChangeRow
                 mov    ah,09h
                 int    21H
                 RET
change ENDP
;转换字符子程序
l_to_u PROC
                 cmp    al,'a'
                 jl     DONE
                 sub    al,20H
    DONE:        
                 RET
l_to_u ENDP

;获取时间子程序1
GetTime1 PROC
                 MOV    AH, 2Ch                     ; 功能号2Ch - 获取系统时间
                 INT    21h

                 MOV    time1_hour, CH              ; 小时
                 MOV    time1_minute, CL            ; 分钟
                 MOV    time1_second, DH            ; 秒
                 RET
GetTime1 ENDP

;获取时间子程序2
GetTime2 PROC
                 MOV    AH, 2Ch                     ; 功能号2Ch - 获取系统时间
                 INT    21h

                 MOV    time2_hour, CH              ; 小时
                 MOV    time2_minute, CL            ; 分钟
                 MOV    time2_second, DH            ; 秒
                 RET
GetTime2 ENDP

;显示时间差子程序
display_time PROC
    ; 计算时间差
                 MOV    AL, time2_hour              ; 时间2小时
                 SUB    AL, time1_hour              ; 减去时间1小时
                 MOV    diff_hour, AL               ; 保存差值到diff_hour

                 MOV    AL, time2_minute            ; 时间2分钟
                 SUB    AL, time1_minute            ; 减去时间1分钟
                 MOV    diff_minute, AL             ; 保存差值到diff_minute

                 MOV    AL, time2_second            ; 时间2秒
                 SUB    AL, time1_second            ; 减去时间1秒
                 MOV    diff_second, AL             ; 保存差值到diff_second

    ; 显示时间差
                 MOV    AH, 09h                     ; 功能号09h - 显示字符串
                 LEA    DX, mess2                   ; 字符串地址
                 INT    21h

                 MOV    AH, 02h                     ; 功能号02h - 显示字符

                 MOV    DL, diff_hour               ; 显示小时差值
                 ADD    DL, '0'                     ; 转换为ASCII码
                 INT    21h

                 MOV    DL, ':'                     ; 显示冒号分隔符
                 INT    21h
    
                 MOV    DL, diff_minute             ; 显示分钟差值
                 ADD    DL, '0'                     ; 转换为ASCII码
                 INT    21h

                 MOV    DL, ':'                     ; 显示冒号分隔符
                 INT    21h

                 MOV    DL, diff_second             ; 显示秒差值
                 ADD    DL, '0'                     ; 转换为ASCII码
                 INT    21h
                 RET
display_time ENDP
code ends
end Start