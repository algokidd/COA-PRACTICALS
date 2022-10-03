;--------------------thisisitt Hacktoberfest #PR4-----

%macro print 2   ;macro to print
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro
//
%macro accept 2   ;macro to accept
mov rax,0
mov rdi,0
mov rsi,%1
mov rdx,%2
syscall
%endmacro

SECTION .data
msg1: db "Enter hex number: "
len1: equ $-msg1
msg2: db "BCD number: "
len2: equ $-msg2
msg3: db "Enter BCD number: "
len3: equ $-msg3
msg4: db "Hex number: "
len4: equ $-msg4
msg5: db "",10
len5: equ $-msg5
msg6: db "1. Hex to BCD ",10,"2. BCD to hex",10,"3. Exit",10,"Enter your choice",10
len6: equ $-msg6


SECTION .bss
num: resb 5
num1: resb 6
choice: resb 2
n: resb 1
count: resb 2
count1: resb 2
count2: resb 2
cnt: resb 2
result: resb 5
result1: resb 4
res: resb 8


SECTION .text
global _start
_start:
menu:
print msg6,len6
accept choice,2  ;accepts choice of the user
xor rdx,rdx
xor rax,rax
xor rcx,rcx
xor rbx,rbx
cmp byte[choice],31H
je ch1
cmp byte[choice],32H
je ch2
cmp byte[choice],33H
je exit

ch1:     ;to convert hex to BCD
print msg1,len1
accept num,5  ;input 4 digit hex number
call asc_hex4
mov byte[count],0
mov ax,bx
mov r14,result

loop1:
mov cx,00
mov bx,0AH
xor rdx,rdx
div bx   ;divide ax by bx
push dx  ;push remainder in stack
mov cx,ax
inc byte[count]
xor rdx,rdx
xor rax,rax
mov ax,cx  ;move quotient in ax
cmp ax,0
jnz loop1

hex_asc5:
pop ax  ;pop remainder from stack
add ax,30H  ;convert to ASCII
mov [r14],ax  ;store converted value in result
inc r14
dec byte[count]
jnz hex_asc5

print msg2,len2
print result,5  ;print the result
print msg5,len5
jmp menu

ch2:     ;to convert bcd to hex
print msg3,len3
accept num1,6  ;input 5 digit BCD number
call asc_hex5
mov byte[count],5
mov byte[count1],5
mov byte[cnt],4

xor rax,rax
xor rdx,rdx
mov eax,ebx
xor rbx,rbx

loop11:
mov dl,al
and dx,0Fh ;to get the lsb
push dx  ;push lsb in stack
shr eax,04  ;shift right to get next lsb
dec byte[count1]
jnz loop11

xor rcx,rcx
mov ecx,10
loop22:
xor rax,rax
xor rdx,rdx
pop ax  
;mov ecx,10
mov dl,[count]
dec dl
mov byte[cnt],dl

l_mul:
cmp byte[cnt],0
jz l_add
mul ecx  ;multiply eax with ecx
dec byte[cnt]
jmp l_mul

l_add:
add rbx,rax
dec byte[count]
jnz loop22

hex_asc4:  ;to convert result to ASCII
mov r9,result1
mov byte[count2],4
xor rdx,rdx
l1:
    rol bx,04H
    mov dl,bl
    and dl,0FH
    cmp dl,09H
    jbe l2
    add dl,07H
    l2:
    add dl,30H
    mov[r9],dl
    inc r9
    dec byte[count2]
    jnz l1

print msg4,len4
print result1,4  ;print the result
print msg5,len5
jmp menu


exit:
mov rax,60
mov rdi,1
syscall

asc_hex4: ;procedure to convert to 4 digit input to hex
mov ch,04
mov bx,00
mov r10,0
loop:
    mov al,[num+r10]
    cmp al,61H
    jb next
    sub al,57H
    jmp next2
next:
    cmp al,41h
    jb next1
    sub al,37H
    jmp next2
next1:
     sub al,30H
next2:
     shl bx,04H
     add bx,ax
     inc r10
     dec ch
     jnz loop
ret

asc_hex5:  ;procedure to convert to 5 digit input to hex
mov ch,05
mov ebx,00
mov r10,0
lp:
    mov al,[num1+r10]
    cmp al,61H
    jb nxt
    sub al,57H
    jmp nxt2
nxt:
    cmp al,41h
    jb nxt1
    sub al,37H
    jmp nxt2
nxt1:
     sub al,30H
nxt2:
     shl ebx,04H
     add ebx,eax
     inc r10
     dec ch
     jnz lp
ret


