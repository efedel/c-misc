#include <stdio.h>
#include "disasm_ret.c"

/* for each string element we -0x20 to 'encrypt', then +2= */
void my_func( void ) {
	printf("my fun!\n");
	return;
}

	
int main(int argc, char **argv ) {
	DISASM_FALSERET
	return(0);
}
