#!/usr/bin/perl
use strict;

my $usage =     "Usage:./pair_two_SAM.pl <sam1> <sam2> <readname>\n".
                "\tAfter mapping each end of a PE run independently, this program take the two SAM files and link them. Seven output files will be produces: mapped_pair_file, R1_mapped_file&R3_unmapped_file,R1_unmapped_file&R3_mapped_file, R1_pair_unmapped_file&R3_pair_unmapped_file. These seven files will be futher used to do analysis.\n";

my ($file1, $file2, $readName) = @ARGV;
if(not defined $file2){
        die($usage);
}

open (FILE1, $file1);
open (FILE2, $file2);
open (MappedPair, ">".$readName.".mapped.pair");
#open (Mapped1, ">".$readName.".R1.mapped");
#open (Mapped2, ">".$readName.".R3.mapped");
#open (UnMapped1, ">".$readName.".R1.unmapped");
#open (UnMapped2, ">".$readName.".R3.unmapped");
#open (UnMappedPair1,">".$readName.".R1.pair.unmapped");
#open (UnMappedPair2,">".$readName.".R3.pair.unmapped");

my $count1=0; my $count2=0; my $count3=0;

while ((my $line1 = <FILE1>) and (my $line2 = <FILE2>)){
        chomp $line1; chomp $line2;
        while(substr($line1,0,1) eq '@'){
#               print $line1."\n";
                $line1 = <FILE1>; chomp $line1;
        }
        while(substr($line2,0,1) eq '@'){
#               print $line2."\n";
                $line2 = <FILE2>; chomp $line2;
        }
        my ($id1, $flag1, $chr1, $pos1, $qal1, $cigar1, $mate_chr1, $mate_pos1, $size1, $seq1, @rest1) = split "\t", $line1;
        my ($id2, $flag2, $chr2, $pos2, $qal2, $cigar2, $mate_chr2, $mate_pos2, $size2, $seq2, @rest2) = split "\t", $line2;
        $id1 =~ s/\/.$//; $id2 =~ s/\/.$//;


        #if($qal1 < 10 || $qal2 < 10) { #next;}
        if($id1 ne $id2){
                die("Error: The two sam files are not pair-end!\n");
        }
	my $flag1_orig=$flag1;
	my $flag2_orig=$flag2;
        $flag1 = $flag1 | 64;                           # read1 flag
        $flag2 = $flag2 | 128;                          # read2 flag
        $flag1 = $flag1 | 1; $flag2 = $flag2 | 1;       # flag say both reads are one of a pair
        if(($flag1&4) && ($flag2&4)) {  #Both unmapped 
		$count1=$count1+1;
		#print UnMappedPair1 join("\t", $id1, $flag1_orig, $chr1, $pos1, $qal1, $cigar1, $mate_chr1, $mate_pos1, $size1, $seq1, @rest1)."\n";	
		#print UnMappedPair2 join("\t", $id2, $flag2_orig, $chr2, $pos2, $qal2, $cigar2, $mate_chr2, $mate_pos2, $size2, $seq2, @rest2)."\n";
	} elsif(($flag1&4) && !($flag2&4) ){ #Read1 unmapped, Read2 mapped
		$count2=$count2+1;
		#print UnMapped1 join("\t", $id1, $flag1_orig, $chr1, $pos1, $qal1, $cigar1, $mate_chr1, $mate_pos1, $size1, $seq1, @rest1)."\n";
		#print Mapped2 join("\t", $id2, $flag2_orig, $chr2, $pos2, $qal2, $cigar2, $mate_chr2, $mate_pos2, $size2, $seq2, @rest2)."\n";
	} elsif( !($flag1&4) && ($flag2&4)){ #Read1 mapped, Read2 unmapped
		$count3=$count3+1;
		#print Mapped1 join("\t", $id1, $flag1_orig, $chr1, $pos1, $qal1, $cigar1, $mate_chr1, $mate_pos1, $size1, $seq1, @rest1)."\n";
		#print UnMapped2 join("\t", $id2, $flag2_orig, $chr2, $pos2, $qal2, $cigar2, $mate_chr2, $mate_pos2, $size2, $seq2, @rest2)."\n";
	}
	else{	#Both mapped
        	$flag1 = $flag1 | 2; $flag2 = $flag2 | 2;
       	 	my ($strand1, $strand2) = ("+", "+");
        	my ($beg1, $beg2) = ($pos1, $pos2);
        	if($flag1 & 16) { $flag2 = $flag2 | 32; $strand1 = "-"; }       # mate of read2 is - strand
        	if($flag2 & 16) { $flag1 = $flag1 | 32; $strand2 = "-"; }       # mate of read1 is - strand

        	$mate_pos1 = $pos2; $mate_pos2 = $pos1;
        	if($chr1 eq $chr2){
                	$mate_chr1 = "="; $mate_chr2 = "=";
                	my ($left1, $right1) = ($pos1, $pos1 + length($seq1));
                	my ($left2, $right2) = ($pos2, $pos2 + length($seq2));
                	$size1 = $pos2 - $pos1;
                	if($size1 > 0){
                        	$size1 += length($seq2);
                	}else{
                        	$size1 -= length($seq1);
                	}
                	$size2 = 0 - $size1;
        	}else{
                	$mate_chr2 = $chr1; $mate_chr1 = $chr2;
                	$size1 = 0; $size2 = 0;
        	}
        	print MappedPair join("\t", $id1, $flag1, $chr1, $pos1, $qal1, $cigar1, $mate_chr1, $mate_pos1, $size1, $seq1, @rest1)."\n";
        	print MappedPair join("\t", $id2, $flag2, $chr2, $pos2, $qal2, $cigar2, $mate_chr2, $mate_pos2, $size2, $seq2, @rest2)."\n";
	}
}

#print join("\t",$count2, $count2, $count3)."\n";	#count1: both unmapped; #count2: R1 unmapped&R2 mapped; #count3: R1 mapped & R2 unmapped
close FILE1;
close FILE2;
close MappedPair;
#close Mapped1;
#close Mapped2;
#close UnMapped1;
#close UnMapped2;
#close UnMappedPair1;
#close UnMappedPair2;

exit;
