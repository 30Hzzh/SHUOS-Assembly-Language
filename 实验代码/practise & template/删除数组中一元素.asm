
;指令CLD,功能是方向标志DF清零,
;位置指针SI或DI往正向(地址增大方向)移动,字串处理是由前往后; 

;相反的指令是 STD, 功能是方向标志DF置1
;,位置指针SI或DI往反向(地址减小大方向)移动,字串处理是由后往前

;scasw指令的功能是将目标寄存器（通常是AX寄存器）的内容与字符串中的每个元素逐个比较，
;直到找到匹配的值或搜索完整个字符串。在比较过程中，DI寄存器会按照方向标志位（DF）的设置递增或递减，
;以指示下一个要比较的字符串元素的位置。不相等时向下一个位置移动

;实现要把查找删除的数存在AX寄存器中。
DATAS SEGMENT
    LIST  DW 10,45h,345h,45h,189h,21h,2345h,5678h,100h,200h,189h
    ADDR1 DW 89H
DATAS ENDS

STACKS SEGMENT
           DB  200  dup(?)
           TOP LABEL WORD
STACKS ENDS

CODES SEGMENT
            ASSUME CS:CODES,ES:DATAS,SS:STACKS
    START:  
    ;将数据段中的数据加载到ES,DS中
            MOV    AX,DATAS
            MOV    ES,AX
            MOV    DS,AX
            MOV    DI,OFFSET LIST                 ; (di) = 0AH
            MOV    AX,ADDR1                       ;(ax) = 89H
            CLD                                   ;(di)向前移动
            PUSH   DI                             ; di 进栈，保存数组大小值
            MOV    CX,ES:[DI]                     ;cx表示要移动的次数
            ADD    DI,2                           ; 指向数组中的第一个元素
            REPNE  SCASW                          ;串扫描，当di指定的值跟ax中的值相等时，ZF=1,即满足JE/JZ
            JE     DELETE
            POP    DI
            JMP    SHORT EXIT
    DELETE: 
            JCXZ   DEC_CNT                        ;如果cx=0 ，即改动数组大小即可
    NEXT_EL:                                      ;cx是多少就移动多少次
            MOV    BX,ES:[DI]                     ;因为di是指向匹配的下一个，所以直接将di覆盖di-2
            MOV    ES:[DI-2],BX
            ADD    DI,2                           ;没完就继续
            LOOP   NEXT_EL
    DEC_CNT:
            POP    DI
            DEC    WORD PTR ES:[DI]
    EXIT:   
            MOV    AH,4CH
            INT    21H
CODES ENDS
    END START