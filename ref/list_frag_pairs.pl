#!/usr/bin/perl
use strict;
my $usage = 	"Usage:./list_frag_pairs.pl <fragment bed> <max_distance>\n".
		"\tPrint the list of fragment pairs within a distance.\n";

my ($fragfile, $maxdist) = @ARGV;
if(not defined $maxdist){
        die($usage);
}

my $frag_beg;
my $frag_end;
my $frag_chr;
my @frag_id;

open(IN, $fragfile);
while(my $line = <IN>){
        chomp $line;
        my ($chr, $beg, $end, $id, $len) = split "\t", $line;
	
	push @frag_id, $id;
	$frag_chr->{$id} = $chr;
	$frag_beg->{$id} = $beg;
	$frag_end->{$id} = $end;
}
close(IN);

my $ind_up = 0;
my $up_id = $frag_id[$ind_up];
my $up_chr = $frag_chr->{$up_id};
my $up_end = $frag_end->{$up_id};

for(my $i = 0; $i <= $#frag_id; $i++){
	my $curr_id = $frag_id[$i];
	my $curr_chr = $frag_chr->{$curr_id};
	my $curr_beg = $frag_beg->{$curr_id};
	my $curr_end = $frag_end->{$curr_id};

	############ find the first upstream frag within maxdist #######################
	my $up_dist = $curr_beg - $up_end - 1;
	if($up_chr ne $curr_chr){
		$ind_up = $i;
		$up_chr = $curr_chr;
		$up_id = $frag_id[$ind_up];
		$up_end = $frag_end->{$up_id};
                $up_dist = $curr_beg - $up_end - 1;
	}
	while($up_dist > $maxdist && $ind_up < $i){
		$ind_up ++;
		$up_id = $frag_id[$ind_up];
		$up_end = $frag_end->{$up_id};
		$up_dist = $curr_beg - $up_end - 1;
	}

	for(my $j = $ind_up; $j < $i; $j++){
		my $id = $frag_id[$j];
		my $end = $frag_end->{$id};
		print join("\t", $curr_id, $id, 0, $curr_beg - $end -1)."\n";
	}

	my $j = $i + 1;
	my $id = $frag_id[$j];
	my $chr = $frag_chr->{$id};
	my $beg = $frag_beg->{$id};
	while($chr eq $curr_chr && ($beg - $curr_end - 1) <= $maxdist){
		print join("\t", $curr_id, $id, 0, $beg - $curr_end - 1)."\n";
		$j++;
		$id = $frag_id[$j];
		$chr = $frag_chr->{$id};
		$beg = $frag_beg->{$id};
	}
}

exit;
