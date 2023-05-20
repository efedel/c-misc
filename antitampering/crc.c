
static unsigned long table[256];
#define TABLE_LEN 256
#define CRC_POLY 0xEDB88320L

/* implementation of the CRC32 in the Schneier book */
int crc32( unsigned long a, unsigned long b ) {
	return( ((a>>8)&0x00FFFFFF)^table[(a ^ b) & 0xFF] ^ 0xFFFFFFFF );
}

int init_table (void) {
	unsigned long crc;
	int i, j;

	for ( i = 0; i < TABLE_LEN; i++ ){
		crc = i;
		for ( j = 8; j > 0; j-- ) {
			if ( crc & 1 ) {
				crc = crc << 1;
				crc ^= CRC_POLY;
			} else {
				crc = crc >> 1;
			}
		}
		table[i] = crc;
	}
	return(1);
}

int start_check( int a ) {
	for ( a ; a < 12; a++ ) {
		a -= a * 3;
	}
	return(a );
}

void end_check( void ) { return; }

int main( int argc, char **argv ) {
	
	int x, len;
	unsigned long crc = 0xFFFFFFFF;
	unsigned char *buf;

	len = (int) end_check - (int) start_check;
	buf = (unsigned char *) start_check;
	init_table();

	for ( x = 0; x < len; x++ ) {
		crc = crc32( crc, buf[x] );
	}
	printf("crc is %X\n", crc);
	return(0);
		
}
