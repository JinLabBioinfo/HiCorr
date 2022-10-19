#!/usr/bin/perl

use strict;
my $usage = 	"Usage: ./sequence_match.pl <option> <fasta> <query seq>\n".
		"\tThis program searches <query seq> in <fasta> file and prints all locations that have a match.\n".
		"\t<option>: -c matching is not case specific. Case specific is by default\n";

my $option;
if($ARGV[0] =~ /^-/){
	$option = shift @ARGV;
}

my ($fa, $motif) = @ARGV;
if(not defined $motif){
	die($usage);
}

my $case = 1;
if($option =~ /c/){
	$case = 0;
}

open(IN, $fa);
my @lines = <IN>;
close(IN);

chomp @lines;
my $seq_name = shift @lines;
my $seq = join("", @lines);
#print "Loading $seq_name finished!\n";

if(! $case){
	$seq =~ tr/a-z/A-Z/;
	$motif =~ tr/a-z/A-Z/;
}

my $pos = index($seq, $motif) + 1;
while($pos > 0){
	print $pos ."\n";
	$pos = index($seq, $motif, $pos) + 1;
}
exit;
