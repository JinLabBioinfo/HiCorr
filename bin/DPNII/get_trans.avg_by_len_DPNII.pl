#!/usr/bin/perl

use strict;
my ($regress, $len_group_file, $anchor_stat_file, $loop_count_file) = @ARGV;


##################### determine the avg length group for anchors #################
my $len_range;
open(IN, $len_group_file);
while(my $line = <IN>){
        chomp $line;
        my ($id, $min, $max) = split "\t", $line;
        $len_range->{$id} = "$min:$max";
}
close(IN);

#my $frag_mappability;
my $frag_len_group;
#my $frag_gc;
open(IN, $anchor_stat_file);
while(my $line=<IN>){
	chomp $line;
	my ($chr, $beg, $end, $id, $len, $avg) = split "\t", $line;
	$frag_len_group->{$id} = get_id($avg, $len_range);
}
close(IN);

my $g_count;
open(IN, $loop_count_file);
while(my $line = <IN>){
	chomp $line;
	my ($g1, $g2, $count) = split "\t", $line;
	$g_count->{$g1}->{$g2} = $count;
}
close(IN);


################## Calculate group averages #######################################
my $g_sum;
open(IN, $regress);
while(my $line = <IN>){
	chomp $line;
	my ($frag1, $frag2, $count) = split "\t", $line;
	if (not defined $count){

		$count=1;
	}

	
	my $g1 = $frag_len_group->{$frag1};
	my $g2 = $frag_len_group->{$frag2};
	if(not defined $g_sum->{$g1}->{$g2}){
		$g_sum->{$g1}->{$g2} = 0;
	}
	$g_sum->{$g1}->{$g2} += $count;
}
close(IN);

foreach my $g1 (sort {$a<=>$b} keys %{$g_sum}){
	foreach my $g2 (sort {$a<=>$b} keys %{$g_sum->{$g1}}){
		my $count = $g_count->{$g1}->{$g2};
		my $sum = $g_sum->{$g1}->{$g2};
		my $avg = $sum / $count;
		print join("\t", $g1, $g2, $count, $avg)."\n";
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
	print $val . "\n";
        die("Error: did not find a group\n");
}

