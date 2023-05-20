#!/usr/bin/perl

my $file = shift;
my @syms, @imps;
my @operands;

if ( ! $file ) {
	$file = "-";
}
open( A, $file ) || die "unable to open $file\n";

foreach (<A>) {
	chomp;
	if ( /^([0-9a-f]{8})\s[a-z]?[a-z]?\s+([DFOdfo]+)\s([a-zA-Z_.\*]+)\s[0-9a-z]{8}\s([a-zA-Z_.]+)/ ) {
		$type = $2;
		$addr = $1;
		$loc  = $3;
		$name = $4;
		if ( $type =~ /F/ ) {
			if ( $loc =~ /\*UND\*/ ) {
				$imports{$name} = $addr;
				$sym{$addr} = $name;
			} else { 
				$func{$name} = $addr;
				$sym{$addr} = $name;
			}
		}
	}
}

close (A);
