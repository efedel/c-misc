
#include <stdio.h>

int main ( int argc, char **arv ) {

	int val = 16, count = 0;
	for ( count = 0; count < 12; count++ ) {
		printf( "val %X p %X count %X\n", val, ((int)printf >> 16) % 2, count );
	}
}
