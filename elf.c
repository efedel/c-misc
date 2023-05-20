#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <stdio.h>
#include <errno.h>
#include <sys/mman.h>
#include <elf.h>

unsigned long elf_header_read( unsigned char *buf, int buf_len ){
	Elf32_Ehdr *ehdr = (Elf32_Ehdr *)buf;
	Elf32_Phdr *ptbl = NULL, *phdr;
	Elf32_Dyn  *dtbl = NULL, *dyn;
	Elf32_Sym  *symtab = NULL, *sym;
	char       *strtab = NULL, *str;
	int         i, j, str_sz, sym_ent, size;
	unsigned long offset, va;	/* offset: file pos, va: virtual address */

	ptbl = (Elf32_Phdr *)(buf + ehdr->e_phoff);	/* program header table */

	for ( i = 0; i < ehdr->e_phnum; i++ ) {
		phdr = &ptbl[i];

		if ( phdr->p_type == PT_LOAD ) {
			/* this is code or data */
			offset = phdr->p_offset;
			va = phdr->p_vaddr;
			size = phdr->p_filesz;

			if ( phdr->p_flags & PF_X ) {
				/* this is a code section */
				printf("Code section of %d bytes at %X va %X\n", size, offset, va);
			} else if ( phdr->p_flags & (PF_R | PF_W) ){
				/* this is read/write data */
				printf("Data section of %d bytes at %X va %X\n", size, offset, va);
			} else if (phdr->p_flags & PF_R ) {
				/* this is read-only data */
				printf("Rodata section of %d bytes at %X va %X\n", size, offset, va);
			}	/* ignore other sections */

		} else if ( phdr->p_type == PT_DYNAMIC ) {
			/* dynamic linking info: useful for imported routines */
			dtbl = (Elf32_Dyn *) (buf + phdr->p_offset);
	printf("dynamic %d items\n", phdr->p_filesz / sizeof(Elf32_Dyn) );

			for ( j = 0; j < (phdr->p_filesz / sizeof(Elf32_Dyn)); j++ ) {
				dyn = &dtbl[j];
				switch ( dyn->d_tag ) {
					case DT_STRTAB:
						strtab = (char *)dyn->d_un.d_ptr;
						break;
					case DT_STRSZ:
						str_sz = dyn->d_un.d_val;
						break;
					case DT_SYMTAB:
						symtab = (Elf32_Sym *)dyn->d_un.d_ptr;
						break;
					case DT_SYMENT:
						sym_ent = dyn->d_un.d_val;
						break;
					case DT_NEEDED:
						if ( strtab ) {
							str = strtab + dyn->d_un.d_val;
						}
						break;
				}
			}
			
		}				/* ignore other program headers */
	}

	/* make second pass looking for sytab and strtab */
	for ( i = 0; i < ehdr->e_phnum; i++ ) {
		phdr = &ptbl[i];

		if ( phdr->p_type == PT_LOAD ) {
			if ( strtab >= phdr->p_vaddr && strtab < phdr->p_vaddr + phdr->p_filesz ) {
				strtab = buf + phdr->p_offset + ((int) strtab - phdr->p_vaddr);
			}
			if ( symtab >= phdr->p_vaddr && symtab < phdr->p_vaddr + phdr->p_filesz ) {
				symtab = buf + phdr->p_offset + ((int) symtab - phdr->p_vaddr);
			}
		}
	}

	if ( ! symtab )	{
		fprintf(stderr, "no symtab!\n");
		return(0);
	}
	if ( ! strtab )	{
		fprintf(stderr, "no strtab!\n");
		return(0);
	}
	/* handle symbols for functions and shared library routines */
	size = strtab - (char *)symtab;	/* cheat: strtab follows symtab */

	for ( i = 0; i < size / sym_ent; i++ ) {
		sym = &symtab[i];
		str = &strtab[sym->st_name];

		if ( ELF32_ST_TYPE( sym->st_info ) == STT_FUNC ){
			/* this symbol is the name of a function */
			offset = sym->st_value;

			if ( sym->st_shndx ) {
				printf("import: %s\n", str);
				/* 'str' is name of subroutine at 'offset' in file */
			} else {
				printf("sub: %s\n", str);
				/* 'str' is name of imported function at 'offset' */
			}
		}	/* ignore other symbols */
	}

	/* return the entry point */
	return( ehdr->e_entry );
}

int main( int argc, char **argv ) {
	int fd;
	unsigned char *image;
	struct stat s;
	
	if ( argc < 2 ) {
		fprintf(stderr, "Usage: %s filename\n", argv[0]);
		return(1);	
	}
	if ( stat( argv[1], &s) ) {
		fprintf(stderr, "Error: %s\n", strerror(errno) );
		return(2);
	}
	fd = open( argv[1], O_RDONLY );
	if ( fd < 0 )  {
		fprintf(stderr, "Error: %s\n", strerror(errno) );
		return(3);
	}
	
	image = mmap(0, s.st_size, PROT_READ, MAP_SHARED, fd, 0);
	if ( (int) image < 0 ) {
		fprintf(stderr, "Error: %s\n", strerror(errno) );
		return(4);
	}
	elf_header_read( image, s.st_size );
	munmap( image, s.st_size );
	close(fd);
	return(0);
}
