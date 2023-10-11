data segment
    mess1          db 'New name:(less than 15 letters)','$'
    mess2          db 'New phone number:(6 letters)','$'
    mess3          db 'Dou you want to search? (y/n)','$'
    mess4          db 0dh,0ah,'Name:','$'
    mess5          db 'Not found!','$'
    mess6          db 'How many numbers do you want to store?(less than 9)','$'
    mess7          db 'Wrong number!','$'
    mess8          db 'Wrong name','$'
    mess9          db 'Search successfully!','$'
    show           db 'Name           Phone number','$'
    changerow      db 0dh,0ah,'$'
    ;存储需要计入电话簿的姓名和电话号码
    max1           db 15
    act1           db ?
    name1          db 15 dup(?)
    max2           db 8
    act2           db ?
    phone_number   db 8 dup(?)
    ;开辟空间存储电话簿
    table          db 20 dup(21 dup(?))
    ;记录电话簿总数
    totnum         db ?
    ;存储输入需要查找的名字
    max3           db 15
    act3           db ?
    find_name      db 15 dup(?)
    ;查找成功时，存储查找到的信息
    found          db 21 dup(?),'$'
    now_address    dw 0                                                            ;记录当前存储位置
    search_address dw 0                                                            ;记录查找到的位置
    search_tot     db 0                                                            ;记录查找到的总数
data ends

data_seg segment
             db 20 dup(21 dup(?))
data_seg ends

stack segment
          dw 128 dup(?)
stack ends
code segment
                  assume cs:code,ds:data,es:data_seg,ss:stack
    start:        
    ;输入需要存储的电话总数
                  mov    ax,data
                  mov    ds,ax

                  lea    dx,mess6
                  mov    ah,9
                  int    21h
                  call   change

                  mov    ah,1
                  int    21h
                  call   change

                  sub    cx,cx
                  sub    al,30h
                  mov    cl,al
                  mov    totnum,cl
    ;循环获取输入的姓名和电话
    input:        
                  push   cx
                  call   input_name
                  call   input_number
                  pop    cx
                  loop   input
    ;查找循环体
    search:       
                  sub    ax,ax
                  sub    bx,bx
                  sub    cx,cx
                  sub    dx,dx
                  mov    search_tot,0
                  lea    dx,mess3
                  mov    ah,9
                  int    21h
                  call   change

                  mov    ah,1
                  int    21h

                  cmp    al,'y'
                  je     search1
                  cmp    al,'n'
                  je     exit
    exit:         
                  mov    ah,4CH
                  int    21H
    search1:      
                  lea    dx,mess4
                  mov    ah,9
                  int    21h
                  call   change

                  lea    dx,max3
                  mov    ah,0ah
                  int    21h
                  call   change

                  call   search_name
    ;查找子程序
search_name proc near
                  mov    search_address,bx
                  lea    bx,table
    ;新一轮查找，初始化各个参数
    search2:      
                  sub    cx,cx
                  mov    cl,act3
                  mov    di,0
                  mov    si,0
                  mov    bx,search_address
    ;逐位比对
    search3:      
                  mov    al,find_name[di]
                  cmp    al,table[bx+di]
                  jne    notfound
                  inc    di
                  inc    si
                  loop   search3
                  cmp    table[bx+di],' '
                  je     succ
                  jmp    notfound
    ;比对出错或者名字是别的名字的一部分，如果没找完电话簿，跳到下一条信息开始查找
    notfound:     
                  add    search_address,21
                  inc    search_tot
                  mov    dl,search_tot
                  cmp    dl,totnum
                  jl     search2

                  lea    dx,mess5
                  mov    ah,9
                  int    21h
                  call   change
                  jmp    search
    ;查找成功，输出信息，并回到查找循环体
    succ:         
                  lea    dx,mess9
                  mov    ah,9
                  int    21h
                  call   change

                  lea    dx,show
                  mov    ah,9
                  int    21h
                  call   change
                    
                  mov    bx,search_address
                  mov    cx,21
                  mov    di,0

    storefound:   
                  mov    al,table[bx+di]
                  mov    found[di],al
                  inc    di
                  loop   storefound

                  lea    dx,found
                  mov    ah,9
                  int    21h
                  call   change
                  jmp    search
search_name endp
    ;存储信息子程序
input_name proc near
                  lea    dx,mess1
                  mov    ah,9
                  int    21h
                  call   change

                  lea    dx,max1
                  mov    ah,0ah
                  int    21h
                  call   change

                  sub    bx,bx
                  mov    bl,act1
                  mov    cx,15
                  sub    cx,bx
    ;名字存储不够填充空格
    pushspace:    
                  mov    name1[bx],' '
                  inc    bx
                  loop   pushspace

                  mov    cx,15
                  mov    bx,now_address
                  mov    di,0

    storename:    
                  mov    al,name1[di]
                  mov    table[bx+di],al
                  inc    di
                  loop   storename

                  add    bx,15
                  mov    now_address,bx
                  ret
input_name endp
    ;存储电话号码子程序
input_number proc near
    input_number1:
                  lea    dx,mess2
                  mov    ah,9
                  int    21h
                  call   change

                  lea    dx,max2
                  mov    ah,0ah
                  int    21h
                  call   change

                  cmp    act2,6
                  jne    deal1

                  sub    cx,cx
                  mov    cx,6
                  mov    bx,now_address
                  mov    si,0
    storenumber:  
                  mov    al,phone_number[si]
                  mov    table[bx+si],al
                  inc    si
                  loop   storenumber
                  add    bx,6
                  mov    now_address,bx
                  ret
    ;电话号码位数不对，重新输入
    deal1:        
                  lea    dx,mess7
                  mov    ah,9
                  int    21h
                  call   change
                  jmp    input_number1
input_number endp
change PROC
                  mov    dx,OFFSET changerow
                  mov    ah,09h
                  int    21H
                  RET
change ENDP

code ends
end start