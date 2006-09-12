#! perl -n
#

if (/^-+$/) {
	$new = 1;
	next;
}

if ($new and /^(.*?)\s*\|\s*(.*?)\s*\|\s*(.*?)\s*\|\s*(.*?)\s*$/) {
	print "\\clentry{$1}{$2}{$3}{$4}\n";
	$new = 0;
	next;
}

print
