#!/usr/bin/perl


my $file = shift;
if (! $file ) {
	$file = "-";
}

open( A, $file ) || die "unable to open $file\n";
foreach (<A>) {
	if ( /^\s*[0-9]+\s([.a-zA-Z_]+)\s+([0-9a-fA-F]{8,})\s+([0-9a-fA-F]{8,})\s+[0-9a-fA-F]{8,}\s+([0-9a-fA-F]{8,})\s+/) {
		$name = $1;
		$size = $2;
		$rva = $3;
		$pa = $4;
		if ( /LOAD/ ) {
			$perm = "r";
			if ( /CODE/ ) {
				$perm .= "x";
			} else {
				$perm .= "-";
			}
			if ( /READONLY/ ) {
				$perm .= "-";
			} else {
				$perm .= "w";
			}
		} else {
			$perm = "---";
		}
		print "SEC|$name|$size|$rva|$pa|$perm\n";
	}

}

close( A );
