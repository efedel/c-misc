#!/usr/bin/perl


my $file = shift;
my %insn, $prev_insn, $head;
if (! $file ) {
        $file = "-";
}
open( A, $file ) || die "unable to open $file\n";

foreach (<A>) {
	chomp;
	%insn = new_insn( $_ );
	print "insn addr $insn{addr} : $insn{mnem}\t$insn{dest}\t$insn{src}\n";

	if ( $prev_insn ) { 
		$$prev_insn{next} = \%insn; 
	} else {
		$head = \%insn;
	}
	$prev_insn = \%insn;
}
close (A);

# at this point we have a list of instructions


sub new_insn {
	local($line) = @_;
	local(%i);
	( $i{addr}, $i{name}, $i{size}, $i{bytes},
	  $i{mnem}, $i{mtype}, $i{src}, $i{stype},
	  $i{dest}, $i{dtype}, $i{aux}, $i{atype} ) = 
		split '\|', $line;
	return %i;
}
