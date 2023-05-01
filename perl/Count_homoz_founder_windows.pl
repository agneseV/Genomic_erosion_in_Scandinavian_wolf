#!usr/bin/perl
#This script reads in a text file with pairwise comparison matrices of all six founder haplotypes for all chromosomes and outputs a table of homozygous windows per founder per chromosome
#Usage: perl Count_homoz_founer_windows.pl pairwise_comparison_matrices.txt output.txt

use strict;
use warnings;


open (FH1, '<', $ARGV[0]) or die "Can't open $ARGV[0]: $!\n";
open (FH2, '>', $ARGV[1]) or die "Can't open $ARGV[1]: $!\n";

print FH2 "Chr\tFF\tFM1\tFM2\n";

while (<FH1>) {

	for (my $i=1; $i <= 39; $i++) {	

		next unless $_ =~ /^$i\t/; 
		my $FF_line = <FH1>;
		chomp $FF_line;
		my @data_FF = split(/\t/,$FF_line);
		#print STDOUT "@data_FF\n";
		<FH1>; 
		my $FM1_line = <FH1>;
		chomp $FM1_line;
		my @data_FM1 = split(/\t/,$FM1_line);
		<FH1>; 
		my $FM2_line = <FH1>;
		chomp $FM2_line;
		my @data_FM2 = split(/\t/,$FM2_line);
		print FH2 "$i\t$data_FF[2]\t$data_FM1[4]\t$data_FM2[6]\n";
	}
}

