# Хорошко Е.М. ЗКИ21-БBB, Лабораторная работа 3_1,  вариант 12

.file "lab3.s" # имя файла (необязательно)
.global _start
.data
    arr: .quad 1, 1, 1, 1, 5		#gdb info variables
    	 .quad 1, 1, 1, 1, 1
    	 .quad 1, 1, 1, 1, 1
    	 .quad 0, 1, 1, 1, 1
    arr_end: .quad 0
    elemSize: .quad 8
    #count: .quad (.-arr)/elemSize		#NxM - кол-во элементов
    rows: .quad 4				# N				
    cols: .quad 5				# M
    i_max: .quad 0					# rowIndex
    j_max: .quad 0					# colIndex
    i_min: .quad 0					# rowIndex
    j_min: .quad 0					# colIndex
    max: .quad 0
    min: .quad 0
    tmp: .quad 0
    adr_tmp: .long 0
    	
    msg: .ascii "Program search min and max in array NxM and swap cols and rows\n"
    msg1: .ascii "Swap rows\n"
    msg2: .ascii "Swap cols\n"
    s: .string "\n"
    Lc0: .ascii "%s\0"
		
.text

_start:
    pushq %rbp 
    movq %rsp, %rbp 	# сохраняем начальное значение указателя стека в rbp
 
    # выведем строку msg на экран
    movq $1, %rax 		# sys_write
    movq $1, %rdi 		# стандартная консоль
    movq $msg, %rsi 		# адрес начала строки
    movq $63, %rdx 		# кол-во выводимых символов
    syscall
 	
    movq $10, %rcx
    movq $max_min, %r9
    jmp print_arr
max_min:
    movq $return1, %rdi
    jmp max_proc
return1:
   
    movq $return2, %rdi
    jmp min_proc
return2:
	
    leaq arr, %rax		# arr[0]
    movq $swp_prt, %rdi
    jmp swap_cols
swp_prt:
    # выведем строку msg на экран
    movq $1, %rax 		# sys_write
    movq $1, %rdi 		# стандартная консоль
    movq $msg1, %rsi 		# адрес начала строки
    movq $10, %rdx 		# кол-во выводимых символов
    syscall

    movq $10, %rcx
    movq $return3, %r9
    jmp print_arr	
return3:

    leaq arr, %rax		# arr[0]
    movq $swp_prt2, %rdi
    jmp swap_rows
swp_prt2:
     # выведем строку msg на экран
    movq $1, %rax 		# sys_write
    movq $1, %rdi 		# стандартная консоль
    movq $msg2, %rsi 		# адрес начала строки
    movq $10, %rdx 		# кол-во выводимых символов
    syscall
	
    movq $10, %rcx
    movq $exit, %r9
    jmp print_arr
    
exit:	
   
    movq %rbp, %rsp
    movq $60, %rax 	# exit
    movq $0, %rdi
    syscall
    
    
max_proc:
    # %rax - max элемент - при инициализации arr[0] -
    # %rcx - одномерный индекс  текущего элемента 
    # %rsi - одномерный индекс  максимального элемента
    
	xorq %rcx, %rcx	# счетчик
	xorq %rsi, %rsi	# индекс
        movq  arr, %rax        # max элемент в начале наибольшее значение — array[0] 
        movq  $arr+8, %rbx      # адрес текущего элемента массива 
                                   
        jmp   ch_bound         # проверить границы массива 
loop_max_start:

        cmpq  %rax, (%rbx)      # сравнить текущий элемент массива с max                                                     
        jle   less              # если текущий элемент массива меньше или равен наибольшему перейти на less               
        movq  (%rbx), %rax      # обновить максимум
        movq %rcx, %rsi 	
        incq %rsi 		# сохранить индекс максимального элемента %rcx + 1
                        
less:
        addq  $8, %rbx          # увеличить %rbx на размер одного элемента массива, 8 байт   
        incq %rcx               # увеличить счетчик      
ch_bound:
        cmpq  $arr_end, %rbx    # сравнить адрес текущего элемента и  адрес конца массива             
        jne    loop_max_start        # если они не равны, повторить цикл снова 

