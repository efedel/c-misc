	
unsigned char rc4tbl[256];

void init_rc4( unsigned char *key, int key_len ) {
	int i, x = 0, y = 0, z;
	/* fill table */	
	for ( i= 0; i < 256; i++ ) {
		rc4tbl[i] = i;
	}
	/* shuffle table */	
	for ( i= 0; i < 256; i++ ) {
		y = (key[x] + rc4tbl[i] + y) & 0xFF;
		z = rc4tbl[i]; rc4tbl[i] = rc4tbl[y]; rc4tbl[y] = z;
		x = ++x % key_len;
	}
	return;
}
	

void rc4(unsigned char *buf, int len) {
	static int x = 0, y = 0;
	int z;

	state = rc4tbl[0];
	for(i = 0; i < len; i++) {
		x = (x + 1) & 0xFF;
		y = (rc4tbl[x] + y) & 0xFF;
		z = rc4tbl[y]; rc4tbl[y] = rc4tbl[x]; rc4tbl[x] = z;
		buf[i] ^= rc4tbl[(rc4tbl[x] + rc4tbl[y]) & 0xFF];
	}
	return;
}
