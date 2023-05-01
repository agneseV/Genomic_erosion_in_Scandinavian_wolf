#!usr/bin/perl
#This script is intended to be used after 2nd phasing round (PHASE results for chromosome-level haplotypes).
#It reads in a PHASE.out file and extracts info from BESTPAIRS1 section.
#output file is formated to be imported in the specially designated Excel sheet for manual curration.
#Usage: perl Collect.PHASE.haps.pl input.PHASE.out output.out.forExcel.txt
#If several runs are compared, input.PHASE.out can also be a pattern match of file names.

use strict;
use warnings;

my @FILES = <"$ARGV[0]">; # PHASE.out file (can also be used a patern match if several runs compared)
open (FH2, '>', $ARGV[1]) or die "Can't open $ARGV[1]: $!\n";

foreach my $file (@FILES) {
        print FH2 "$file\n";
        open (FH, '<', $file ) or die "Can't open $ARGV[0]: $!\n";
        while (<FH>) {
        my @data=();
                if ($_ =~/^0 #/){
                        #print STDOUT $_;
                        chomp $_;
                        @data = split(/#/,$_);
                        #print STDOUT "@data";
                        my $hap1 = <FH>;
                        my $hap2 = <FH>;
                        print FH2 "$data[1] $hap1$data[1] $hap2";
        }
    }

}

