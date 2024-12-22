.file "main.s"
.global main

.data
    .Lc0: .ascii " %s \0" # форматная строка с нулевым байтом в конце строки
     s: .space 10, 0
     n: .string "\n"
.text
  
main: 
    pushq %rbp 		# для выравнивания стека по 16-байтовой границе
    movq %rsp, %rbp 		# для создания фрейма стека ф-ии main
    
    subq $48, %rsp 		# выделить в стеке 32 байта перед вызовом функции
    
    leaq .Lc0(%rip), %rdi 	# адрес начала форматной строки
    leaq s(%rip), %rsi		# адрес сохранения введённой строки
    movq $0, %rax
    callq scanf 		# вызов функции scanf
    
    xorq %rax, %rax
    leaq .Lc0(%rip), %rdi 	# адрес начала форматной строки
    leaq s(%rip), %rsi		# само выводимое значение x = 
    callq printf		#вызов функции printf
    
   
    leaq .Lc0(%rip), %rdi 	# адрес начала форматной строки
    leaq n(%rip), %rsi		#само выводимое значение \n
    callq printf		#вызов функции printf
    
    movq %rbp, %rsp	#освобождение стека функции main
    
    popq %rbp		# восстановление регистра %rbp
    mov $0, %eax
    retq
   
   
