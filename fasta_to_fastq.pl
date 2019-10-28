#!/usr/bin/perl

use strict;

my $file = $ARGV[0];
open FILE, $file;

my ($header, $sequence, $sequence_length, $sequence_quality);
while(<FILE>) {
	chomp $_;
	if ($_ =~ /^>(.+)/) {
		if($header ne "") {
			print "\@".$header."\n";
			print $sequence."\n";
			print "+"."\n";
			print $sequence_quality."\n";
		}
		$header = $1;
		$sequence = "";
		$sequence_length = "";
		$sequence_quality = "";
	}
	else { 
		$sequence .= $_;
		$sequence_length = length($_); 
		for(my $i=0; $i<$sequence_length; $i++) {$sequence_quality .= "I"} 
	}
}
close FILE;
print "\@".$header."\n";
print $sequence."\n";
print "+"."\n";
print $sequence_quality."\n";
