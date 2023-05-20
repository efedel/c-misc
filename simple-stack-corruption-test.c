#include <stdio.h>
#include <stdlib.h>

#define MAPFILE_PAGE_SIZE 256
int main( int argc, char **argv ) {
	char cache[128] = {0};
	char buf[MAPFILE_PAGE_SIZE];
	memset( buf, 1, MAPFILE_PAGE_SIZE ); 
   memcpy( cache, &buf[MAPFILE_PAGE_SIZE - 128], 128);
	printf(" 126 %d 127 %d 128 %d\n", cache[125], cache[126], cache[127]);
	return(0);
}
			 
