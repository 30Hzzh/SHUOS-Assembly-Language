.8086
.MODEL small
.data
      dw 0,0
fun_table dw Quit,Play,History     ;代码的直接定址表，存放各功能代码块的偏移地址
music_table dw 494,524,588,660,698,784,880,950  ;数据的直接定址表，存放音符频率
menu  db 10,13,10,13,'*** MENU ***'
      db 10,13
      db 10,13,'  1. Play'
      db 10,13,'  2. History'
      db 10,13,'  0. Quit'
      db 10,13
      db 10,13,'please choose one of 0~2:','$'  
content db 100 dup(0)         ;存放输入按键的ASCII码
filename db 'history.txt',0    ;导出文件的文件名
handle dw ?                   ;导出文件的文件句柄
mess1  db 10,13,'please start your performance,exit with ctrl+c','$'
mess2  db 10,13,'Playing now......','$'
.stack 128
.code
;*****************************************************************
; 宏
; 功能：显示字符串
; 入口参数：字符串标号
; 出口参数：无
;*****************************************************************
show macro _Label
    lea dx,_Label  ;字符串标号
    mov ah,9
    int 21h
endm    

main proc
start: 
    mov ax,@data
    mov ds,ax
disp:
      show menu    
      mov ah,1
      int 21h            ;调用21h中断的第1号功能，从键盘读入字符，AL保存读入字符的ASCII码
      cmp al,30h
      jb no
      cmp al,32h
      ja no
      sub al,30h         ;将输入的ASCII码转为BCD码
      mov bl,al
      mov bh,0
      add bx,bx         ;数字乘2才是直接定址表中的标号的地址
      call word ptr fun_table[bx]  ;调用子程序
   no:jmp disp          ;重复显示菜单

;*****************************************************************
; 子程序：Play
; 功能：输入钢琴按键
; 入口参数：无
; 出口参数：无
;*****************************************************************
Play proc
    show mess1
    ;换行
    mov dl,0Dh
    mov ah,2
    int 21h
    mov dl,0Ah
    mov ah,2
    int 21h
    ;创建文件
    lea dx,filename
    mov cx,0
    mov ah,3ch
    int 21h           ;21号中断的3c号功能，用指定的文件名创建一个新文件
    mov handle,ax     ;保存文件句柄
    mov di,0
input:
     mov ah,00h
     int 16h
     cmp ah,2eh     ;按CTRL-C则退出钢琴状态,ah存储键盘扫描码
     je finish
     cmp al,'1'     ;al存储ascii码
     jb input
     cmp al,'8'
     ja input
     sub al,30h         ;将输入的ASCII码转为BCD码
     mov bl,al
     mov bh,0
     add bx,bx         ;数字乘2才是直接定址表中的标号的地址
     mov si,music_table[bx]
     call sound
     add di,2
     jmp input
finish: ;向文件中写入文本
    mov cx,100
    mov bx,handle
    lea dx,content      ;dx存储起始地址
    mov ah,40h          ;21号中断的40号功能
    int 21h
    ;关闭文件
    mov bx,handle
    mov ah,3eh
    int 21h
    jmp disp
Play endp

temp:     ;History里jmp的中转处
      jmp disp

;*****************************************************************
; 子程序：History
; 功能：播放之前弹奏的音乐
; 入口参数：无
; 出口参数：无
;*****************************************************************
History proc
    show mess2
    ;打开文件
    mov ah,3dh
    mov al,00h        ;只读 
    lea dx,filename
    mov handle,ax     ;保存文件句柄
    int 21h
    ;读取文件内容  
    mov ah,3fh  
    mov bx,handle  
    lea dx,content  
    mov cx,100  
    int 21h 
    ;关闭文件
    mov bx,handle
    mov ah,3eh
    int 21h     
    ;播放
    mov di,0
op: 
    mov al,content[di]
    cmp al,0
    je temp
    sub al,30h         ;将输入的ASCII码转为BCD码
    mov bl,al
    mov bh,0
    add bx,bx         ;数字乘2才是直接定址表中的标号的地址
    mov si,music_table[bx]
    call sound
    add di,2
    dec cx
    jmp op
    ret
History endp 

;*****************************************************************
; 子程序：sound
; 功能：产生音调
; 入口参数：si——音调频率 
; 出口参数： 
;*****************************************************************
sound proc
;演奏一个音符
;入口参数：si - 要演奏的音符的频率的地址
    push ax
    push dx
    push cx
    add al,30h
    mov content[di],al ;写入内存
    ;8253 芯片(定时/计数器)的设置
    mov al,0b6h    ;8253初始化
    out 43h,al     ;43H是8253芯片控制口的端口地址
    mov dx,12h
    mov ax,34dch
    div si ;计算分频值,赋给ax。[si]中存放声音的频率值。
    out 42h, al       ;先送低8位到计数器，42h是8253芯片通道2的端口地址
    mov al, ah
    out 42h, al       ;后送高8位计数器
    ;设置8255芯片, 控制扬声器的开/关
    in al,61h   ;读取8255 B端口原值
    mov ah,al   ;保存原值
    or al,3     ;使低两位置1，以便打开开关
    out 61h,al  ;开扬声器, 发声
    mov dx,12      ;保持di时长
wait1:
    mov cx, 28000
delay:
    nop
    loop delay
    dec dx
    jnz wait1
    mov al, ah         ;恢复扬声器端口原值
    out 61h, al

    pop cx
    pop dx
    pop ax
    ret
sound endp   

;*****************************************************************
; 子程序：Quit
; 功能：退出程序
; 入口参数：无
; 出口参数：无
;*****************************************************************
Quit  proc near
      mov ah,4ch
      int 21h
Quit  endp


main endp
      end start
