data segment
    array      db 100 dup(?)
    count      db 0
    num db 0
    change_row db 0DH,0ah,'$'
data ends

stack segment
          db 100 dup(?)
stack ends

code segment
               assume ds:data,ss:stack,cs:code
    start:     
               mov    ax,data
               mov    ds,ax
               mov    ax,stack
               mov    ss,ax
          
               mov    cx,10
               mov    ah,01h
               mov    si,0
               mov    bx,offset array
    InputLoop: 
               int    21h
               cmp    al,0dh
               je     deal

               mov    ah,0
               sub    al,30h
               mov    [bx+si],al
               inc    si
               mov    ah,01h
               loop   InputLoop
    deal:      
               mov    bx,offset count
               mov    [bx],si
               mov    cx,si
               dec    cx
    sort_array:
               push   cx
               mov    si,0
    loop1:     mov    bx,offset array
               mov    al,[bx+si]
               cmp    al,[bx+si+1]
               jle    next
               mov    dl,al
               mov    dh,[bx+si+1]
               mov    [bx+si],dh
               mov    [bx+si+1],dl
    next:      inc    si
               loop   loop1
               pop    cx
               loop   sort_array

    output:    
               mov    bx,offset count
               mov    cx,[bx]
               mov    bx,offset array
               mov    si,0
               mov    ah,02h
    loop2:     mov    dl,[bx+si]
               add    dl,30h
               int    21h
               mov    dl,' '
               int    21h
               inc    si
               loop   loop2
                call  change
    dd_num:   
                mov ah,01h
                int 21h
                cmp al,0dh
                je  output
                mov bx,offset count
                add [bx],1
                mov bx,offset num
                mov [bx],al
    find:
                mov bx,offset count
                mov cx,[bx]
                mov bx,offset array
                mov bx,offset array
                mov si,0
    loop3:
    
               mov    ah,4Ch
               int    21h

change PROC
               mov    bx,offset change_row
               mov    ah,09h
               int    21h
               ret
change ENDP
code ends
end start