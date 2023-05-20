#!/usr/bin/perl

my $file = shift;
my $addr, $hex, $mnem, $ops;
my @operands;

if ( ! $file ) {
	$file = "-";
}
open( A, $file ) || die "unable to open $file\n";

foreach (<A>) {
	if ( /^(0x0[0-9a-f]{7,})\s(([0-9a-f]{2,}\s)+)\s+([a-z]{2,6})\s+([^\s].+)$/) {
		$addr = $1;
		$mnem = $4;
		$ops = $5;
		$hex = $2;
		if ( $mnem =~ /^l?jmp/               ||
		     $mnem =~ /^j[onbaezspolg]{1,2}/ ||
		     $mnem =~ /^l?call/                ) {
			print "exec xref from $addr to $ops\n";
		} else {
			@operands = split ',', $ops;
			if ( $#operands > 0 ) {
				print "1: $operands[0] 2: $operands[1]\n";
			}
		}
		print "addr $addr\thex $hex\tmnem $mnem\tops $ops\n";
	}
}
close (A);
