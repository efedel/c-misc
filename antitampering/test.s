.global _start

_start:
	int3 
	int3

	movl %ebp, %esp
	popl %ebp
	shll	$1, %eax
	xorl	%ebx, %ebx
	lea	(%ebx,%eax,2), %eax
	int3
	int3
	movl $12, %ecx
	movl $0x08058dc0, %ebx
.L0:
	movb (%edx), %al
	movb %al, (%ebx)
	incl %ebx
	incl %edx
	loop .L0
	int3
	int3
	
	movl $4, %eax
	addl %edx, %eax
	movl (%eax), %eax
	movl %eax, 0x8058dc0(,1)

	int3
	int3
	test %eax, eax
	jz .L1
.L1:
	int3
	int3

	negl %eax
	jnc .L1
	int3 
	int3
	
	xorl %ebx, %ebx
	negl %eax
	rcl $3, %ebx
	movl .L2(, %ebx), %eax
	jmp *%eax
.L2:
	.long .L3
	.long .L4
.L3:
	nop
	nop
	int3
.L4:
	nop
	nop
	int3
	int3

	pushl   %ebp
	movl    %esp,%ebp
	movl    0x8(%ebp),%edx
	xorl    %eax,%eax
	nop
	nop
	movl %ebp, %esp
	popl %ebp

	int3
	int3
	
	pushl %ebx
	movl %ebp, %eax
	pushl %eax
	movl %esp, %eax
	movl %eax, %ebp
	pushl   %ebp
	xorl %eax, %eax

	nop
	nop
	movl %ebp, %ebx
	movl %ebx, %esp
	popl %ebx
	ret

