#!/usr/bin/perl

use strict;

my $usage = "Usage:./fragdata_to_anchordata.pl <loop_list> <promoter_map>\n";

my ($loop_list, $map_file) = @ARGV;

if(not defined $map_file){
        die($usage);
}

##################### Read fragment map #####################
my $map_frag;
my $map_gene;
open(IN, $map_file) || die("Error: Cannot open file $map_file!\n");
while(my $line = <IN>){
        chomp $line;
        my ($fid, $gid) = split "\t", $line;
        $map_frag->{$fid} = $gid;
	push @{$map_gene->{$gid}}, $fid;
}
close(IN);

######################## Bed fragment ########################
my $loop_bed;
#my $random_bed;
open(IN, $loop_list) || die("Error: Cannot open file $loop_list!\n");
while(my $line = <IN>){
        chomp $line;
        my ($fid1, $fid2) = split "\t", $line;
	my $gid1 = $map_frag->{$fid1};
	my $gid2 = $map_frag->{$fid2};
	if($gid1 ne $gid2){
		if(not defined $loop_bed->{$gid1}->{$gid2}){
			$loop_bed->{$gid1}->{$gid2} = 0;
			#$random_bed->{$gid1}->{$gid2} = $rand;
		}
		
		$loop_bed->{$gid1}->{$gid2} += 1;
			
	}
}
close(IN);

####################### Output files ######################
foreach my $gid1 (sort {($a=~/.+_([0-9]+)$/)[0] <=> ($b=~/.+_([0-9]+)/)[0]} keys %$loop_bed){
        foreach my $gid2 (sort {($a=~/.+_([0-9]+)$/)[0] <=> ($b=~/.+_([0-9]+)/)[0]} keys %{$loop_bed->{$gid1}}){
                #my $rand = $random_bed->{$gid1}->{$gid2};
		my $val = $loop_bed->{$gid1}->{$gid2};
		print join("\t", $gid1, $gid2, $val)."\n";
        }
}

exit;
