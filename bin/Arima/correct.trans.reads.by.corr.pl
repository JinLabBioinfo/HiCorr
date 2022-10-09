#!/usr/bin/perl
use strict;
my ($trans_loop, $frag_bed, $len_20_group,$len_group_corr) = @ARGV;


#####################GC ###################################### #################

my $len_range;
open(IN, $len_20_group);
while(my $line = <IN>){
        chomp $line;
        my ($id, $min, $max) = split "\t", $line;
        $len_range->{$id} = "$min:$max";
}
close(IN);
my $frag_len_group;
open(IN, $frag_bed);
while(my $line = <IN>){
        chomp $line;
        my ($chr, $beg, $end, $id, $dist, $len) = split "\t", $line;
        $frag_len_group->{$id} = get_id($len, $len_range);
}
close(IN);


##################### get the fragment stat information ###########################
my $len_c;
open(IN, $len_group_corr);
while(my $line=<IN>){
	chomp $line;
	my ($g1, $g2, $corr) = split "\t", $line;
	$len_c->{$g1}->{$g2} = $corr;
}
close(IN);

################## Calculate group averages #######################################
open(IN, $trans_loop);
#open(OUT,">./facor.zero");
while(my $line = <IN>){
	chomp $line;
	my ($frag1, $frag2, $obs) = split "\t", $line;
	my $len_g1=$frag_len_group->{$frag1};
	my $len_g2=$frag_len_group->{$frag2};
	my $len_corr = $len_c->{$len_g1}->{$len_g2};
	my $avg=$obs/$len_corr;
	print join("\t",$frag1, $frag2, $avg)."\n";
	
}
close(IN);
close(OUT);
##############################################################
sub get_id{
        my ($val, $range) = @_;
        foreach my $id (keys %{$range}){
                my ($min, $max) = split ":", $range->{$id};
                if($val > $min && $val <= $max){
                        return $id;
                }
        }
#        die("Error: did not find a group\n");
}

