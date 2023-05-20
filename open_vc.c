// run this in background!! :)
// also remember to put some stderr stuff in to say what tty it lauched at
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <signal.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <sys/vt.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>

int main(int argc, char **argv){
	int vtnum;
	int vtfd;
	struct vt_stat vtstat;
	char device[32];
	int child;

	vtfd = open("/dev/tty", O_RDWR, 0);
	if (vtfd < 0){
			  perror("could not open /dev/tty");
			  exit(1);
	}
	if (ioctl(vtfd, VT_GETSTATE, &vtstat) < 0) {
			  perror("tty is not a virtual console");
			  exit(1);
	}
	if (ioctl(vtfd, VT_OPENQRY, &vtnum) < 0) {
			  perror("no free virtual consoles");
			  exit(1);
	}
	sprintf(device, "/dev/tty%d", vtnum);
	if (access(device, (W_OK|R_OK)) < 0) {
			  perror("insufficient permission on tty");
			  exit(1);
	}
	child = fork();
	if (child == 0) {
			  ioctl(vtfd, VT_ACTIVATE, vtnum);
			  ioctl(vtfd, VT_WAITACTIVE, vtnum);
			  setsid();
			  close (0); close (1); close (2);
			  close (vtfd);
			  vtfd = open(device, O_RDWR, 0);
			  dup(vtfd);
			  dup(vtfd);
			  execlp("/usr/bin/vim","vi", NULL);
	}
	wait (&child);
	ioctl(vtfd, VT_ACTIVATE, vtstat.v_active);
	ioctl(vtfd, VT_WAITACTIVE, vtstat.v_active);
	ioctl(vtfd, VT_DISALLOCATE, vtnum);
	exit(0);
}

/*
   ioctl() is used to modify parameters for special [device] files.
	ioctl(file descriptor, request, args)
	linux/vt.h:
		  %define VT_OPENQRY   0x5600    ;find available vt 
		  %define VT_GETMODE   0x5601    ;get mode of active vt 
		  %define VT_SETMODE   0x5602    ;set mode of active vt 
		  %define     VT_AUTO     0x00   ;auto vt switching 
		  %define     VT_PROCESS  0x01   ;process controls switching 
		  %define     VT_ACKACQ   0x02   ;acknowledge switch 
		  %define VT_GETSTATE  0x5603    ;get global vt state info 
		  %define VT_SENDSIG   0x5604    ;signal to send to bitmask of vts 
		  %define VT_RELDISP   0x5605    ;release display 
		  %define VT_ACTIVATE  0x5606    ;make vt active 
		  %define VT_WAITACTIVE   0x5607    ;wait for vt active 
		  %define VT_DISALLOCATE  0x5608   ;free memory associated to vt 
		  %define VT_RESIZE 0x5609    ;set kernel's idea of screensize 
		  %define VT_RESIZEX      0x560A   ;set kernel's idea of screensize + more 
		  %define VT_LOCKSWITCH   0x560B   ;disallow vt switching 
		  %define VT_UNLOCKSWITCH 0x560C   ;allow vt switching 
	linux/kd.h:

	fcntl() is used to perform operations on a file descriptor.
	fcntl(file descriptor, command, args)
	Possible operations:
	duplicate fd
	read close-on-exec flag
	set close-on-exec flag
	get fd flags
	set fd flags
	manage file locks
	manage i/o signals

   asm/unistd.h = syscall interrupt services
%define __NR_ioctl               54
%define __NR_fcntl               55
When calling INT 80h, eax must be set to the desired function number. Any
parameters to the syscall routine must be placed in the following registers in
order:

    ebx, ecx, edx, esi, edi


	

	--fin                                                         */
