#!/usr/bin/perl

use strict;

my $usage = 	"Usage:./find_RE_sites.pl <genome chromSize> <chr_fa_dir> <cutting site>\n".
		"\tThis program find <sequence> sites in <genome>\n".
		"\tOutput is in 1-system.\n";

my ($chromSize, $fa_dir,$seq) = @ARGV;
if(not defined $seq){
	die($usage);
}

open(IN, $chromSize);
my $sizeref;
while(my $line = <IN>){
	my ($chr, $size) = split "\t", $line;
	if($chr =~ /_/ || $chr eq "chrM"){
		next;
	}
	$sizeref->{$chr} = $size;
}
close(IN);

foreach my $chr (sort keys %{$sizeref}){
	my $size = $sizeref->{$chr};
	my @pos = `./sequence_match.pl -c $fa_dir/$chr.fa $seq`;
	chomp @pos;
	my $len = length($seq);
	while(my $loc = shift @pos){
		print join("\t", $chr, $loc, $loc + $len - 1)."\n";
	}
}
exit;
