#!/usr/bin/perl
use strict;
my $usage = "Usage: pick.distance.of.loop.pl <bed> <anchor_to_anchor> \n";
my ($bed, $anchor) = @ARGV;
if(not defined $bed){
        die($usage);
}
my $beg_hash;
my $end_hash;
open(IN, $bed);
while(my $line= <IN>){
        chomp $line;
        my ($chr,$beg,$end,$id)= split "\t", $line;
                $beg_hash->{$id}=$beg;
                $end_hash->{$id}=$end;
}
close(IN);
open(IN, $anchor);
while(my $line= <IN>){
        chomp $line;
        my ($A1,$A2,@res)= split "\t", $line;
        my @str1 = split /\_/, $A1;
        my $a1=@str1[1];
        my @str2 = split /\_/, $A2;
        my $a2=@str2[1];
        my $dist;
        if($a1<$a2){
                $dist=$beg_hash->{$A2}-$end_hash->{$A1};
        }else{
                $dist=$beg_hash->{$A1}-$end_hash->{$A2};
        }
        print join("\t",$line,$dist)."\n";
}
close(IN);
exit;

