#!/usr/bin/perl


my $file = shift;
if (! $file ) {
	$file = "-";
}

open( A, $file ) || die "unable to open $file\n";
foreach (<A>) {
	if ( /^[0-9a-fA-F]{8,}\s+(([0-9a-fA-f]{2,}\s{1,2}){1,16})\s*\|([^|]{1,16})\|/) {
		$hex = $1;
		$ascii = $3;
		$hex =~ s/\s+/ /g;
		$ascii =~ s/\|/./g;
		print "DATA|$hex|$ascii\n";
	}

}

close( A );
