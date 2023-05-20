#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/mman.h>


typedef void (*smc_fn)(void);
unsigned char *code_buffer;

unsigned char buf[] = { 0x55, 0x89, 0xE5, 0x90, 0xC9, 0xC3 };

void dummy_end( void );
int dummy(void);
int dummy_size = (int)dummy_end - (int)dummy;
int dummy( void ) {
	int x, y = 1; 

	for ( x = 0; x < 12; x++ ) {
		y += x;
	}

	return(0);
	asm volatile ( ".fill %0, 1, 9\n" : : 
                       "i" (dummy_size) );

}
void dummy_end( void ) { return; }

int smc_decode( void ) {
	code_buffer = calloc( 512, 1 );
	memcpy( code_buffer, buf, 6 );
	//mprotect( code_buffer, 512, PROT_READ | PROT_EXEC );
	return(1);	
}

//#include <blowfish.h>
#define BLF_N	16			/* Number of Subkeys */
typedef struct BlowfishContext {
	u_int32_t S[4][256];	/* S-Boxes */
	u_int32_t P[BLF_N + 2];	/* Subkeys */
} blf_ctx;
extern void blf_key(blf_ctx *c, const u_int8_t *k, u_int16_t len);
extern void blf_enc(blf_ctx *c, u_int32_t *data, u_int16_t blocks);
extern void blf_dec(blf_ctx *c, u_int32_t *data, u_int16_t blocks);

int blow() {
	blf_ctx c;
	char    key[] = "AAAAA";
	char    key2[] = "abcdefghijklmnopqrstuvwxyz";
	u_int32_t data[10];
	u_int32_t data2[] = {0x424c4f57L, 0x46495348L};
	u_int16_t i;
	blf_key(&c, (u_int8_t *) key, 5);
	blf_enc(&c, data, 5);
	blf_dec(&c, data, 1);
	blf_dec(&c, data + 2, 4);
	blf_key(&c, (u_int8_t *) key2, strlen(key2));
	blf_enc(&c, data2, 1);
	blf_dec(&c, data2, 1);
	return(0);
}
int main( int argc, char *argv ) {
	smc_fn func;
	smc_decode();
	func = (smc_fn) code_buffer;
	(*func)();
	blow();
	return;
}
