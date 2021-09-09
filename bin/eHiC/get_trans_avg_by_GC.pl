#!/usr/bin/perl

use strict;
my ($regress, $GC_group_file, $frag_stat_file, $loop_count_file, $min_map) = @ARGV;
if(not defined $min_map){
	die("Usage:./get_trans_avg_by_GC.pl <frag_loop_data> <frag_GC_group> <frag_stat> <trans_loop_count> <minimum mappability>\n");
}

##################### determine the GC group for fragments #################
my $GC_range;
open(IN, $GC_group_file);
while(my $line = <IN>){
        chomp $line;
        my ($id, $min, $max) = split "\t", $line;
        $GC_range->{$id} = "$min:$max";
}
close(IN);

my $frag_mappability;
my $frag_gc_group;
open(IN, $frag_stat_file);
while(my $line=<IN>){
	chomp $line;
	my ($id, $gc, $map) = split "\t", $line;
	$frag_gc_group->{$id} = get_id($gc, $GC_range);
	$frag_mappability->{$id} = $map;
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
	if($frag_mappability->{$frag1} < $min_map || $frag_mappability->{$frag2} < $min_map){
		next;
	}
	my $g1 = $frag_gc_group->{$frag1};
	my $g2 = $frag_gc_group->{$frag2};
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
        die("Error: did not find a group\n");
}

