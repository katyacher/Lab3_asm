# Хорошко Е.М. ЗКИ21-БBB, Лабораторная работа 3_1,  вариант 12

.file "lab3.s" # имя файла (необязательно)
.global _start
.data
    arr: .quad 1, 2, 3, 4, 5		#gdb info variables
    	 .quad 6, 7, 8, 9, 10
    	 .quad 11, 12, 13, 14, 15
    	 .quad 16, 17, 18, 19, 20
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
    tmp: .quad 0, 0, 0, 0, 0		#gdb info variables
    	 .quad 0, 0, 0, 0, 0
    	 .quad 0, 0, 0, 0, 0
    	 .quad 0, 0, 0, 0, 0
    		
    msg: .ascii "Program search min and max in array NxM and swap cols and rows\n"
   
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
    movq $64, %rdx 		# кол-во выводимых символов
    syscall
 m:
    leaq arr, %rax		# arr[0]
    movq $return1, %rdi
    jmp max_proc
return1:
    leaq arr, %rax		# arr[0]
    movq $return2, %rdi
    jmp min_proc
return2:
    leaq arr, %rax		# arr[0]
    movq $return3, %rdi
    jmp swap_cols
return3:
    leaq arr, %rax		# arr[0]
    movq $return4, %rdi
    jmp swap_rows
return4:
    leaq arr, %rax		# arr[0]
    movq $10, %rcx
    movq $cols, %rbx
    movq $rows, %rsi
    movq $exit, %r9
    jmp swap_rows
exit:	
    movq %rbp, %rsp
    movq $60, %rax 	# exit
    movq $0, %rdi
    syscall
    
    
max_proc:
    # %rax - max элемент - при инициализации arr[0] -
    # %rcx - адрес текущего элемента 
    # %rdx - смещение ($cols*i + j)
    # %rbx - N*i*Larr , i = from 0 to M-1 - i - rows
    # %rsi - j, j = from 0 to N-1 - j - cols
    
    #movq $arr, %rax		# max элемент  в max_proc через %rax
   # movq $elemSize, %rsi
    movq %rax, %rcx	
    addq $8, %rcx  # адрес текущего элемента (%rax + elemSize)
    
    xorq %rbx, %rbx		# i = 0
    outer_max_loop: 		   			
        xorq %rsi, %rsi	# j = 0
    inner_max_loop:		 	
        # вычислим смещение
        xorq %rdx, %rdx	# %rdx = 0
        movq %rbx, %rdx	# в %rdx индекс строки - i 
        imulq $cols, %rdx	# cols * i
        addq %rsi, %rdx	# cols * i + j    
        #imulq $elemSize, %rdx # (cols*i + j)*elemSize 
        # сравним текущий элемент и следующий = base_adr + (cols*i + j)*elemSize + elemSize
        #addq %rdx, %rcx	# base_adr + (cols*i + j)*elemSize + elemSize
         # сравним максимальный элемент и следующий 
        movq (%rcx, %rdx,8), %rcx
        cmpq *(%rcx), *(%rax) 
        jna next_max
        # если следующий больше, обновим максимум, сохраним индексы
        movq %rcx, %rax 
        movq %rbx, i_max 		# индекс строки максимального элемента
        movq %rsi, j_max		# индекс столбца максимального элемента
    next_max: 
    	incq %rsi 		# j++
      	cmpq $cols, %rsi
      	je inner_max_end
      	jmp inner_max_loop
    inner_max_end:
      	incq %rbx		# i++
      	cmpq $rows, %rbx 
      	je max_proc_End
      	jmp outer_max_loop

    max_proc_End:
    	movq $i_max, %rax
    	incq %rax
    	movq %rax, i_max
    	movq $j_max, %rax
    	incq %rax
    	movq %rax, j_max
      	jmp *%rdi 		# перейти на адрес возврата, сохраненный в rdi
      	
