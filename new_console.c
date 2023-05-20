#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>

//#include <signal.h>
#include <sys/ioctl.h>
#include <sys/vt.h>
//#include <sys/kd.h>
//#include <sys/param.h>


int main(int argc, char **argv) {
	int fd;
	int vtnum = 0;
	struct vt_mode vtmode;
	struct vt_stat vs;

	fd = open("/dev/tty", O_RDWR);

	/* are we in a VC ? */
	if ( ioctl(fd, VT_GETMODE, &vtmode) < 0 ) {
		int child;
		printf("ohshit! not in VC ... let's see what happens\n");
			if (! child == fork()) {
				char *argv[] = {"xterm", "-e", "lynx", "/home/doc/Intel", NULL}; 
				execvp("xterm", argv);
			}
	} else {
		/* get current VC */
		ioctl(fd, VT_GETSTATE, &vs);
		printf("current VC is %d\n", vs.v_active);

		/* get next avail VC */
		if ( ioctl(fd, VT_OPENQRY, &vtnum) < 0 || vtnum == -1 ) {
			printf("shit! no VCs\n");
		} else {
			char device[32];
			int child, vtfd;
			printf("next avail VC is %d\n", vtnum);
			sprintf(device, "/dev/tty%d", vtnum);

			if (! child == fork()) {
				ioctl(fd, VT_ACTIVATE, vtnum);
				ioctl(fd, VT_WAITACTIVE, vtnum);
				close(0); close(1); close(2);
				vtfd = open(device, O_RDWR, 0);
				dup(vtfd); dup(vtfd);
			ioctl(fd, VT_ACTIVATE, vs.v_active);
			//ioctl(fd, VT_WAITACTIVE, vs.v_active);
				sleep(1);
				execlp("/bin/sh", "sh", NULL);
			}
			wait( &child);
			ioctl(fd, VT_ACTIVATE, vs.v_active);
			ioctl(fd, VT_WAITACTIVE, vs.v_active);
			ioctl(fd, VT_DISALLOCATE, vtnum);
			   
		}
	}

	//if ( vtnum > 0 ) {
	//	ioctl(fd, VT_DISALLOCATE, vtnum);
	//}
	return(0);
}
