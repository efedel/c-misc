
asm (
   	.byte 0xF3      #repe
        .byte 0xF2      #repne
        .byte 0x36      #ss:
        .byte 0x3E      #ds:
        .byte 0x26      #es:
        .byte 0x2E      #cs:
        .byte 0x64      #fs:
        .byte 0x65      #gs:
        .byte 0x66      # op-sz
        .byte 0x67      #addr-sz
        nop
);

/* empirical evidence shows you can have ~12 prefixes before the CPU
   gives up and does a SIGBUS. Not much chance for an overflow there */
