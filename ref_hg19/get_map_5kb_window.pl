#!/usr/bin/perl

use strict;

my ($file) = @ARGV;

my $win = 5000;
my $anchor_id = 1;

open(IN, $file);
open(OUT, ">anchors_5kb.bed");

my $curr_chr = 0;
my $curr_len = 0;
my $curr_beg = 1;
my $curr_end = 1;
my @frag_list = ();

while(my $line = <IN>){
	chomp $line;
	my ($chr, $beg, $end, $fid, $len) = split "\t", $line;
	if($chr ne $curr_chr){
		if($curr_chr){
			print OUT join("\t", $curr_chr, $curr_beg, $curr_end, "A_".$anchor_id)."\n";
			while(my $frag = shift @frag_list){
				print join("\t", $frag, "A_".$anchor_id)."\n";
			}
			$anchor_id ++;
		}
		($curr_chr, $curr_beg, $curr_end, $curr_len) = ($chr, 1, 1, 0);
	}

	$curr_len += $len;
	push @frag_list, $fid;
	$curr_end = $end;
	if($curr_len >= $win){
		print OUT join("\t", $curr_chr, $curr_beg, $curr_end, "A_".$anchor_id)."\n";
		while(my $frag = shift @frag_list){
			print join("\t", $frag, "A_".$anchor_id)."\n";
                }
		$anchor_id ++;
		$curr_beg = $curr_end + 1;
		$curr_end ++;
		$curr_len = 0;
	}
}

close(IN);
close(OUT);
exit;
