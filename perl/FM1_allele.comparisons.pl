#!usr/bin/perl
#This script is individually tailored for the first male founder analysis
#it reads in a file with unique alleles of the first male founder and determines if each particular allele 
#is present in the two temporal subgroups and bins unique alleles of the first male founder into 4 output files:
#TT (absent in both subgroups); FT (present in first, absent in the other), TF (vice versa), FF (present in both)
#usage: perl FM_allele.comparisons.pl FM1_uniq_allele.table subgroup2.alele.table subgroup3.allele.table out.summary

use strict;
use warnings;
local $" = "\t";

open (FH1, '<', $ARGV[0]) or die "Can't open $ARGV[0]: $!\n";
open (FH2, '>', $ARGV[3]) or die "Can't open $ARGV[3]: $!\n";

#make output files to store coordinates of alleles in a particular bin
open (BIN1, '>', "FM1-offsp.unique.allele.bin1.TT") or die "Can't open BIN1: $!\n";
open (BIN2, '>', "FM1-offsp.unique.allele.bin2.FT") or die "Can't open BIN2: $!\n";
open (BIN3, '>', "FM1-offsp.unique.allele.bin3.TF") or die "Can't open BIN3: $!\n";
open (BIN4, '>', "FM1-offsp.unique.allele.bin4.FF") or die "Can't open BIN4: $!\n";


#define 4 bins (T stands for "absence of the allele is TRUE"; F  - "absence of the allele is FALSE")
#(T -> TRUE == 0; F -> False != 0)
my $TT=0;
my $FT=0;
my $TF=0;
my $FF=0;

my $total=0;

while (<FH1>) {
        chomp $_;
        my @data = split (/\t/, $_);
        my @sg2Alleles = ();
        my @sg3Alleles = ();
        my $FM_in_SG2 = 0;
        my $FM_in_SG3 = 0;
        
        #print "@data\n";
        
        #loop through the subgroup2 and look for the line with corresponding chr and position of the allele
        open (FH3, '<', $ARGV[1]) or die "Can't open $ARGV[1]: $!\n";

        my $LINE2 = '';
        do {$LINE2 = <FH3>} until $LINE2 =~ /^$data[0]\t$data[1]/ || eof; 
        chomp $LINE2;
        my @subgroup2 = split(/\t/, $LINE2);
        print "SG2:@subgroup2[0..1]\n";
        my $sg2Lgth = scalar @subgroup2;
        @sg2Alleles = @subgroup2[2..$sg2Lgth - 1];


        #loop through the subgroup3 and find the line with corresponding chr and position of the allele
        open (FH4, '<', $ARGV[2]) or die "Can't open $ARGV[2]: $!\n";
        my $LINE3 = '';
        do {$LINE3 = <FH4>} until $LINE3 =~ /^$data[0]\t$data[1]/ || eof; 
        chomp $LINE3;
        my @subgroup3 = split(/\t/, $LINE3);
        print "SG3:@subgroup3[0..1]\n";
        my $sg3Lgth = scalar @subgroup3;
        @sg3Alleles = @subgroup3[2..$sg3Lgth - 1];

        print "$data[2]\n@sg2Alleles\n@sg3Alleles\n";
        my $g2 = 0;
        my $g3 = 0;

        if ( grep /^$data[2]$/, @sg2Alleles){$g2 = 1;}
        if ( grep /^$data[2]$/, @sg3Alleles){$g3 = 1;}

        if ($g2 == 0 && $g3 == 0) {print BIN1 "@data\n"; $TT++; $total++;}
        if ($g2 == 1 && $g3 == 0) {print BIN2 "@data\n"; $FT++; $total++;}
        if ($g2 == 0 && $g3 == 1) {print BIN3 "@data\n"; $TF++; $total++;}
        if ($g2 == 1 && $g3 == 1) {print BIN4 "@data\n"; $FF++; $total++;}

}

print FH2 "Summarizing file $ARGV[0]\n";
print FH2 "Total number of alleles across bins: $total\n";      
print FH2 "TT\t$TT\nFT\t$FT\nTF\t$TF\nFF\t$FF\n";

