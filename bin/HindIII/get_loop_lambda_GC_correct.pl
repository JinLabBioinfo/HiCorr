#!/usr/bin/perl

use strict;
my ($regress, $GC_group_file, $frag_stat_file, $group_stat_file) = @ARGV;
if(not defined $group_stat_file){
	die("Usage:./get_loop_lambda_GC_correct.pl <frag_loop_data> <GC_group_file> <frag_stat_file> <group_correct_factor_file>\n");
}

##################### determine the GC group for fragments #################
my $GC_range;
open(IN, $GC_group_file) || die("Error: Cannot open file $GC_group_file!\n");
while(my $line = <IN>){
        chomp $line;
        my ($id, $min, $max) = split "\t", $line;
        $GC_range->{$id} = "$min:$max";
}
close(IN);

my $frag_gc_group;
open(IN, $frag_stat_file);
while(my $line=<IN>){
        chomp $line;
        my ($id, $gc, $map) = split "\t", $line;
        $frag_gc_group->{$id} = get_id($gc, $GC_range);
}
close(IN);

################## get group correction factors ###################################
my $GC_factor;
open(IN, $group_stat_file) || die("Error: Cannot open file $group_stat_file!\n");
while(my $line = <IN>){
	chomp $line;
	my ($g1, $g2, $factor) = split "\t", $line;
	$GC_factor->{$g1}->{$g2} = $factor;
}
close(IN);


################## print new loop file with GC corrected lambda #####################
open(IN, $regress) || die("Error: Cannot open file $regress!\n");
while(my $line = <IN>){
	chomp $line;
	my ($frag1, $frag2, $count, $lambda) = split "\t", $line;
	my $g1 = $frag_gc_group->{$frag1};
	my $g2 = $frag_gc_group->{$frag2};
	my $factor = $GC_factor->{$g1}->{$g2};
	if($lambda == 0 || $factor ==0){
		$count = 0;
	}
	print join("\t", $frag1, $frag2, $count, $lambda * $factor)."\n";
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
        die("Error: did not find a group!\n");
}

