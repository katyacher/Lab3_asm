.globl main
.data
val1:
        .quad 100
val2:
        .quad 200
printf_format:
        .string "%i %i\n"


.text

main:
        pushq val1
        pushq val2
        pushq $printf_format
        call  printf
        addq  $12, %rsp
        
        movq val1, %rax
        xchg %rax, val2
        movq %rax, val1
 
        pushq val1
        pushq val2
        pushq $printf_format
        call  printf
        addq  $12, %rsp
        movq  $0, %rax
        
        retq
