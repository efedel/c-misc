
#include <stdio.h>


#define DBG_RESET_TRACE \
	asm ( "	pushl	%edx			\n"	\
	      "	pushfl				\n"	\
	      "	popl	%edx			\n"	\
	      "	andl	$0xFFFFFF7F, %edx	\n"	\
	      "	pushl	%edx			\n"	\
	      "	popfl				\n"	\
	      "	popl	%edx			\n" );	


int main( int argc, char **argv ) {
	int x;

	asm( "	int $3	\n");
	for ( x=0; x < 10; x++ ) {
		DBG_RESET_TRACE
		printf("y\n");
	}
	return(0);
}	
