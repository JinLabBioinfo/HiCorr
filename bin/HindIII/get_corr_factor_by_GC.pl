#!/usr/bin/perl

use strict;
my ($group_avg_file) = @ARGV;
if(not defined $group_avg_file){
	die("Usage:./get_corr_factor_by_GC_length.pl <group avg file>\n");
}

my $group_avg;
my $total_count;
my $total_reads;
open(IN, $group_avg_file);
while(my $line = <IN>){
        chomp $line;
	my ($gc1, $gc2, $count, $avg) = split "\t", $line;
	$group_avg->{$gc1}->{$gc2} = $avg;
	$total_count += $count;
	$total_reads += $avg * $count;
}
close(IN);

my $total_avg = $total_reads / $total_count;
for(my $gc1 = 1; $gc1 <= 20; $gc1 ++){
	for(my $gc2 = 1; $gc2 <= 20; $gc2 ++){
		my $correct = $group_avg->{$gc1}->{$gc2} / $total_avg;
		print join("\t", $gc1, $gc2, $correct)."\n";
	}
}

exit;

