#!/usr/bin/perl

use strict;

my ($frag_bed, $frag_stat_file, $GC_group_file) = @ARGV;


my $frag_chr;
open(IN, $frag_bed);
while(my $line = <IN>){
        chomp $line;
        my ($chr, $beg, $end, $id) = split "\t", $line;
        $frag_chr->{$id} = $chr;
}
close(IN);

##################### determine the GC group for fragments #################
my $GC_range;
open(IN, $GC_group_file);
while(my $line = <IN>){
        chomp $line;
        my ($id, $min, $max) = split "\t", $line;
        $GC_range->{$id} = "$min:$max";
}
close(IN);

my $total_count;
my $chrom_count;
open(IN, $frag_stat_file);
while(my $line=<IN>){
        chomp $line;
        my ($chr,$beg,$end,$id, $dist,$gc) = split "\t", $line;
	
	my $gc_group = get_id($gc, $GC_range);
	my $chr = $frag_chr->{$id};
	if(not defined $total_count->{$gc_group}){
		$total_count->{$gc_group} = 0;
	}
	$total_count->{$gc_group} ++;
	if(not defined $chrom_count->{$gc_group}->{$chr}){
		$chrom_count->{$gc_group}->{$chr} = 0;
	}
	$chrom_count->{$gc_group}->{$chr} ++;
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
	#print $val;
        die("$val");
}

