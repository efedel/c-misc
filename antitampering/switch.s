.text
message:
.ascii "123456789 123456\0"
.globl main
main:
	pushl	%ebp
	movl	%esp, %ebp

	nop
	nop
	nop
	.byte 0xF3	#repe
	.byte 0xF2	#repne
	.byte 0x36	#ss:
	.byte 0x3E	#ds:
	.byte 0x26	#es:
	.byte 0x2E	#cs:
	.byte 0x64	#fs:
	.byte 0x65	#gs:
	.byte 0x66	# op-sz
	.byte 0x67	#addr-sz
	nop
	xorl	%eax, %eax
	pushl	%eax
	movl	%esp, %eax
	addb	%al, (%eax)
	popl	%eax

	pushl	$message
	call	puts
	popl	%eax

out:
	movl	%ebp, %esp
	popl %ebp
	ret
r1:
	xorl %eax, %eax
	jmp out	
r2:
	mov $1, %eax
	jmp out
r3:
	mov $22, %eax
	jmp out
r4:
	mov $55, %eax
	jmp out
r5:
	mov $255, %eax
	jmp out

jump_table:
.int r1
.int r2
.int r3
.int r4
.int r5
