

#define NULLPAD_START				\
	asm ( "	pushl   %eax       \n"		\
              "	movl    %esp, %eax \n" );

#define NULLPAD					\
	asm ("	addb    %al, (%eax)  \n");

#define NULLPAD_END				\
	asm ("	popl    %eax         \n");

#define NULLPAD_10				\
	NULLPAD_START				\
	NULLPAD					\
	NULLPAD					\
	NULLPAD					\
	NULLPAD					\
	NULLPAD					\
	NULLPAD_END
