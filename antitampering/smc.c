/* neil.freeshell.org/soft.htm */

int start_smc();

int end_smc();

#define PAGE_SIZE 2048
#define PAGE_MASK (PAGE_SIZE -1)
if ( mprotect((void *)((long)start_mod & (~PAGE_MASK)), PAGE_SIZE <<1, PROT_READ | PROT_WRITE | PROT_EXEC) < 0 ) {
	//bragh!!!
}
else {
	fptr = start_mod;
	for ( x=0; x < size; x++ ) {
		/* bad!!!! */
		*(char *)(fptr + x) = *(code+x);
	}
}

/*note in woindows this is
VirtualProtect(address, size, PAGE_WRITECOPY, &old_state);
VirtualProtect(address, size, PAGE_EXECUTE, &old_state);

-- or --
*/

extern void start_mod( void );
extern void end_mod( void );
int my_nasty_func() {
	asm ("start_mod:\n");
	/* ... */
	asm ("end_mod:\n");
}

int patcher () {
	size = (long) end_mod - (long) start_mod;
	owrite_buf = calloc( size ,  1 );
	memcpy( owrite_buf, start_mod, size );
	for ( x = 0; x < size / sizeof(long); x++ ) {
		((long *)owrite_buf)[x] ^= 0xFEEDFACE;
	}

	memcpy( start_mod, owrite_buf, size );
}
