
#define DISASM_FALSERET					\
	asm( 						\
		"	pushl	%ecx             \n"	\
		"	pushl	%ebx             \n"	\
		"	pushl	%edx             \n"	\
		"	movl	%esp, %ebx	 \n"	\
		"	movl	%ebp, %esp	 \n"	\
		"	popl	%ebp		 \n"	\
		"	popl	%ecx		 \n"	\
		"	movl	0f, %edx        \n"	\
		"	pushl	%edx		 \n"	\
		"	ret                      \n"	\
		"	.byte	0x0F             \n"	\
		"0:                              \n"	\
		"	pushl	%ecx		 \n"	\
		"	pushl	%ebp		 \n"	\
		"	movl	%esp,	%ebp     \n"	\
		"	movl	%ebx,	%esp	 \n"	\
		"	popl	%edx             \n"	\
		"	popl	%ebx             \n"	\
		"	popl	%ecx             \n"	\
	);
