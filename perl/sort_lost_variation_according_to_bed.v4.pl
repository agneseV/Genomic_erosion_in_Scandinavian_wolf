#!usr/bin/perl
#Individually tailored script to count the number of concordant SNPs between the lost 1 Mb haplotype clusters (bed file) and lost individual female founder's alleles in 1983-1993.
#This script reads in a list of SNP positions and compares it to a bed file in order to detrmine concordant SNPs - those that fall into regions defined in bed file.
#Positions of concordant SNPs are printed to separate file for each founder (ends with .concordantSNPs) and number of SNPs per each 1 Mb haplotype cluster are printed in output file
#perl sort_lost_variation_according_to_bed.v4.pl input.intervals.bed output


use strict;
use warnings;

open (FH1, '<', $ARGV[0]) or die "Can't open $ARGV[0]: $!\n"; 
open (FH4, '>', $ARGV[1]) or die "Can't open $ARGV[1]: $!\n"; 

#Define all SNP lists that need to be compared
my $infile_FF = "D-85-01.alleles.not.in.1983-1993";
my $outfile_FF = "D-85-01.alleles.not.in.1983-1993.SNPresolution.concordantSNPs";


my $FF_concordant_SNPs = '';
my $FM1_concordant_SNPs = '';
my $FM2_concordant_SNPs = '';

while (<FH1>) {
        
        next if ($_ =~ /chr/);
        chomp $_;
        my @data = split(/\t/,$_);
        my $chr = $data[0];
        my $begc = $data[1];
        my $endc = $data[2];
        my $founder = $data[3];
        my $nr_of_SNPs = '';
        
        next if ( $data[1] == 0 && $data[2] == 0 );     

        if ($founder =~ /^FF/) {
                open (FH2, '<', $infile_FF ) or die "Can't open $infile_FF: $!\n";
                open (FH3, '>>', $outfile_FF ) or die "Can't open $outfile_FF: $!\n";
                print STDOUT "$chr\t$begc\t$endc\t$founder\n";          
                print STDOUT "Start processing new FF region on chr $chr...\n";
                while (<FH2>) {
                        chomp $_;
                        my @snp_data = split(/\t/,$_);
                        my $snp_chr = $snp_data[0];
                        my $snp_pos = $snp_data[1];
                        #print STDOUT "$snp_chr\t$chr:$snp_pos\t$begc\t$endc\n";
                        if ($snp_chr eq $chr && $snp_pos >= $begc && $snp_pos <= $endc) {                       
                                print FH3 "$snp_chr\t$snp_pos\t$chr:$begc:$endc:$founder\n";
                                ++$FF_concordant_SNPs;
                                ++$nr_of_SNPs;
                        }
                }
}
print FH4 "@data\t$nr_of_SNPs\n"; 

}
 
print STDOUT "FF_concordant_SNPs\t$FF_concordant_SNPs\n";
