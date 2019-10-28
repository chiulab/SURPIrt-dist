#!/usr/bin/perl
#
# Charles Chiu
# July 6th, 2017
#
use strict;
use warnings;
use File::Basename;

#################################################################
# Extracts a particular sequence from a sequence file, given a 	#
# fasta file with all sequences and a file with id list		# 
#################################################################
# USAGE: <script_name.pl> <id_list_file> <lookup_file>		#
#################################################################

my $scriptname = basename($0);

if ($#ARGV != 2) {
 print "usage: $scriptname <blast_file> <lookup_file> <output_file>\n";
 exit;
}

my $test=1;
my ($id_file, $lookup_file, $outfile) = @ARGV;
my $line_count=0;
sub trim($);
sub get_gi_id($);
my @query;
my $flag=0;

print localtime()."\t$scriptname\tStoring ids into a hash for lookup\n";

my @ids;
open (MYID, $id_file) or die "Could not open file '$id_file' $!";;
while (my $line = <MYID>) {
	chomp($line);
	my @items = split(/\t/, $line);
# 	$line = trim($line);
# 	if ($line =~ /\|/){
# 	$line = get_gi_id($line);
# 	}
#	print "Storing id: $items[0]\n" if ($test);
	push(@ids, trim($items[0]));
}
close(MYID);
print localtime()."\t$scriptname\tRead ", scalar @ids, " ids\n";

print localtime()."\t$scriptname\tCreating a hash for lookup\n";
my %hash;
@hash{@ids}=();

my $head = `head -n 1 $lookup_file`;
my ($fasta, $fastq, $tag);

if ($head =~ m/^>/){
	$fasta = 1;
	$tag = substr($head, 0, 1);
	print localtime()."\t$scriptname\tLooks like a fasta file. Will look for $tag for headers in $lookup_file\n";
}
elsif ($head =~ m/^@/){
	$fastq = 1;
	$tag = substr($head, 0, 4);
	print localtime()."\t$scriptname\tLooks like a fastq file. Will look for $tag for headers in $lookup_file\n";
}

open (OUT, ">$outfile");
open(LOOKUP, $lookup_file) || die ("Could not file the fasta file");
while (my $line = <LOOKUP>){
	chomp($line);
	$line = trim($line);
	if ($line =~ m/^$tag/){
#		print "Hit a header: $line\n" if ($test); 
		$flag = 0;
		my $str = substr($line, 1);
		#my $line_gi_id = get_gi_id($line);
		#$flag = 1 if exists $hash{get_gi_id($line)};
		$flag = 1 if exists $hash{$str};
	}
	print OUT $line, "\n" unless ($flag);
}
close(LOOKUP);
close(OUT);
print localtime()."\t$scriptname\tDone! Output created at $outfile\n";

exit;

sub trim ($){
	my $str = shift;
	$str =~ s/^\s+//;
	$str =~ s/\s+$//;
	return $str;
}


sub get_gi_id ($){
	my $str = shift;
	my @id_fields = split(/\|/, $str);
	return $id_fields[1];
}
