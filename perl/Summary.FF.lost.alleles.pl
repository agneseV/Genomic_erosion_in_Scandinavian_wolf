#!usr/bin/perl
# This script is tailored specifically to count lost alleles of the female founder
# Script reads in the output from allele.counts.v2.pl and bins all alleles into 8 different files according to presence/absence pattern within 3 subgroups
# T stands for "the absence of allele is TRUE"; F stands for "the absence of allele is FALSE"
# usage: perl Summary.FF.lost.alleles.pl allele.counts.txt allele.counts.summary.txt

use strict;
use warnings;
local $" = "\t";

open (FH1, '<', $ARGV[0]) or die "Can't open $ARGV[0]: $!\n";
open (FH2, '>', $ARGV[1]) or die "Can't open $ARGV[3]: $!\n";

#make output files to store coordinates of alleles of a particular bin
open (BIN1, '>', "D-85-01.allele.counts.bin1.TTF") or die "Can't open BIN1: $!\n";
open (BIN2, '>', "D-85-01.allele.counts.bin2.TFT") or die "Can't open BIN2: $!\n";
open (BIN3, '>', "D-85-01.allele.counts.bin3.FTT") or die "Can't open BIN3: $!\n";
open (BIN4, '>', "D-85-01.allele.counts.bin4.TFF") or die "Can't open BIN4: $!\n";
open (BIN5, '>', "D-85-01.allele.counts.bin5.FFT") or die "Can't open BIN5: $!\n";
open (BIN6, '>', "D-85-01.allele.counts.bin6.FTF") or die "Can't open BIN6: $!\n";
open (BIN7, '>', "D-85-01.allele.counts.bin7.TTT") or die "Can't open BIN7: $!\n";
open (BIN8, '>', "D-85-01.allele.counts.bin8.FFF") or die "Can't open BIN8: $!\n";


#define 8 bins based on presence/absence pattern
#3 reference periods are in consecutive order
my $TTF=0;
my $TFT=0;
my $FTT=0;
my $TFF=0;
my $FFT=0;
my $FTF=0;
my $TTT=0;
my $FFF=0;

my $total=0;

<FH1>;
while (<FH1>) {
        chomp $_;
#       print "$_";
        my @data = split (/\t/, $_);
        my @FF1alleles = @data[3..5];
        my @FF2alleles = @data[7..9];
        
#       print "alleles to count:\n@FF1alleles\n@FF2alleles\n";

        if ($FF1alleles[0] == 0 && $FF1alleles[1] == 0 && $FF1alleles[2] != 0) { $TTF++; $total++; print BIN1 "@data[0..2]\n";}
        if ($FF1alleles[0] == 0 && $FF1alleles[1] != 0 && $FF1alleles[2] == 0) { $TFT++; $total++; print BIN2 "@data[0..2]\n";}
        if ($FF1alleles[0] != 0 && $FF1alleles[1] == 0 && $FF1alleles[2] == 0) { $FTT++; $total++; print BIN3 "@data[0..2]\n";}
        if ($FF1alleles[0] == 0 && $FF1alleles[1] != 0 && $FF1alleles[2] != 0) { $TFF++; $total++; print BIN4 "@data[0..2]\n";}
        if ($FF1alleles[0] != 0 && $FF1alleles[1] != 0 && $FF1alleles[2] == 0) { $FFT++; $total++; print BIN5 "@data[0..2]\n";}
        if ($FF1alleles[0] != 0 && $FF1alleles[1] == 0 && $FF1alleles[2] != 0) { $FTF++; $total++; print BIN6 "@data[0..2]\n";}
        if ($FF1alleles[0] == 0 && $FF1alleles[1] == 0 && $FF1alleles[2] == 0) { $TTT++; $total++; print BIN7 "@data[0..2]\n";}
        if ($FF1alleles[0] != 0 && $FF1alleles[1] != 0 && $FF1alleles[2] != 0) { $FFF++; $total++; print BIN8 "@data[0..2]\n";}
        
        if ($FF2alleles[0] == 0 && $FF2alleles[1] == 0 && $FF2alleles[2] != 0) { $TTF++; $total++; print BIN1 "@data[0..1]\t$data[6]\n";}
        if ($FF2alleles[0] == 0 && $FF2alleles[1] != 0 && $FF2alleles[2] == 0) { $TFT++; $total++; print BIN2 "@data[0..1]\t$data[6]\n";}
        if ($FF2alleles[0] != 0 && $FF2alleles[1] == 0 && $FF2alleles[2] == 0) { $FTT++; $total++; print BIN3 "@data[0..1]\t$data[6]\n";}
        if ($FF2alleles[0] == 0 && $FF2alleles[1] != 0 && $FF2alleles[2] != 0) { $TFF++; $total++; print BIN4 "@data[0..1]\t$data[6]\n";}
        if ($FF2alleles[0] != 0 && $FF2alleles[1] != 0 && $FF2alleles[2] == 0) { $FFT++; $total++; print BIN5 "@data[0..1]\t$data[6]\n";}
        if ($FF2alleles[0] != 0 && $FF2alleles[1] == 0 && $FF2alleles[2] != 0) { $FTF++; $total++; print BIN6 "@data[0..1]\t$data[6]\n";}
        if ($FF2alleles[0] == 0 && $FF2alleles[1] == 0 && $FF2alleles[2] == 0) { $TTT++; $total++; print BIN7 "@data[0..1]\t$data[6]\n";}
        if ($FF2alleles[0] != 0 && $FF2alleles[1] != 0 && $FF2alleles[2] != 0) { $FFF++; $total++; print BIN8 "@data[0..1]\t$data[6]\n";}

}
print FH2 "Summarizing file $ARGV[0]\n";
print FH2 "Total number of alleles across bins: $total\n";      
print FH2 "TTF\t$TTF\nTFT\t$TFT\nFTT\t$FTT\nTFF\t$TFF\nFFT\t$FFT\nFTF\t$FTF\nTTT\t$TTT\nFFF\t$FFF\n";

