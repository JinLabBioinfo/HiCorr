#!/usr/bin/perl

use strict;

my $usage = "./generate_data_matrix.pl <frag_bed> <frag_loops> <grid lines>";

my ($frag_bed, $loop_file, $grid_file) = @ARGV;

if(not defined $loop_file){
        die($usage);
}

my @obs_matrix;
my @expt;
my @ratio;
my @frags = ();
my @ends = ();
my $frag_idx;

################## Read fragment chrom ##################
my $frag_chrom;
open(IN, $frag_bed);
my $i = 0;
while(my $line = <IN>){
        chomp $line;
        my ($chr, $beg, $end, $id) = split "\t", $line;
        push @frags, $id;
        push @ends, $end;
        $frag_idx->{$id} = $i;
        $i ++;
}
close(IN);

my $len=$#frags +1;
################### initiate matrix ####################
for(my $i = 0; $i < $len; $i ++){
        my @array = ();
        for(my $j = 0; $j < $len; $j ++){
                push @array, 0;
        }
        push @obs_matrix, \@array;

}

for(my $i = 0; $i < $len; $i ++){
        for(my $j = 0; $j < $len; $j ++){
                $expt[$i][$j] = 0;
        }
}

for(my $i = 0; $i < $len; $i ++){
        for(my $j = 0; $j < $len; $j ++){
                $ratio[$i][$j] = 0;
        }
}

#################### Read frag loops  ###################
open(IN, $loop_file);
while(my $line = <IN>){
        chomp $line;
        my ($fid1, $fid2, $obs_count, $expt_count) = split "\t", $line;
        my $i = $frag_idx->{$fid1};
        my $j = $frag_idx->{$fid2};
        $obs_matrix[$i][$j] = $obs_count;
        $obs_matrix[$j][$i] = $obs_count;
        $expt[$i][$j] = $expt_count;
        $expt[$j][$i] = $expt_count;
	$ratio[$i][$j] = ($obs_matrix[$i][$j]+10)/($expt[$i][$j]+10);
	$ratio[$j][$i] = ($obs_matrix[$j][$i]+10)/($expt[$j][$i]+10);
}
close(IN);

open(OUT,">$loop_file.matrix.obs");
for(my $i = 0; $i < $len; $i++){
        print OUT join("\t", @{$obs_matrix[$i]})."\n";
}
close(OUT);
open(OUT,">$loop_file.matrix.expt");
for(my $i = 0; $i < $len; $i++){
        print OUT join("\t", @{$expt[$i]})."\n";
}
close(OUT);

open(OUT,">$loop_file.matrix.ratio");
for(my $i = 0; $i < $len; $i++){
        print OUT join("\t", @{$ratio[$i]})."\n";
}
close(OUT);

open(OUT, ">$grid_file");
print OUT "Index\tLoc\n";
for(my $i = 1; $i <= $len; $i ++){
        print OUT join("\t", $i, $ends[$i - 1])."\n";
}
close(OUT);

exit;

