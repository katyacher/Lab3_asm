.file "main.s"
.global _start
.data
     s_in_len: .quad 0
     s_in: .asciz "Test ghj tyuyfc nnb\0 bhvmmb\n"
     .balign 16
     s_out: .space 100, 0
     .balign 16
     .Lc0: .ascii "%s\0" 	# форматная строка с нулевым байтом в конце строки
     n: .string "\n"
     not_found: .asciz "Empty string\n"
.text
 _start:
  	
    pushq %rbp 		# для выравнивания стека по 16-байтовой границе
    movq %rsp, %rbp 		# для создания фрейма стека ф-ии main
    
    subq $16, %rsp 		# выделить в стеке 16 байт перед вызовом функции
    movq $0, %rax 		# read
    movq $1, %rdi 		# std<<cin
    leaq s_out(%rip), %rsi	# адрес сохранения введённой строки
    movq $100, %rdx 		# макс. кол-во вводимых символов
    movq $0, %rax
    syscall
    

    movq %rsi, %rdi  	 # загружаем адрес переменной s_out(%rip)
    #movq %rdi, %rsi      # копируем адрес в RSI для последующего поиска индекса
    movb $0, %al        # в AL символ для поиска   /* %al = 0 */
    movq $-1, %rcx      # максимальное число
    repne scasb         # ищем байт
    
    decq %rdi           # в %rdi-1 адрес конца строки
    movq %rdi, %rcx     # 
    subq %rsi, %rcx	 # вычислим длину строкм
    decq %rdi		 # в %rdi-1 адрес символа \n
    decq %rcx
    decq %rdi		  # в %rdi-1 адрес последнего введенного символа
    decq %rcx
 m:
    std # просмотрим строку с конца DF = 1
    movb $' ', %al 	# $32
    repe scasb         # ищем не пробел, повторять пока пробелл
    jnz found          # если символ кроме пробелла найден, устанавливается флаг нуля ZF
    jmp error  
found:
   # decq %rdi
   # movq %rdi, %rcx     # 
   # subq %rsi, %rcx	 # вычислим длину строкм
    repne scasb         # ищем пробел
    jz found2
    jmp print_str
found2:
    incq %rdi           # в %rdi+1 адрес пробелла
   # movq %rdi, %rcx     # 
   # subq %rsi, %rcx	 # вычислим длину строки
    movq $10, (%rdi)	 # запишем на это место символ конца строки
    incq %rdi           # 
    movq $0, (%rdi)	 # запишем на это место символ конца строки
    cld
print_str:
    subq %rsi, %rdi	 # вычислим длину строкм
    cmpq $0, %rdi
    je error
    incq %rcx
    incq %rcx
    movq $1, %rax
    movq $1, %rdi
    leaq s_out(%rip), %rsi
    movq %rcx, %rdx
    syscall
    jmp exit
    
error:
    movq $1, %rax 		# write
    movq $1, %rdi 		# std<<cin
    leaq not_found(%rip), %rsi	# адрес сохранения введённой строки
    movq $13, %rdx 		# макс. кол-во вводимых символов
    syscall
	
exit: 	
    movq  %rbp, %rsp
    popq  %rbp
 	
    mov     $60, %rax               # system call 60 is exit
    xor     %rdi, %rdi              # we want return code 0
    syscall                         # invoke operating system to exit
  #retq
  

