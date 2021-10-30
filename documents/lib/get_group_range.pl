#!/usr/bin/perl
use strict;
my $usage = 	"./get_group_range.pl <bed> <col> <group_number>\n".
		"\tThis program take numeric column <col> of <bed> and print out ranges after breaking into <group_number> of groups after sorting ascend\n";

my ($bed, $col, $n) = @ARGV;
if(not defined $n){
	die($usage);
}

my @len = ();
open(IN, $bed);
while(my $line = <IN>){
	chomp $line;
	my @x = split "\t", $line;
	push @len, $x[$col - 1];
}
close(IN);
my @sort_len = sort {$a <=> $b} @len;
unshift @sort_len, -1e10;
my $total = $#sort_len;
my @len_cut;
for(my $i=1; $i<=$n; $i++){
	 print join("\t", $i, $sort_len[int(($i-1) * $total / $n)], $sort_len[int($i * $total / $n)])."\n";
}

exit;