min_proc:
    # %rax - max элемент - при инициализации arr[0]
    # %rcx - адрес текущего элемента 
    # %rdx - смещение ($cols*i + j)
    # %rbx - i = from 0 to rows-1 (M-1) индекс строки
    # %rsi - j = from 0 to cols-1 (N-1) индекс столбца
    
    #movq arr, %rax		# max элемент  в max_proc через %rax
    #movq $elemSize, %rsi
    movq %rax, %rcx	
    addq $8, %rcx  # адрес текущего элемента (%rax + elemSize)
    
    xorq %rbx, %rbx		#  i = 0
    outer_min_loop: 		
        xorq %rsi, %rsi	#  j = 0
    inner_min_loop:		 	 
        # вычислим смещение
        xorq %rdx, %rdx	# %rdx = 0
        movq %rbx, %rdx	# в %rdx индекс строки - i 
        imulq $cols, %rdx	# cols * i
        addq %rsi, %rdx	# cols * i + j    
        # сравним текущий элемент и следующий = base_adr + (cols*i + j)*elemSize + elemSize
        cmpq (%rcx, %rdx, 8), %rax 
        jnb next_min
        # если следующий больше, обновим максимум, сохраним индексы
        movq (%rcx, %rdx, 8), %rax 
        movq %rbx, i_min 		# индекс строки максимального элемента
        movq %rsi, j_min		# индекс столбца максимального элемента
    next_min: 
    	incq %rsi 		# j++
      	cmpq $cols, %rsi
      	je inner_min_end
      	jmp inner_min_loop
    inner_min_end:
      	incq %rbx		# i++
      	cmpq $rows, %rbx 
      	je min_proc_End
      	jmp outer_min_loop

    min_proc_End:
    	movq $i_max, %rax
    	incq %rax
    	movq %rax, i_max
    	movq $j_max, %rax
    	incq %rax
    	movq %rax, j_max
      	jmp *%rdi 		# перейти на адрес возврата, сохраненный в rdi
      	
swap_cols:
     # %rax - адрес массива
     # %rdx - смещение
     # %rbx - j_max/min
     # %rsi - i
     # %rcx - регистр для операции обмена
     xorq %rdx, %rdx
     xorq %rsi, %rsi		# j = 0
     swap_cols_loop:
     	movq $i_max, %rbx	# i = i_max
     	movq $cols, %rdx
     	imulq %rbx, %rdx
     	addq %rsi, %rdx
     	movq (%rax, %rdx, 8), %rcx
     	movq %rcx, tmp
     	
     	movq $i_min, %rbx	# i = i_min
     	movq $cols, %rdx
     	imulq %rbx, %rdx
     	addq %rsi, %rdx
     	
     	movq tmp, %rcx
     	xchg %rcx, (%rax, %rdx, 8)
     	movq %rcx, tmp
     	
     	incq %rsi
     	cmpq $cols, %rsi
     	je swap_cols_loop_end
     	jmp swap_cols_loop
     swap_cols_loop_end:
     	jmp *%rdi 		# перейти на адрес возврата, сохраненный в rdi

swap_rows:
     # %rax - адрес массива
     # %rdx - смещение
     # %rbx - j
     # %rsi - i_max/min
     xorq %rdx, %rdx		
     xorq %rbx, %rbx		# i = 0
     swap_rows_loop:
     	movq $j_max, %rsi
     	movq $cols, %rdx
     	imulq %rbx, %rdx
     	addq %rsi, %rdx
     	movq (%rax, %rdx, 8), %rcx
     	movq %rcx, tmp
     	
     	movq $j_min, %rsi
     	movq $cols, %rdx
     	imulq %rbx, %rdx
     	addq %rsi, %rdx
     	
     	movq tmp, %rcx
     	xchg %rcx, (%rax, %rdx, 8)
     	movq %rcx, tmp
     	
     	incq %rbx
     	cmpq $rows, %rbx
     	je swap_rows_loop_end
     	jmp swap_rows_loop
     swap_rows_loop_end:
     	jmp *%rdi 		# перейти на адрес возврата, сохраненный в rdi
     	
