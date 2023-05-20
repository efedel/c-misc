#include <time.h>
#include <stdio.h>
#include <sys/timeb.h>
#include <sys/types.h>
#include <string.h>

int main()
{
	char buffer[128];
	tzset();
	strdate(buffer);
	printf("%s\n", buffer);
	exit(0);
}