max_proc_End:
# преобразовать одномерный индекс в двумерный и сохранить в переменные
    xorq %rax, %rax
    xorq %rdx, %rdx
    movq %rsi, %rax
    movq cols, %rsi
    divq %rsi
    movq %rax, i_max
    movq %rdx, j_max
    jmp *%rdi 		# перейти на адрес возврата, сохраненный в rdi
      	
      	
min_proc:
     # %rax - min элемент - при инициализации arr[0] 
    # %rcx - одномерный индекс  текущего элемента 
    # %rsi - одномерный индекс  минимального элемента
  
	xorq %rcx, %rcx	
	xorq %rsi, %rsi		
        movq  arr, %rax        
        movq  $arr+8, %rbx     
        jmp   ch_bound2          
loop_min_start:                  
        cmpq  %rax, (%rbx)                                                               
        jge   greater              
        movq  (%rbx), %rax     
        movq %rcx, %rsi   
        incq %rsi                           
greater:
        addq  $8, %rbx           
        incq %rcx                        
ch_bound2:
        cmpq  $arr_end, %rbx                          
        jne    loop_min_start       

mix_proc_End:
    xorq %rax, %rax
    xorq %rdx, %rdx
    movq %rsi, %rax
    movq cols, %rsi
    divq %rsi
    movq %rax, i_min
    movq %rdx, j_min
    jmp *%rdi 			# перейти на адрес возврата, сохраненный в rdi
      	
swap_cols:
     # %rax - адрес эл массива
     # %rdx - адрес эл массива
     # %rbx - i_max/min смещение для max
     # %rsi - j
     # %rcx - смещение для min
     
  
     xorq %rsi, %rsi		# j = 0
   
     swap_cols_loop:
     	leaq arr, %rax
     	xorq %rdx, %rdx
     
     	movq i_max, %rbx	# rbx = i_max
     	imulq cols, %rbx	# rbx = rdi * i_max = i_max*cols
     	addq %rsi, %rbx 	# rbx = rsi + rbx = i_max*cols + j
     	imulq $8, %rbx 	# rsi = rbx*8 = (i_max*cols + j)*8
     	addq %rbx, %rax	# rax = rax + rbx = rax + (i_max*cols + j)*8
     	movq (%rax), %rdx	# max
     	
     	leaq arr, %rax
     	movq i_min, %rcx	# i = i_min
     	imulq cols, %rcx
     	addq %rsi, %rcx
     	imulq $8, %rcx
     	addq %rcx, %rax	
     		
     	movq (%rax), %rax	# min
     	movq %rdx, arr(,%rcx,1)
     	movq %rax, arr(,%rbx,1)

     	incq %rsi
     	cmpq cols, %rsi
     	jne swap_cols_loop
     swap_cols_loop_end:
     	jmp *%rdi 		# перейти на адрес возврата, сохраненный в rdi

swap_rows:

     xorq %rsi, %rsi		# i = 0
   
     swap_rows_loop:
     	leaq arr, %rax
     	xorq %rdx, %rdx
     
     	movq %rsi, %rbx	# rbx = i
     	imulq cols, %rbx 	# rbx = rbx * i = i *cols
     	addq j_max, %rbx 	# rbx = rsi + rbx = i*cols + j_max
     	imulq $8, %rbx 	# rbx = rbx*8 = (i*cols + j_max)*8
     	addq %rbx, %rax	# rax = rax + rbx = rax + (i*cols + j_max)*8
     	movq (%rax), %rdx	# max
     	
     	leaq arr, %rax
     	movq %rsi, %rcx	# i = i_min
     	imulq cols, %rcx
     	addq j_min, %rcx
     	imulq $8, %rcx
     	addq %rcx, %rax	
     		
     	movq (%rax), %rax	# min
     	movq %rdx, arr(,%rcx,1)
     	movq %rax, arr(,%rbx,1)

     	incq %rsi
     	cmpq rows, %rsi
     	jne swap_rows_loop
     swap_rows_loop_end:
     	jmp *%rdi 		# перейти на адрес возврата, сохраненный в rdi


	
print_arr:

	xorq %r8, %r8		# счетчик символов в итоговой строке
	xorq %rsi, %rsi	# индекс элемента массива
       # movq  arr, %rax        # max элемент в начале наибольшее значение — array[0] 
        movq  $arr_end-8, %rbx      # адрес текущего элемента массива                          
        jmp   arr_bound         # проверить границы массива 
        subq $1, %rsp 	 	# выделить  один байт в стеке под символ
        movb $10, 0(%rsp)	 # "\n" в %rsp
	addq $1, %r8		# увеличить счетчик символов в итоговой строке
