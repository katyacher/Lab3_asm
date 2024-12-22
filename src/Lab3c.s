	.file	"Lab3.c"
	.text
	.globl	cols
	.data
	.align 4
	.type	cols, @object
	.size	cols, 4
cols:
	.long	5
	.globl	rows
	.align 4
	.type	rows, @object
	.size	rows, 4
rows:
	.long	4
	.globl	arr
	.align 32
	.type	arr, @object
	.size	arr, 80
arr:
	.long	1
	.long	2
	.long	3
	.long	4
	.long	5
	.long	6
	.long	7
	.long	8
	.long	9
	.long	10
	.long	11
	.long	12
	.long	13
	.long	14
	.long	15
	.long	16
	.long	17
	.long	18
	.long	19
	.long	20
	.globl	i_max
	.align 4
	.type	i_max, @object
	.size	i_max, 4
i_max:
	.long	3
	.globl	j_max
	.align 4
	.type	j_max, @object
	.size	j_max, 4
j_max:
	.long	4
	.globl	i_min
	.bss
	.align 4
	.type	i_min, @object
	.size	i_min, 4
i_min:
	.zero	4
	.globl	j_min
	.align 4
	.type	j_min, @object
	.size	j_min, 4
j_min:
	.zero	4
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$0, -8(%rbp)
	jmp	.L2
.L3:
	movl	i_max(%rip), %eax 	# значение i_max
	movl	-8(%rbp), %edx
	movslq	%edx, %rcx
	movslq	%eax, %rdx
	movq	%rdx, %rax	
	salq	$2, %rax   		# арифметически сдвиг - умножить на 2^2
	addq	%rdx, %rax
	addq	%rcx, %rax
	leaq	0(,%rax,4), %rdx
	leaq	arr(%rip), %rax
	movl	(%rdx,%rax), %eax
	movl	%eax, -4(%rbp)
	movl	i_min(%rip), %eax
	movl	i_max(%rip), %edi
	movl	-8(%rbp), %edx
	movslq	%edx, %rcx
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	addq	%rcx, %rax
	leaq	0(,%rax,4), %rdx
	leaq	arr(%rip), %rax
	movl	(%rdx,%rax), %ecx
	movl	-8(%rbp), %eax
	movslq	%eax, %rsi
	movslq	%edi, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	addq	%rsi, %rax
	leaq	0(,%rax,4), %rdx
	leaq	arr(%rip), %rax
	movl	%ecx, (%rdx,%rax)
	movl	i_min(%rip), %eax
	movl	-8(%rbp), %edx
	movslq	%edx, %rcx
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	addq	%rcx, %rax
	leaq	0(,%rax,4), %rcx
	leaq	arr(%rip), %rdx
	movl	-4(%rbp), %eax
	movl	%eax, (%rcx,%rdx)
	addl	$1, -8(%rbp)
.L2:
	movl	cols(%rip), %eax
	cmpl	%eax, -8(%rbp)
	jl	.L3
	movl	$0, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.2) 9.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
