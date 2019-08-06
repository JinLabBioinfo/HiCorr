#!/usr/bin/perl

use strict;

my $usage = "Usage:./batch_anchor_by_chrom.pl <frag_bed> <loop_list> <promoter_map>\n";

my ($frag_bed, $loop_list, $map_file) = @ARGV;

if(not defined $map_file){
        die($usage);
}

my $chr_ref;
################## Read fragment chrom ##################
my $frag_chrom;
open(IN, $frag_bed);
while(my $line = <IN>){
        chomp $line;
        my ($chr, $beg, $end, $id) = split "\t", $line;
        $frag_chrom->{$id} = $chr;
	$chr_ref->{$chr} = 1;
}
close(IN);

my $dir = "temp.by.chrom";
`mkdir $dir`;

split_by_chr($frag_bed, $frag_chrom, $dir, $chr_ref, 4);
split_by_chr($map_file, $frag_chrom, $dir, $chr_ref, 1);
split_by_chr($loop_list, $frag_chrom, $dir, $chr_ref, 1);

foreach my $chr (keys %$chr_ref){
	# convert fragment-to-fragment data to anchor-to-anchor data
	`./fragdata_to_anchordata.pl $dir/$loop_list.$chr $dir/$map_file.$chr > $dir/anchor_2_anchor.loop.$chr`;

	# calculate p value for the achor-to-anchor data
	open(IN, "get_anchor_pval.r");
	open(OUT, ">$dir/get_anchor_pval.$chr.r");
	while(my $line = <IN>){
		$line =~ s/FILE/$dir\/anchor_2_anchor.loop.$chr/g;
		print OUT $line;
	}
	close(OUT);
	close(IN);
	`R --quiet --vanilla < $dir/get_anchor_pval.$chr.r`;
}

exit;


##########################################################################
sub split_by_chr{
	my ($file, $frag_chrom, $dir, $chr_ref, $col) = @_;
	my $fh_ref;
	foreach my $chr (keys %$chr_ref){
		open($fh_ref->{$chr}, ">$dir/$file.$chr");
	}
	
	open(IN, $file);
	while(my $line = <IN>){
		chomp $line;
		my @vals = split "\t", $line;
		my $fid = $vals[$col - 1];
		my $chr = $frag_chrom->{$fid};
		my $fh = $fh_ref->{$chr};
		print $fh $line."\n";
	}
	close(IN);
	
        foreach my $chr (keys %$chr_ref){
                close $fh_ref->{$chr};
        }
	return;       
}
