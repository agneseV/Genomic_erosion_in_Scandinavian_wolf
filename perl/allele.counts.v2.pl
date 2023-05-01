#!usr/bin/perl
#This script reads in allele.table of a single individual and counts the occurance of each allele in 3 different subgroups
#Usage: perl allele.counts.v2.pl input.allele.table subgroup1.allele.table subgroup2.allele.table subgroup3.allele.table output.allele.counts.txt

use strict;
use warnings;
local $" = "\t";

open (FH1, '<', $ARGV[0]) or die "Can't open $ARGV[0]: $!\n";
open (FH2, '<', $ARGV[1]) or die "Can't open $ARGV[1]: $!\n";
open (FH3, '<', $ARGV[2]) or die "Can't open $ARGV[2]: $!\n";
open (FH4, '<', $ARGV[3]) or die "Can't open $ARGV[3]: $!\n";
open (FH5, '>', $ARGV[4]) or die "Can't open $ARGV[4]: $!\n";

print FH5 "CHR\tPOS\tFF1\tGroup1\tGroup2\tGroup3\tFF2\tGroup1\tGroup2\tGroup3\n";

while (<FH1>) {
        
        my $input = $_;
        my $subgroup1 = <FH2>;
        my $subgroup2 = <FH3>;
        my $subgroup3 = <FH4>;
        
        if ($input !~ /^#/) {
        
                chomp $input;
                chomp $subgroup1;
                chomp $subgroup2;
                chomp $subgroup3;

                my @input = split(/\t/, $input);
                my @subgroup1 = split(/\t/, $subgroup1);
                my @subgroup2 = split(/\t/, $subgroup2);
                my @subgroup3 = split(/\t/, $subgroup3);

                my $sg1Lgth = scalar @subgroup1;
                my $sg2Lgth = scalar @subgroup2;
                my $sg3Lgth = scalar @subgroup3;

                my @sg1Alleles = @subgroup1[2..$sg1Lgth - 1];
                my @sg2Alleles = @subgroup2[2..$sg2Lgth - 1];
                my @sg3Alleles = @subgroup3[2..$sg3Lgth - 1];

                my $FF1_in_SG1 = 0;
                my $FF1_in_SG2 = 0;
                my $FF1_in_SG3 = 0;
                my $FF2_in_SG1 = 0;
                my $FF2_in_SG2 = 0;
                my $FF2_in_SG3 = 0;

                my @out = @input[0..1];
        
                #count acureances of FF1 allele in three subgroups, store counts in @out array
                if ( grep( /^$input[2]$/, @sg1Alleles ) ) {
                $FF1_in_SG1 = grep (/^$input[2]$/, @sg1Alleles);
                }
                if ( grep( /^$input[2]$/, @sg2Alleles ) ) {
                $FF1_in_SG2 = grep (/^$input[2]$/, @sg2Alleles);
                }
                if ( grep( /^$input[2]$/, @sg3Alleles ) ) {
                $FF1_in_SG3 = grep (/^$input[2]$/, @sg3Alleles);
                }
                push @out, ($input[2], $FF1_in_SG1, $FF1_in_SG2, $FF1_in_SG3);

                #count acureances of FF2 allele in three subgroups, store counts in @out array
                if ( grep( /^$input[3]$/, @sg1Alleles ) ) {
                $FF2_in_SG1 = grep (/^$input[3]$/, @sg1Alleles);
                }
                if ( grep( /^$input[3]$/, @sg2Alleles ) ) {
                $FF2_in_SG2 = grep (/^$input[3]$/, @sg2Alleles);
                }
                if ( grep( /^$input[3]$/, @sg3Alleles ) ) {
                $FF2_in_SG3 = grep (/^$input[3]$/, @sg3Alleles);
                }
                push @out, ($input[3], $FF2_in_SG1, $FF2_in_SG2, $FF2_in_SG3);
                print FH5 "@out\n";

        }
}
