# Хорошко Е.М. ЗКИ21-БBB, Лабораторная работа 3_2,  вариант 12
.file "lab3_string.s" # имя файла (необязательно)
.global main

.data
    msg: .ascii "Program delete last word in the string\n"
.text

main:
    # выведем строку msg на экран
    movq $1, %rax 		# sys_write
    movq $1, %rdi 		# стандартная консоль
    movq $msg, %rsi 		# адрес начала строки
    movq $40, %rdx 		# кол-во выводимых символов
    syscall

exit:	
    movq %rbp, %rsp
    movq $60, %rax 	# exit
    movq $0, %rdi
    syscall
    
