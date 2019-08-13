#!/usr/bin/perl

use strict;
my ($frag_bed, $Length_group_file, $frag_stat_file) = @ARGV;
if(not defined $frag_stat_file){
        die("Usage:./count_trans_pairs_by_Length.pl <frag_bed> <frag_Length_group> <frag_length>");
}

my $frag_chr;
open(IN, $frag_bed);
while(my $line = <IN>){
        chomp $line;
        my ($chr, $beg, $end, $id, $len) = split "\t", $line;
        $frag_chr->{$id} = $chr;
}
close(IN);

##################### determine the Length group for fragments #################
my $Length_range;
open(IN, $Length_group_file);
while(my $line = <IN>){
        chomp $line;
        my ($id, $min, $max) = split "\t", $line;
        $Length_range->{$id} = "$min:$max";
}
close(IN);

my $total_count;
my $chrom_count;
open(IN, $frag_stat_file);
while(my $line=<IN>){
        chomp $line;
        my ($id, $length) = split "\t", $line;
	my $length_group = get_id($length, $Length_range);
	my $chr = $frag_chr->{$id};
	if(not defined $total_count->{$length_group}){
		$total_count->{$length_group} = 0;
	}
	$total_count->{$length_group} ++;
	if(not defined $chrom_count->{$length_group}->{$chr}){
		$chrom_count->{$length_group}->{$chr} = 0;
	}
	$chrom_count->{$length_group}->{$chr} ++;
}
close(IN);

foreach my $g1 (sort {$a<=>$b} keys %$chrom_count){
	foreach my $g2 (sort {$a<=>$b} keys %$chrom_count){
		my $count = 0;
		foreach my $chr1 (keys %{$chrom_count->{$g1}}){
			foreach my $chr2 (keys %{$chrom_count->{$g2}}){
				if($chr1 ne $chr2){
					$count += $chrom_count->{$g1}->{$chr1} * $chrom_count->{$g2}->{$chr2}
				}
			}
		}
		print join("\t", $g1, $g2, $count)."\n";
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

