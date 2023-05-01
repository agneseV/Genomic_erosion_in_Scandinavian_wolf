#!usr/bin/perl
#Script reads in a set of .PHASE.out files (for example, all output files from individual 1 Mb window phasing of entier chromosome) and extracts BESTPAIRS_SUMMARY part
#Output is a table, where first column is a list of individual sample IDs and remaining columns contain haplotype IDs of particular windows from the 1st step of phasing.
#Intended for collecting results after running PHASE in small windows across entier chromosome.
#Usage: perl Extract_haplotype_pairs_PHASE.v2.pl pattern_match.PHASE.out output.txt
#example of a pattern_match: PHASING/1MB_windows/chr${chr}/PHASE_1_newfilt/Scand_wolf.markers.for.phasing1_1Mb_*0.PHASE.out


use strict;
use warnings;
use Sort::Naturally;

print STDOUT "$ARGV[0] \n";
my @FILES = nsort <$ARGV[0]>;


print STDOUT "@FILES \n";

open (FH2, '>', $ARGV[1]) or die "Can't open $ARGV[1]: $!\n";
open (FH3, '<', $FILES[0]) or die "Can't open $FILES[0]: $!\n";
print FH2 "SampleID\n";

while (<FH3>) {
                my @data =();
                my @haps =();
                if ($_ =~/^#/){
                #print STDOUT $_;
                chomp $_;
                @data = split(/:/,$_);
                print FH2 "$data[0]_1\n$data[0]_2\n";
        }
}
foreach my $file (@FILES) {
                my @window = split(/b_/,$file);
        print FH2 "$window[1]\n";
        open (FH, '<', $file ) or die "Can't open $ARGV[0]: $!\n";
        while (<FH>) {
                my @data =();
                my @haps =();
                if ($_ =~/^#/){
                #print STDOUT $_;
                chomp $_;
                @data = split(/:/,$_);
                @haps = split(/[,\(\)]/,$data[1]);
                print FH2 "$haps[1]\n$haps[2]\n";
        }
    }

}

