

struct insn_jmp {
	unsigned char op;	/* 0xEA */
	unsigned long addr;
};
struct insn_jz {
	unsigned char op;	/* 0x74 */
	unsigned char off;
};
struct insn_jnz {
	unsigned char op;	/* 0x75 */
	unsigned char off;
};
