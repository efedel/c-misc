
#include <stdio.h>

extern void jmp_tbl_if( void );
extern void jmp_tbl_else( void );

#define IF_ZERO( val )					\
	asm ( 	"\txorl %%ebx, %%ebx\n\t"			\
		"negl %%eax\n\t"				\
		"rcl $3, %%ebx\n\t"				\
		"movl 0f( , %%ebx ), %%eax \n\t"		\
		"jmp *%%eax \n"					\
		"0:\n\t"					\
		".long 1f\n\t"			\
		".long 2f\n"			\
		"1:\n"					\
		 : : "a" ( val ) : "%ebx" );

#define ELSE  			\
	asm ("\tjmp 3f\n\t"	\
		"2:\n" );

#define ENDIF  			\
	asm ( "3:\n");

void test_fn( void ) {
	IF_ZERO( 0 )
		printf("if!\n");
	ELSE
		printf("else!\n");
	ENDIF
	printf("out1\n");

}
int main( int argc, char **argv ) {

	int count;
	printf( "trying if\n");
	IF_ZERO( argc )
		printf("if!\n");
	ELSE 
		printf("else!\n");
	ENDIF

	printf("out1\n");
		

	test_fn();
	IF_ZERO( 0 )
		printf("if!\n");
	ELSE 
		printf("else!\n");
	ENDIF
	printf("out1\n");
	return(0);
}
