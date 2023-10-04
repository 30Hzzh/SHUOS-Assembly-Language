.model small
.stack 100h

.data
array db 10 dup(?)    ; 存储输入的数据
count db 0           ; 已输入数据的数量

.code
main proc
    mov ax, @data
    mov ds, ax

    ; 输入十个数据
    mov cx, 10
    mov ah, 01h     ; 设置输入功能为读取一个字符
input_loop:
    int 21h         ; 从键盘读取一个字符
    cmp al, 0Dh     ; 判断是否按下回车键
    je sort_array   ; 如果是回车键，则跳转到排序并输出数据的部分

    mov ah, 0       ; 将字符转换为数字
    sub al, 30h     ; ASCII码中的数字字符的值减去30h得到对应的数字
    mov [array+count], al   ; 将输入的数字存储在数组中
    inc count       ; 数组中已输入数据的数量加一

    loop input_loop ; 继续读取下一个字符

sort_array:
    ; 使用冒泡排序对数组进行升序排序
    mov cx, count
    dec cx          ; 循环次数为已输入数据的数量减一
    mov bx, cx      ; 保存循环次数的副本

sort_loop:
    mov si, 0       ; 初始化数组索引
inner_loop:
    mov al, [array+si]   ; 获取当前索引位置的数据
    cmp al, [array+si+1] ; 比较当前位置和下一个位置的数据
    jbe next        ; 如果当前位置的数据小于等于下一个位置的数据，则跳过交换
    ; 交换当前位置和下一个位置的数据
    mov ah, [array+si+1]
    mov [array+si+1], al
    mov [array+si], ah

next:
    inc si          ; 索引加一
    loop inner_loop ; 继续比较下一个位置的数据

    loop sort_loop  ; 继续进行下一轮循环

    ; 输出排序后的数据
    mov si, 0
output_loop:
    mov dl, [array+si]   ; 获取当前索引位置的数据
    add dl, 30h     ; 将数字转换为ASCII字符
    mov ah, 02h     ; 设置输出功能为打印一个字符
    int 21h         ; 输出字符

    inc si
    cmp si, count   ; 检查是否已输出完所有数据
    jne output_loop ; 如果还有数据未输出，则继续循环

    mov ah, 4Ch     ; 设置功能号为程序退出
    int 21h         ; 调用DOS中断，程序退出

main endp
end main