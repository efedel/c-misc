	.file	"wil.c"
	.version	"01.01"
gcc2_compiled.:
	.section	.rodata
.LC0:
	.byte	 0x76,0x61,0x6c,0x20,0x25,0x58,0x20,0x70,0x20,0x25
	.byte	 0x58,0x20,0x63,0x6f,0x75,0x6e,0x74,0x20,0x25,0x58
	.byte	 0xa,0x0
.text
	.p2align 2,0x90
.globl main
		.type		 main,@function
main:
	pushl %ebp
	movl %esp,%ebp
	subl $20,%esp
	pushl %ebx
	movl $16,-4(%ebp)
	movl $0,-8(%ebp)
	movl $0,-8(%ebp)
	.p2align 2,0x90
.L7:
	cmpl $11,-8(%ebp)
	jle .L10
	jmp .L8
	.p2align 2,0x90
.L10:
	movl -8(%ebp),%eax
	pushl %eax
	movl $printf,%edx
	movl %edx,%eax
	sarl $16,%eax
	cltd
	movl %edx,%ecx
	shrl $31,%ecx
	leal (%ecx,%eax),%ebx
	movl %ebx,%edx
	sarl $1,%edx
	leal (%edx,%edx),%ecx
	subl %ecx,%eax
	pushl %eax
	movl -4(%ebp),%eax
	pushl %eax
	pushl $.LC0
	call printf
	addl $16,%esp
.L9:
	incl -8(%ebp)
	jmp .L7
	.p2align 2,0x90
.L8:
.L6:
	movl -24(%ebp),%ebx
	leave
	ret
.Lfe1:
		.size		 main,.Lfe1-main
	.ident	"GCC: (GNU) c 2.95.4 20020320 [FreeBSD]"
