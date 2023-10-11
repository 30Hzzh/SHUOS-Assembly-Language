data segment
    ChangeRow db 0DH,0ah,'$'
data ends

stack segment
          dw 128  dup(0)
stack ends

code segment
            assume cs:code, ds:data, ss:stack
    start:  
            mov    ax, data
            mov    ds, ax
            mov    bx, 0
            mov    cx,000fH

    ctrl:   
            push   cx
            mov    cx, 0010H
    display:
            mov    dl,bl
            mov    ah,02H
            int    21H
            mov    dl,20H
            int    21H
            inc    bx
            sub    cx,1
            cmp    cx,0
            jne    display
            call   change
            pop    cx
            dec    cx
            cmp    cx,0
            jne    ctrl
    over:   
            mov    ax, 4c00h
            int    21h

    ;换行
change PROC
            mov    dx, offset ChangeRow
            mov    ah, 09h
            int    21h
            ret
change ENDP
code ends

end start
