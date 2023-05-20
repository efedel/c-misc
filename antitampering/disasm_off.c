

#define DISASM_MISALIGN					\
	asm (						\
		"	pushl	%eax     \n"		\
		"	jz	.MIDINSN \n"		\
		"	.byte	0x0F     \n"		\
		".MIDINSN:               \n"		\
		"	popl	%eax     \n"		\
		);
