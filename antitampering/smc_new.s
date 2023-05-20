	.file	"smc_new.c"
	.version	"01.01"
gcc2_compiled.:
.globl buf
.data
	.type	 buf,@object
buf:
	.byte	 85
	.byte	 137
	.byte	 229
	.byte	 144
	.byte	 201
	.byte	 195
	.size	 buf,6
.text
	.p2align 2,0x90
.globl dummy
		.type		 dummy,@function
dummy:
	pushl %ebp
	movl %esp,%ebp
	subl $24,%esp
	movl $1,-8(%ebp)
	movl $0,-4(%ebp)
	.p2align 2,0x90
.L7:
	cmpl $11,-4(%ebp)
	jle .L10
	jmp .L8
	.p2align 2,0x90
.L10:
	movl -4(%ebp),%eax
	addl %eax,-8(%ebp)
.L9:
	incl -4(%ebp)
	jmp .L7
	.p2align 2,0x90
.L8:
	xorl %eax,%eax
	jmp .L6
.L6:
	leave
	ret
.Lfe1:
		.size		 dummy,.Lfe1-dummy
	.p2align 2,0x90
.globl dummy_end
		.type		 dummy_end,@function
dummy_end:
	pushl %ebp
	movl %esp,%ebp
	jmp .L11
	.p2align 2,0x90
.L11:
	leave
	ret
.Lfe2:
		.size		 dummy_end,.Lfe2-dummy_end
	.p2align 2,0x90
.globl smc_decode
		.type		 smc_decode,@function
smc_decode:
	pushl %ebp
	movl %esp,%ebp
	subl $8,%esp
	addl $-8,%esp
	pushl $1
	pushl $512
	call calloc
	addl $16,%esp
	movl %eax,%eax
	movl %eax,code_buffer
	addl $-4,%esp
	pushl $6
	pushl $buf
	movl code_buffer,%eax
	pushl %eax
	call memcpy
	addl $16,%esp
	movl $1,%eax
	jmp .L12
	.p2align 2,0x90
.L12:
	leave
	ret
.Lfe3:
		.size		 smc_decode,.Lfe3-smc_decode
	.section	.rodata
.LC0:
	.byte	 0x41,0x41,0x41,0x41,0x41,0x0
.LC1:
	.byte	 0x61,0x62,0x63,0x64,0x65,0x66,0x67,0x68,0x69,0x6a
	.byte	 0x6b,0x6c,0x6d,0x6e,0x6f,0x70,0x71,0x72,0x73,0x74
	.byte	 0x75,0x76,0x77,0x78,0x79,0x7a,0x0
.text
	.p2align 2,0x90
.globl blow
		.type		 blow,@function
blow:
	pushl %ebp
	movl %esp,%ebp
	subl $4272,%esp
	pushl %edi
	pushl %esi
	leal -4176(%ebp),%eax
	movl .LC0,%edx
	movl %edx,-4176(%ebp)
	movzwl .LC0+4,%eax
	movw %ax,-4172(%ebp)
	leal -4204(%ebp),%eax
	leal -4204(%ebp),%edi
	movl $.LC1,%esi
	cld
	movl $6,%ecx
	rep
	movsl
	movsw
	movsb
	leal -4252(%ebp),%eax
	movl $1112297303,-4252(%ebp)
	movl $1179210568,-4248(%ebp)
	addl $-4,%esp
	pushl $5
	leal -4176(%ebp),%eax
	pushl %eax
	leal -4168(%ebp),%eax
	pushl %eax
	call blf_key
	addl $16,%esp
	addl $-4,%esp
	pushl $5
	leal -4244(%ebp),%eax
	pushl %eax
	leal -4168(%ebp),%eax
	pushl %eax
	call blf_enc
	addl $16,%esp
	addl $-4,%esp
	pushl $1
	leal -4244(%ebp),%eax
	pushl %eax
	leal -4168(%ebp),%eax
	pushl %eax
	call blf_dec
	addl $16,%esp
	addl $-4,%esp
	pushl $4
	leal -4244(%ebp),%eax
	leal 8(%eax),%edx
	pushl %edx
	leal -4168(%ebp),%eax
	pushl %eax
	call blf_dec
	addl $16,%esp
	addl $-4,%esp
	addl $-12,%esp
	leal -4204(%ebp),%eax
	pushl %eax
	call strlen
	addl $16,%esp
	movl %eax,%eax
	movzwl %ax,%edx
	pushl %edx
	leal -4204(%ebp),%eax
	pushl %eax
	leal -4168(%ebp),%eax
	pushl %eax
	call blf_key
	addl $16,%esp
	addl $-4,%esp
	pushl $1
	leal -4252(%ebp),%eax
	pushl %eax
	leal -4168(%ebp),%eax
	pushl %eax
	call blf_enc
	addl $16,%esp
	addl $-4,%esp
	pushl $1
	leal -4252(%ebp),%eax
	pushl %eax
	leal -4168(%ebp),%eax
	pushl %eax
	call blf_dec
	addl $16,%esp
	xorl %eax,%eax
	jmp .L13
	.p2align 2,0x90
.L13:
	leal -4280(%ebp),%esp
	popl %esi
	popl %edi
	leave
	ret
.Lfe4:
		.size		 blow,.Lfe4-blow
	.p2align 2,0x90
.globl main
		.type		 main,@function
main:
	pushl %ebp
	movl %esp,%ebp
	subl $20,%esp
	pushl %ebx
	call smc_decode
	movl code_buffer,%eax
	movl %eax,-4(%ebp)
	movl -4(%ebp),%ebx
	call *%ebx
	call blow
	jmp .L14
	.p2align 2,0x90
.L14:
	movl -24(%ebp),%ebx
	leave
	ret
.Lfe5:
		.size		 main,.Lfe5-main
	.comm	code_buffer,4,4
	.comm	dummy_size,4,4
	.ident	"GCC: (GNU) c 2.95.4 20020320 [FreeBSD]"
