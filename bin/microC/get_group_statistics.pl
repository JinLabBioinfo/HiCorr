#!/usr/bin/perl

use strict;
my ($regress,$dist_group_file) = @ARGV;
if(not defined $dist_group_file){
	die("Usage:./get_group_statistics.pl <anchor_loop_data> <anchor bed> <anchor_length_group> <anchor_dist_group>\n");
}

##################### determine the length group for fragments #################


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

################## Calculate group averages #######################################
my $g_sum;
my $g_count;
open(IN, $regress);
while(my $line = <IN>){
	chomp $line;
	my ($anchor1, $anchor2, $count, $dist) = split "\t", $line;
#	my $g1 = $frag_len_group->{$anchor1};
#	my $g2 = $frag_len_group->{$anchor2};
	my $g3 = $dist_group[$dist];
	if(not defined $g_sum->{$g3}){
		$g_sum->{$g3} = 0;
	}
	if(not defined $g_count->{$g3}){
                $g_count->{$g3} = 0;
        }
	
	$g_count->{$g3} ++;
	$g_sum->{$g3} += $count
	

}
close(IN);

foreach my $g (sort {$a<=>$b} keys %{$g_sum}){
	#foreach my $g2 (sort {$a<=>$b} keys %{$g_sum->{$g1}}){
	#	foreach my $g3 (sort {$a<=>$b} keys %{$g_sum->{$g1}->{$g2}}){
			my $count = $g_count->{$g};
			my $sum = $g_sum->{$g};
			if($count != 0){
				my $avg = $sum / $count;
				print join("\t", $g, $count, $avg)."\n";
#				print join("\t", $g, $count, $sum)."\n";
			}else{
				print join("\t", $g, $count,"NA")."\n";
			}
}
	


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

