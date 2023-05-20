#include <stdio.h>

char * ret_str() {
	return( "what tf you got eh?\n");
}
int main(int argc, char ** argv){
	int x;

	printf("%s", ret_str() );
	for ( x = 0; x < 10; x++ ) {
		printf("%d\n", x);
	}
	return(0);
}
