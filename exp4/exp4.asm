data segment
      MaxLength    db 255
      ActualLength db ?
      String       db 255 dup(?)
      letter       db 0
      digit        db 0
      space        db 0
      ChangeRow    db 0DH,0ah,'$'
data ends

stack segment
            dw 128  dup(?)
stack ends

code segment
             assume cs:code, ds:data, ss:stack
      start: 
             mov    ax, data
             mov    ds, ax
      ;input
             mov    dx, OFFSET MaxLength
             mov    ah, 0Ah
             int    21h
             call change
      deal:  
             mov    bx,OFFSET String
             mov    ch,0
             mov    cl,ActualLength
      count: 
             mov    al,[bx]
             call   check
             inc    bx
             loop   count
      ;output
             mov    dx,OFFSET letter
             mov    dl,letter
             add    dl,30h
             mov    ah,02h
             int    21h
            call change

             mov    dx,OFFSET digit
             mov    dl,digit
             add    dl,30h
             mov    ah,02h
             int    21h
             call change

             mov    dx,OFFSET space
             mov    dl,space
             add    dl,30h
             mov    ah,02h
             int    21h
             call change
                      
             mov    ah,4ch
             int    21h
            
check PROC
             cmp    al,'0'
             jge    next1
             inc    space
             RET
      next1: 
             cmp    al,'9'
             jg     next2
             inc    digit
             RET
      next2: 
             cmp    al,'A'
             jge    next3
             inc    space
             RET
      next3: 
             cmp    al,'Z'
             jg     next4
             inc    letter
             RET
      next4: 
             cmp    al,'a'
             jge    next5
             inc    space
             RET
      next5: 
             cmp    al,'z'
             jg     next6
             inc    letter
             RET
      next6: 
             inc    space
             RET
check ENDP
change PROC
             mov    dx,OFFSET ChangeRow
             mov    ah,09h
             int    21H
             RET
change ENDP
code ends
end start