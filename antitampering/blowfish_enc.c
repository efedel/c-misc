#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/mman.h>
#include <sys/stat.h>

#define BLF_N   16                      /* Number of Subkeys */
typedef struct BlowfishContext {
	u_int32_t S[4][256];    /* S-Boxes */
	 u_int32_t P[BLF_N + 2]; /* Subkeys */
} blf_ctx;
extern void blf_key(blf_ctx *c, const u_int8_t *k, u_int16_t len);
extern void blf_enc(blf_ctx *c, u_int32_t *data, u_int16_t blocks);
extern void blf_dec(blf_ctx *c, u_int32_t *data, u_int16_t blocks);

int main( int argc, char **argv ) {
	unsigned long offset, len;
	unsigned char *buf;
	char *file, *key;
	struct stat sb;
	blf_ctx ctx;
	int fd;

	if ( argc < 4 ) {
		printf("Usage: %s filename offset len key\n"
		       "	filename: file to encrypt\n"
		       "	offset: offset in file to start encryption\n"
		       "	len: number of bytes to encrypt\n"
		       "	key: key (string )\n", 
		       argv[0] );
		return(1);
	}

	file = argv[1];
	offset = strtoul( argv[2], NULL, 0 );
	len = strtoul( argv[3], NULL, 0 );
	key = argv[4];

	if ( stat( file, &sb ) ) {
		return(2);
	}

	if ( (fd = open(argv[1], O_RDWR | O_EXCL)) < 0 ) {
		return(3);
	}

	buf = mmap(NULL, sb.st_size, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
	if ( (int) buf < 0 ) {
		close(fd);
		return(4);
	}

	len = len / 4; /* blf_enc operates on words, not bytes */
	blf_key( &ctx, key, strlen(key) );
	blf_enc( &ctx, (int *) &buf[offset], len << 1 );
	
	msync( buf, sb.st_size, MS_SYNC );
	munmap( buf, sb.st_size );
	close(fd);
	return(0);
}	
