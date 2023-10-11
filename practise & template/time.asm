.MODEL SMALL
.STACK 100H

.DATA
  time1_hour   DB ?
  time1_minute DB ?
  time1_second DB ?
  time2_hour   DB ?
  time2_minute DB ?
  time2_second DB ?
  diff_hour    DB ?
  diff_minute  DB ?
  diff_second  DB ?
  message      DB 'Time difference: $'

.CODE
  MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; 获取时间1
    MOV AH, 2Ch  ; 功能号2Ch - 获取系统时间
    INT 21h

    MOV time1_hour, CH ; 小时
    MOV time1_minute, CL ; 分钟
    MOV time1_second, DH ; 秒

    ; 获取时间2
    MOV AH, 2Ch  ; 功能号2Ch - 获取系统时间
    INT 21h

    MOV time2_hour, CH ; 小时
    MOV time2_minute, CL ; 分钟
    MOV time2_second, DH ; 秒

    ; 计算时间差
    MOV AL, time2_hour  ; 时间2小时
    SUB AL, time1_hour  ; 减去时间1小时
    MOV diff_hour, AL   ; 保存差值到diff_hour

    MOV AL, time2_minute ; 时间2分钟
    SUB AL, time1_minute ; 减去时间1分钟
    MOV diff_minute, AL  ; 保存差值到diff_minute

    MOV AL, time2_second ; 时间2秒
    SUB AL, time1_second ; 减去时间1秒
    MOV diff_second, AL  ; 保存差值到diff_second

    ; 显示时间差
    MOV AH, 09h  ; 功能号09h - 显示字符串
    LEA DX, message ; 字符串地址
    INT 21h

    MOV AH, 02h  ; 功能号02h - 显示字符

    MOV DL, diff_hour ; 显示小时差值
    ADD DL, '0'  ; 转换为ASCII码
    INT 21h

    MOV DL, ':'  ; 显示冒号分隔符
    INT 21h
    
    MOV DL, diff_minute ; 显示分钟差值
    ADD DL, '0'   ; 转换为ASCII码
    INT 21h

    MOV DL, ':' ; 显示冒号分隔符
    INT 21h

    MOV DL, diff_second ; 显示秒差值
    ADD DL, '0'   ; 转换为ASCII码
    INT 21h

    MOV AH, 4Ch  ; 功能号4Ch - 程序终止
    INT 21h

  MAIN ENDP
END MAIN