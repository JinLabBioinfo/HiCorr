#!/usr/bin/perl

use strict;
my ($regress, $anchor_bed, $len_group_file, $dist_group_file, $group_stat_file) = @ARGV;
if(not defined $dist_group_file){
	die("Usage:./get_loop_lambda.pl <frag_loop_data> <frag bed> <frag_stat> <frag_length_group> <frag_dist_group> <group_statistic_file>\n");
}

##################### determine the length group for fragments #################
my $len_range;
open(IN, $len_group_file);
while(my $line = <IN>){
        chomp $line;
        my ($id, $min, $max) = split "\t", $line;
        $len_range->{$id} = "$min:$max";
}
close(IN);

my $frag_len_group;
open(IN, $anchor_bed);
while(my $line = <IN>){
	chomp $line;
	my ($chr, $beg, $end, $id, $dsit, $len) = split "\t", $line;
	$frag_len_group->{$id} = get_id($len, $len_range);
}
close(IN);


################### use an array to store group info for differenct distance ######
my @dist_group;
open(IN, $dist_group_file);
while(my $line = <IN>){
	chomp $line;
	my ($g, $low, $high) = split "\t", $line;
	for(my $i = $low + 1; $i <= $high; $i ++){
		$dist_group[$i] = $g;
	}
}
close(IN);

################## get group average values #######################################
my $g_avg;
open(IN, $group_stat_file);
while(my $line = <IN>){
	chomp $line;
	my ($g1, $g2, $g3, $count, $avg) = split "\t", $line;
	$g_avg->{$g1}->{$g2}->{$g3} = $avg;
}
close(IN);


################## print new data with group avg ##################################
open(IN, $regress);
while(my $line = <IN>){
	chomp $line;
	my ($frag1, $frag2, $count, $dist) = split "\t", $line;
	my $g1 = $frag_len_group->{$frag1};
	my $g2 = $frag_len_group->{$frag2};
	my $g3 = $dist_group[$dist];
	my $avg = $g_avg->{$g1}->{$g2}->{$g3};
	#my $map1 = $frag_map->{$frag1};
	#my $map2 = $frag_map->{$frag2};
	my $lambda = $avg;
	if($lambda == 0){
		$count = 0;
	}
	print join("\t", $frag1, $frag2, $count, $lambda)."\n";
}
close(IN);

exit;


##############################################################
sub get_id{
        my ($val, $range) = @_;
        foreach my $id (keys %{$range}){
                my ($min, $max) = split ":", $range->{$id};
                if($val > $min && $val <= $max){
                        return $id;
                }
        }
        die("Error: did not find a group\n");
}

