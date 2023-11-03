data segment
       max   db 255
       act   db ?
       table db 255 dup(?)
       N     db 0
       char  db 0
       sum   db 0
       ctrl  db 0DH,0AH,'$'
data segment

stack  segment
       dw   128 dup(?)
stack  ends
code segment
               assume cs:code,ds:data,ss:stack
       start: 
               mov    ax,data
               mov    ds,ax

               lea    dx,max
               mov    ah,0ah
               int    21h

       input:  
               mov    ah,1
               int    21h
               mov    char,al

               call   search
               mov    ah,02h
               mov    dl,char
               int    21h
               mov    dl,':'
               int    21h
               mov    dl,sum
               add    dl,30h
               int    21h
               lea    dx,ctrl
               mov    ah,09h
               int    21h
               jmp    input
search proc far

               mov    si,offset table
               mov    bx,offset table
               mov    al,act
               cbw
               add    bx,ax
               mov    sum,0
       search1:
               mov    al,[si]
               cmp    al,char
               jne    next
               inc    sum
       next:   
               inc    si
               cmp    si,bx
               jne    search1
               ret
search endp
code ends
end start