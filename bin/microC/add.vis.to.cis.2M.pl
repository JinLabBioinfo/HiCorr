#!/usr/bin/perl
use strict;
my $usage = "Usage: ./add.vis.to.2M.loop.pl <cis_loop.after.dist.len> <visibility.list> \n";
my ($loop,$vis) = @ARGV;
#if(not defined $loop){
 #       die($usage);
#}
my $vis_lis;
open(IN, $vis);
while(my $line= <IN>){
        chomp $line;
        my ($frag,$vis_value)= split "\t", $line;
		$vis_lis->{$frag}=$vis_value;
}
close(IN);
open(IN, $loop);
while(my $line= <IN>){
        chomp $line;
        my ($frag1,$frag2,$obs,$expect)= split "\t", $line;
	my $vis1=$vis_lis->{$frag1};
	my $vis2=$vis_lis->{$frag2};
	my $new_expt=$expect*$vis1*$vis2;
	print join("\t",$frag1,$frag2,$obs,$new_expt)."\n";
}
close(IN);
exit;
