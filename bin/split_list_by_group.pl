#!/usr/bin/perl

use strict;

my ($group_file, $list_file) = @ARGV;

open(IN, $group_file) || die("Error: Cannot open $group_file!\n");
my $i=0;
while(my $line = <IN>){
	$i = $i+1;
        chomp $line;
        my ($group, $lambda, $fraction) = split "\t", $line;
        my $low_lim = $lambda * (1 - $fraction);
        my $high_lim = $lambda * (1 + $fraction);
        `cat $list_file | cut -f3-4 | awk '{if(\$2>$low_lim && \$2<$high_lim)print \$0}' > data_list.group.$group &` ;
	if($i==6){
		sleep 600;
		$i = 0;
	}
        #print "Is speed ok now?[enter to run more]";
        #<stdin>;
}
close(IN);
exit;
