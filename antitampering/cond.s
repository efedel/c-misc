	.file	"cond.c"
	.version	"01.01"
gcc2_compiled.:
	.section	.rodata
.LC0:
	.byte	 0x74,0x72,0x79,0x69,0x6e,0x67,0x20,0x69,0x66,0xa
	.byte	 0x0
.LC1:
	.byte	 0x69,0x66,0x21,0xa,0x0
.LC2:
	.byte	 0x65,0x6c,0x73,0x65,0x21,0xa,0x0
.LC3:
	.byte	 0x6f,0x75,0x74,0x31,0xa,0x0
.text
	.p2align 2,0x90
.globl main
		.type		 main,@function
main:
	pushl %ebp
	movl %esp,%ebp
	subl $24,%esp
	addl $-12,%esp
	pushl $.LC0
	call printf
	addl $16,%esp
	movl 8(%ebp),%eax
#APP
		xorl %ebx, %ebx
		negl %eax
		rcl $3, %ebx
		movl jmp_tbl( , %ebx ), %eax
		jmp *%eax
	jmp_tbl:
		.long jmp_tbl_if
		.long jmp_tbl_else
	jmp_tbl_if:

#NO_APP
	addl $-12,%esp
	pushl $.LC1
	call printf
	addl $16,%esp
#APP
		
		jmp jmp_tbl_out
	jmp_tbl_else:

#NO_APP
	addl $-12,%esp
	pushl $.LC2
	call printf
	addl $16,%esp
#APP
	
	jmp_tbl_out:

#NO_APP
	addl $-12,%esp
	pushl $.LC3
	call printf
	addl $16,%esp
	xorl %eax,%eax
	jmp .L6
	.p2align 2,0x90
.L6:
	leave
	ret
.Lfe1:
		.size		 main,.Lfe1-main
	.ident	"GCC: (GNU) c 2.95.3 20010315 (release) [FreeBSD]"
