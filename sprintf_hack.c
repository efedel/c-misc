#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


union { char c; unsigned char uc; short s; unsigned short us;
	int i; unsigned int ui; long l; unsigned long ul;
	double d; char *str; void *vp;
} u;
int my_printf(char *format, ...) {
	char *c, *str, *fmt, *fmt_copy, byte;
	int i, count = 0, num_args = 0;
	int sz_str = 0, in_fmt_code = 0, sz_code = 0;
	va_list vl;
	
	sz_str = strlen(format);
	str = calloc( sz_str, 1 );
	fmt = fmt_copy = strdup(format);
	va_start(vl, format);
	for ( c = fmt_copy; *c; c++ ) {
		if ( *c == '\n' || *c == '\t' || *c == '\b' || *c == '\r' ||
		     *c == '\f' || *c == '\a' || *c == '\v'  ) {
			byte = *c;
			*c = '\0';	/* null-terminate string */
			if (! str || count >= sz_str) {
				sz_str = count;
				str = realloc( str, sz_str );
			}
			if ( count ) {
				snprintf(str, sz_str, fmt);
				sys_msg(str); 
				count = 0;
			}
			fmt = c + 1;
			sys_msg(&byte); 
			continue;
		}
		if (! in_fmt_code ) {
			if ( *c == '%' ) 	in_fmt_code = 1;
			else 			count ++;
			continue;
		}

		/* ok, get argument sizes */
		if ( *c >= '0' && *c <= '9' ) {
			sz_code = (sz_code *10) + (*c - 0x30);
		} else if ( *c == '%' ) {
			u.c = '%';
			count++;
		} else if ( *c == 's' ) {
			u.str = va_arg(vl, char *);
			count += strlen(u.str);
		} else if ( *c == 'd' || *c == 'i' || *c == 'o' ||
			    *c == 'u' || *c == 'x' || *c == 'X' ||
			    *c == 'c' || *c == 'p' ) {
			count += sizeof(long);
			u.l = va_arg(vl, long);
		} else if ( *c == 'e' || *c == 'E' || *c == 'F' ||
			    *c == 'f' || *c == 'g' || *c == 'G' ||
			    *c == 'a' || *c == 'A' ) {
			count += sizeof(double);
			*(c+1) = '\0';
			u.d = va_arg(vl, double);
		} else if ( *c == 'n' ) {
			//x = va_arg(vl, long);
			u.vp = va_arg(vl, void *);
		} else if ( *c == ' ' ){
			/* bad format code */
			u.i = 0;
		} else{
			/* everything else is part of format code */
			continue;
		}
		if (! count )	continue;
		count += sz_code;
		in_fmt_code = 0;
		byte = *(c+1);
		*(c+1) = '\0';
		if (! str || count >= sz_str) {
			sz_str = count;
			str = realloc( str, sz_str );
		}
		snprintf(str, sz_str, fmt, u);
		sys_msg(str); 
		*(c+1) = byte;
		fmt = c + 1;
		count = 0;
	}

	if ( count ) {
		if (! str || count >= sz_str) {
			sz_str = count;
			str = calloc( sz_str, 1 );
		}
		snprintf( str, sz_str, fmt, vl);
		sys_msg(str); 
	}
	va_end( vl );
	free(fmt_copy);
	free(str);
	return(1);
}
