data segment
    mess1     db 'Enter keyword:','$'
    mess2     db 'Enter sentence:','$'
    mess3     db 'Match at location:','$'
    mess4     db 'No MATCH.','$'
    mess5     db 'H of the sentence.','$'
    Max1      db 100
    Act1      db ?
    keyword   db 100 dup(?)
    Max2      db 100
    Act2      db ?
    Sentence  db 100 dup(?)
    ChangeRow db 0DH,0ah,'$'
    diff      dw 0
    location  db 0
data ends

stack segment
          dw 128 dup(?)
stack ends

code segment
                assume cs:code,ds:data,ss:stack
    start:      
                mov    ax,data
                mov    ds,ax

                lea    dx,mess1
                mov    ah,09h
                int    21h
    
                lea    dx,max1
                mov    ah,0ah
                int    21h

    ;keyword为0，则退出
                cmp    Act1,0
                je     exit

    input:      
                sub    ax,ax
                sub    bx,bx
                sub    cx,cx
                sub    dx,dx
                call   change
                lea    dx,mess2
                mov    ah,09h
                int    21h

                lea    dx,max2
                mov    ah,0ah
                int    21h
                
                call   change
                mov    al,Act1                     ;length of keyword
                CBW
                mov    cx,ax
                mov    al,Act2                     ;length of sentence
                cmp    al,0
                je     exit
                sub    al,Act1

                CBW
                mov    diff,ax
                js     no_match

                lea    bx,Sentence
                mov    di,0
                mov    si,0
    loop_inside:
                mov    ah,[bx+si]
                cmp    ah,keyword[di]
                jne    next
                inc    di
                inc    si
                loop   loop_inside
    succ:       
    
                sub    si,di
                inc    si
                lea    dx,mess3
                mov    ah,09h
                int    21h

                mov    bx,si
                
                push   ax
                push   bx
                push   cx
                push   dx
                call   btoh
                pop    dx
                pop    cx
                pop    bx
                pop    ax

                lea    dx,mess5
                mov    ah,09h
                int    21h
                jmp    input

    next:       
                push   ax
                sub    si,di
                inc    si
                cmp    diff,si
                jl     no_match
                mov    di,0
                mov    al,Act1
                CBW
                mov    cx,ax
                pop    ax
                jmp    loop_inside

btoh PROC NEAR
                MOV    CH,4
    rotate:     MOV    CL,4
                ROL    BX,CL
                MOV    AL,BL
                and    AL,0fh
                add    AL,30h
                cmp    al,3ah
                jl     printit
                add    al,7h
    printit:    
                MOV    dl,al
                MOV    ah,2
                int    21h
                dec    ch
                jnz    rotate
                ret
btoh endp

    exit:       
                mov    ah,4ch
                int    21h

    no_match:   
                lea    dx,mess4
                mov    ah,09h
                int    21h
                jmp    input
change PROC far
                mov    dx,OFFSET ChangeRow
                mov    ah,09h
                int    21H
                RET
change ENDP
code ends
end start