loop:

        # преобразовать число в строку и запушить в стек                                                    
        movq (%rbx), %rax
        movq $10, %rcx
        
        movq $ret1, %rdi
	jmp to_str_proc
	ret1:     
        	
        subq $1, %rsp 	 	# выделить еще один байт в стеке под символ
        movb $32, 0(%rsp)	 # " " в %rsp
	addq $1, %r8		# увеличить счетчик символов в итоговой строке	
        	
        incq %rsi 		# сохранить индекс элемента %rcx + 1
        movq %rsi, %rax
        movq cols, %rdi
        xorq %rdx,%rdx
        divq %rdi
        cmpq $0, %rdx           
	jne n_add       
        subq $1, %rsp 	 	# выделить еще один байт в стеке под символ
        movb $10, 0(%rsp)	 # "\n" в %rsp
	addq $1, %r8		# увеличить счетчик символов в итоговой строке
n_add:	
	subq  $8, %rbx          # увеличить %rbx на размер одного элемента массива, 8 байт 
            	
arr_bound:
        cmpq  $arr, %rbx    # сравнить адрес текущего элемента и  адрес конца массива             
        jge    loop        # если они не равны, повторить цикл снова 

# выведем результат на экран
      
    	addq $1, %rsp
        xorq %rsi, %rsi
        xorq %rdx, %rdx
	movq $0, %rdx
	movq $1, %rax 		# write
	movq $1, %rdi 		# cout
	movq %rsp, %rsi 	# адрес начала строки - в стеке сохранен результат z
	movq %r8, %rdx 	# кол-во выводимых символов
	syscall
	
    movq $1, %rax 		# sys_write
    movq $1, %rdi 		# стандартная консоль
    movq $s, %rsi 		# адрес начала строки
    movq $1, %rdx 		# кол-во выводимых символов
    syscall
    jmp *%r9 		# перейти на адрес возврата, сохраненный в rdi	



to_str_proc: # преобразование числа из rax в строку и загрузка строки в стек 
    # параметры для подпрограммы to_str_proc:
    # %rax - число, которое нужно преобразовать в строку
    # %rcx - основание системы счисления  
    # %rsp - адрес левой границы стека
    # %r8 -  счетчик кол-ва символов в итоговой строке - %r8
    # %rdi - адрес возврата
    
 
	movq %rax, %r15 	# сохраним число для проверки на отрицательность в конце цикла
	# проверить на отрицательность число
	cmpq $0, %rax
	jge to_str_loop		# если число больше или равно нулю, войти в цикл
		# преобразовать отрицательное значение в положительное 
		notq %rax 		# инвертировать значение всех битов
		addq $1, %rax		# прибавить 1
to_str_loop: 
	xorq %rdx, %rdx 	# обнуление регистров
	div %rcx	 	# произвести целочисленное деление %rax/%rbx - остаток в %rdx (в младшем байте)
	addb $48, %dl	 	# преобразуем цифру в код символа
	cmpb $58, %dl		# если %dl < 58 
	jb d			# то прибавлять не нужно
	addb $39, %dl		# преобразовать в букву 16-ти ричной системы, только если %dl не меньше 58
	d: 
	subq $1, %rsp 	 	# выделить еще один байт в стеке под символ
	movb %dl, 0(%rsp) 	# загрузить значение в стек
	addq $1, %r8		# увеличить счетчик символов в итоговой строке
	cmpq $0, %rax		 
	je to_str_loop_end	# выйти из цикла
	jmp to_str_loop	# перейти в начало цикла
to_str_loop_end:
	cmpq $0, %r15		# было ли отрицательным число
	jge to_str_proc_end	# если число больше или равно, переходим в конец процедуры
		# если число отрицательное - загрузим и допишем в строку знак "-"
		subq $1, %rsp		# выделить байт на стеке
		movb $45, 0(%rsp)	# загрузить символ "-"
		addq $1, %r8		# увеличить счетчик символов в итоговой строке
to_str_proc_end:
	jmp *%rdi 		# перейти на адрес возврата, сохраненный в rdi
	
     
