#!usr/bin/perl
# Script is tailored for obtaining unique alleles of male founders by comparing allele presence/absence in different sets of their offspring.
# Script reads in allele tables of three subgroups and compares allele content between those
# the output file has a list of alleles present in one, but absent in other two groups. 
# Usage: perl presence.absence.analysis.pl presece.allele.table absence1.allele.table absence2.allele.table output.txt

use strict;
use warnings;
local $" = "\t";

open (FH1, '<', $ARGV[0]) or die "Can't open $ARGV[0]: $!\n";
open (FH2, '<', $ARGV[1]) or die "Can't open $ARGV[1]: $!\n";
open (FH3, '<', $ARGV[2]) or die "Can't open $ARGV[2]: $!\n";
open (FH4, '>', $ARGV[3]) or die "Can't open $ARGV[3]: $!\n";


while (<FH1>) {
        
        my $presence = $_;
        my $absence1 = <FH2>;
        my $absence2 = <FH3>;
        
        if ($presence !~ /^#/) {
        
                chomp $presence;
                chomp $absence1;
                chomp $absence2;

                my @presence = split(/\t/, $presence);
                my @absence1 = split(/\t/, $absence1);
                my @absence2 = split(/\t/, $absence2);

                print STDOUT "$presence[1]\t$absence1[1]\t$absence2[1]\n";

                my $presLgth = scalar @presence;
                my @alleles = @presence[2..$presLgth - 1];

                my %seen =();
                my @uniq =();

                #make an array with unique alleles
                foreach my $item (@alleles) {
                        push(@uniq, $item) unless $seen{$item}++;
                }

                foreach my $item (@uniq) {
                        if ( grep( /^$item$/, @absence1 ) || grep( /^$item$/, @absence2 )) {
                                print STDOUT "$item\n@absence1\n@absence2\n";
                                } else {
                                print FH4 "$presence[0]\t$presence[1]\t$item\n";
                                print STDOUT "unique value detected\n$item\n@absence1\n@absence2\n";
                                }
                }
        }
}

