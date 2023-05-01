#!usr/bin/perl
#This script reads in a file and prints out histogram of data from the indicated column
#Usage perl ./plot.histogram.pl input.txt columNr-1

use strict;
use warnings;
use Statistics::Histogram;

open (FH1, '<', $ARGV[0]) or die "Can't open $ARGV[0]: $!\n";

my @hist = ();

while (<FH1>) {
		chomp $_;
		my @data = split(/\t/,$_);
        push @hist, $data[$ARGV[1]];
        } 
print STDOUT get_histogram(\@hist);