print_arr:
    # %rax - адрес массива
    # %rcx - система счисления 10
    # %rbx - число столбцов - j
    # %rsi - число строк - i 
    # %r8 - начальное начальное значение счетчика кол-ва символов в итоговой строке
    movq $10, %rcx
    xorq %rbx, %rbx
    xorq %r8, %r8
    outer: 
        xorq %rsi, %rsi
        inner:
        movq arr, %rax
        movq $cols, %rdx
        imul %rsi, %rdx
        addq %rbx, %rdx
        movq (%rax, %rdx, 8), %rax
        
        movq $ret1, %rdi
	jmp to_str_proc
	ret1:
        
        subq $1, %rsp 	 	# выделить еще один байт в стеке под символ
	movb $32, 0(%rsp) 	# загрузить значение 'пробел' в стек
	addq $1, %r8		# увеличить счетчик символов в итоговой строке
        
        incq %rsi
        cmpq $cols, %rsi
        je inner_end
        jmp inner
        
        inner_end:
        subq $1, %rsp 	 	# выделить еще один байт в стеке под символ
	movb $92, 0(%rsp) 	# загрузить значение '\' в стек
	addq $1, %r8		# увеличить счетчик символов в итоговой строке
	subq $1, %rsp 	 	# выделить еще один байт в стеке под символ
	movb $110, 0(%rsp) 	# загрузить значение 'n' в стек
	addq $1, %r8		# увеличить счетчик символов в итоговой строке
	
	incq %rbx
	cmpq $rows, %rbx
	je outer_end
	jmp outer
    outer_end:
        # выведем результат на экран
        xorq %rsi, %rsi
        xorq %rdx, %rdx
	movq $0, %rdx
	movq $1, %rax 		# write
	movq $1, %rdi 		# cout
	movq %rsp, %rsi 	# адрес начала строки - в стеке сохранен результат z
	movq %r8, %rdx 	# кол-во выводимых символов
	syscall
        jmp *%r9 		# перейти на адрес возврата, сохраненный в rdi	 

to_str_proc:
    # параметры для подпрограммы to_str_proc:
    # %rax - число, которое нужно преобразовать в строку
    # %rcx - основание системы счисления  
    # %rsp - адрес левой границы стека
    # %rcx - начальное значение счетчика кол-ва символов в итоговой строке - %r8
    # %rdi - адрес возврата
    # преобразование числа из rax в строку и загрузка строки в стек 
 
	movq %rax, %r15 	# сохраним число для проверки на отрицательность в конце цикла
	# проверить на отрицательность число
	cmpq $0, %rax
	jge to_str_loop		# если число больше или равно нулю, войти в цикл
		# преобразовать отрицательное значение в положительное 
		notq %rax 		# инвертировать значение всех битов
		addq $1, %rax		# прибавить 1
to_str_loop: 
	xorq %rdx, %rdx 	# обнуление регистров
	div %rbx	 	# произвести целочисленное деление %rax/%rbx - остаток в %rdx (в младшем байте)
	addb $48, %dl	 	# преобразуем цифру в код символа
	cmpb $58, %dl		# если %dl < 58 
	jb d			# то прибавлять не нужно
	addb $39, %dl		# преобразовать в букву 16-ти ричной системы, только если %dl не меньше 58
	d: 
	subq $1, %rsp 	 	# выделить еще один байт в стеке под символ
	movb %dl, 0(%rsp) 	# загрузить значение в стек
	addq $1, %r8		# увеличить счетчик символов в итоговой строке
	cmpq $0, %rax		# 
	je to_str_loop_end	# выйти из цикла
	jmp to_str_loop	# перейти в начало цикла
to_str_loop_end:
	cmpq $0, %r15		# было ли отрицательным число
	jge to_str_proc_end	# если число больше или равно, переходим в конец процедуры
		# если число отрицательное - загрузим и допишем в строку знак "-"
		subq $1, %rsp		# выделить байт на стеке
		movb $45, 0(%rsp)	# загрузить символ "-"
		addq $1, %rcx		# увеличить счетчик символов в итоговой строке
to_str_proc_end:
	jmp *%rdi 		# перейти на адрес возврата, сохраненный в rdi
	
     
