#include <stdio.h>
#include <signal.h> 

/* unix & intel debugger detection via int3 */
/* cheap debugger detection */
/* this can be bypassed by 'signal SIGTRAP' in gdb */

#define DEBUGGER_PRESENT	(num_traps == 0)
int	num_traps = 0;

void dbg_trap(int signo) { 
	num_traps++;
	return;
}

int dbg_trap_detect( void ) {
	if ( signal(SIGTRAP, dbg_trap) == SIG_ERR ) 
		return(0);
	asm( "	int $3	\n" );
	return(1);
}

/* another cheap debugger protection: easily bypassed with 
   hardware breakpoints */
int dbg_check_int3( void * address ) {
	if ( *(volatile unsigned char *)address == 0xCC ) {
		return(1);
	}
	return(0);
}

#define DEFINE_DBG_SYM(name) 	asm( #name ": \n" )
#define USE_DBG_SYM(name)	extern void name(void)

int blah(void) {
	int x;
	

	DEFINE_DBG_SYM(blah_sense);
	for (x=0; x < 10; x++){
		printf("X!\n");
	}
	return(1);
}

USE_DBG_SYM(blah_sense);
int main( int argc, char **argv ) {
	int x;
	dbg_trap_detect();

	for ( x = 0; x < 10; x++ ) {
		if ( DEBUGGER_PRESENT ) 
			printf("being debugged!\n");
		else
			printf("y\n");
	}

	if ( dbg_check_int3(blah_sense) ){
		printf("being debugged: int3!\n");
	}

	return(0);
}	
