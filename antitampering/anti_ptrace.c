#include <stdio.h>
//#include <sys/ptrace.h>

int dbg_detect_ptrace() {
	int parent;
	parent = getppid();
	if  (ptrace( PT_ATTACH, parent, 0, 0 ) ) {
		return(1);
	}
	ptrace( PT_DETACH, parent, 0, 0 );
	//if (ptrace(PTRACE_TRACEME, 0, 1, 0) < 0)
	return(0);
}

int main( int argc, char **argv ) {
	if ( dbg_detect_ptrace() ) {
		printf("crapola! debugged\n");
	}
	return(0);
}
