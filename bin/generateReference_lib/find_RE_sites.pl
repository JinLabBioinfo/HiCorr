#!/usr/bin/perl

use strict;

my $usage = 	"Usage:./find_RE_sites.pl <genome_fa> <genome_size> <sequence> <generateLibPath>\n".
		"\tThis program find <sequence> sites in <genome>\n".
		"\tOutput is in 1-system.\n";

my ($genome_fa_dir, $genome_chrom_size, $cutsite,$lib_path) = @ARGV;
#if(not defined $seq){
#	die($usage);
#}

#my $home = `echo \$HOME`;
#chomp $home;
#my $folder="/mnt/NFS/geneITS0/JinLab/fxj45/GenebankDB/$genome";
#if($genome=="hg19"){
open(IN, $genome_chrom_size);
#}else{
#open(IN, "/mnt/rstor/genetics/JinLab/xxl244/Reference_Indexes/mm10_bowtie_index/mm10.chrom.sizes");}
my $sizeref;
while(my $line = <IN>){
	my ($chr, $size) = split "\t", $line;
	if($chr =~ /_/ || $chr eq "chrM"){
		next;
	}
	$sizeref->{$chr} = $size;
}
close(IN);
#my $fa_dir;
#if($genome=="mm10"){
#	$fa_dir = "/mnt/rstor/genetics/JinLab/xxl244/Reference_Indexes/mm10_bowtie_index/";
#}else{
#	$fa_dir = "/mnt/rstor/genetics/JinLab/xxl244/Reference_Indexes/hg19/Homo_sapiens/UCSC/hg19/Sequence/Chromosomes/";}

foreach my $chr (sort keys %{$sizeref}){
	my $size = $sizeref->{$chr};
	my @pos = `$lib_path/sequence_match.pl -c $genome_fa_dir/$chr.fa $cutsite`;
	chomp @pos;
	my $len = length($cutsite);
	while(my $loc = shift @pos){
		print join("\t", $chr, $loc, $loc + $len - 1)."\n";
	}
}
exit;
