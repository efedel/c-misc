.global _start

cs_seg:
.word

save_smc:
	movw 4(%ebp), %ax
	movw %ax, cs_seg(,1)
	lret


_start:
	lcall *save_smc
	ret
