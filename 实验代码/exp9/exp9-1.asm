DATA SEGMENT
    RATETABLE DW 524,588,660,698,784,880,988,1048             ;频率表
    MSG       DB 'Please input char 1 ~ 8'                    ;提示信息
              DB 'to get the corresponding voice!',0ah,0dh
              DB 'Quit with (ctrl C):',0ah,0dh,'$'
DATA ENDS

STCK SEGMENT STACK
         db 100 DUP(?)
STCK ENDS

CODE SEGMENT
                  ASSUME CS:CODE,DS:DATA
    START:        
                  MOV    AX,DATA            ;
                  MOV    DS,AX              ;

                  LEA    DX,MSG             ;        输出提示信息
                  MOV    AH,09H             ;
                  INT    21H                ;
    ;输入音符
    INPUT:        
                  MOV    AH,01H             ;
                  INT    21H                ;
  
                  CMP    AL,03H             ;        若输入(ctrl + c),则退出程序
                  JZ     QUIT

                  CMP    AL,'1'
                  JGE    l1
                  JMP    INPUT
    L1:           
                  CMP    AL,'8'
                  JG    INPUT
                  CALL   PIANOFUC           ;     调用程序,根据输入音符发出相应声音
                  JMP    INPUT

    ;退出程序
    QUIT:         
                  MOV    AH,4CH             ;
                  INT    21H                ;
 
    ;子程序名：PIANOFUC
    ;功能：    将AL寄存器中字符1、2、3、4、5、6、7、i的ASCII作为音符
    ;          查频率表(RATETABLE),使扬声器发出不同频率的声音
PIANOFUC PROC
                  PUSH   BX                 ;
                  PUSH   AX                 ;
                  PUSH   DX                 ;
                  
                  XOR    AH,AH
                  SUB    AL,'0'
                  SUB    AL,1
                  MOV    DI,AX
                  ADD    DI,DI
                  MOV    BX,DI

    OUT_VOI:      
  
                  MOV    AX,348CH           ;           常数1193100D做被除数
                  MOV    DX,0012H           ;
  
                  DIV    RATETABLE[BX]      ;      计算填入数值
                  MOV    BX,AX              ;        
  
                  MOV    AL,10110110B       ;       对计时器2进行初始化，设为模式3，读写低、高位
                  OUT    43H,AL
  
                  MOV    AX,BX              ;
                  OUT    42H,AL             ;             设置低位
  
                  MOV    AL,AH              ;              设置高位
                  OUT    42H,AL
  
                  IN     AL,61H             ;             打开发声与门
                  OR     AL,03H             ;
                  OUT    61H,AL
  
                  CALL   DELAY  ;设置延迟
  
                  IN     AL,61H             ;             关闭与门
                  AND    AL,0FCH            ;
                  OUT    61H,AL             ;

    ;退出程序
    QUIT_PIANOFUC:
                  POP    DX
                  POP    AX
                  POP    BX                 ;
                  RET
PIANOFUC ENDP
 
 
 
 
    ;子程序名：DELAY
    ;功能：    延迟一定时间
DELAY PROC
                  PUSH   CX
                  MOV    CX,03H             ;
    DELAYLOOP1:   
                  PUSH   CX                 ;
  
                  MOV    CX,0FFFFH
    DELAYLOOP2:   
                  LOOP   DELAYLOOP2
  
                  POP    CX                 ;
                  LOOP   DELAYLOOP1
  
                  POP    CX
                  RET
DELAY ENDP
 
CODE ENDS
     END START