#!/usr/bin/perl

# insn { type, insn, op, op, op }
# label { type, name }
# directive { type, dir, args }
my @lines;
my $file = shift;
if (! $file ) {
	$file = "-";
}
open( A, $file ) || die "unable to open $file\n";
foreach (<A>) {
	chomp;
	if ( /\s*(\.[^:]+)$/ ) {
		print "DIRECTIVE: $1\n";
	} elsif ( /^([A-Za-z0-9_]+):/ ) {
		print "LABEL: $1\n";
	} elsif ( /^(.[A-Za-z0-9_]+):/ ) {
		print "LOCAL_LABEL: $1\n";
	} elsif ( /^\s+([a-z]+)\s(.*)/ ) {
		print "INSN: $1 ops $2\n";
		($op1, $op2, $op3) = split ',', $2;
	} else {
		print "UNKNOWN: $_\n";
	} 
}
close (A);
