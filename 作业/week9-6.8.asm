data segment
    table    db 100 dup(?)
    nums     dw 0
    char     db ?
    char_num db 0
    change   db 13,10,'$'
    mess1    db 'Please input a string: ',13,10,'$'
    mess2    db 'input the char you want to search: ',13,10,'$'
data ends

code segment
                assume cs:code,ds:data
    start:      
                mov    ax,data
                mov    ds,ax

    begin:      
                mov    bx,0
                mov    cx,100             ;限定输入的字符数不超过100个
                lea    dx,mess1
                mov    ah,9
                int    21h
    input:      
                mov    ah,1
                int    21h

                cmp    al,13              ;输入的字符为回车时，结束输入
                jz     num
                mov    table[bx],al       ;将输入的字符存入table数组中
                inc    bx
                loop   input
    num:        
                mov    nums,bx            ;统计输入的字符数
    input_char:                           ;输入要查找的字符
                lea    dx,mess2
                mov    ah,9
                int    21h
    input1:     
                mov    ah,1
                int    21h
                cmp    al,13              ;输入的字符为回车时，结束输入
                jz     exit

                mov    char,al            ;调用搜索子程序查找出现次数
                call   search
                mov    dl,':'
                mov    ah,2
                int    21h

                xor    dl,dl              ;处理输出的数字，转化成16进制ascii码输出
                mov    dl,char_num
                add    dl,'0'
                cmp    dl,'9'
                jle    print
                add    dl,7
    print:      
                mov    ah,2
                int    21h
                call   change_line
                jmp    input_char
    exit:       
                mov    ah,4ch
                int    21h

search proc near
                mov    si,0
                mov    cx,nums
                mov    char_num,0
                mov    al,char
    loop1:      
                cmp    table[si],al
                jne    next
                inc    char_num
    next:       
                inc    si
                loop   loop1
                ret
search endp

change_line proc near
                mov    ah,9
                lea    dx,change
                int    21h
                ret
change_line endp

code ends
end start


