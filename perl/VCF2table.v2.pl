#!usr/bin/perl
#This script transforms a vcf file to a table of alleles
#Usage: perl VCF2table.v2.pl input.vcf.gz output.allele.table

use strict;
use warnings;
local $" = "\t";

open (FH, "-|", "gzip -dc $ARGV[0]") or die "Can't open $ARGV[0]: $!\n"; # input vcf
open (FH2, '>', $ARGV[1]) or die "Can't open $ARGV[1]: $!\n"; # output file

#print STDOUT "opened file\n";

my $length='';

while (<FH>) {
    chomp $_;
#       print STDOUT "$_\n";

    if ($_ =~ /^#CHR/){
        print STDOUT "got CHR\n";
        my @heder = split(/\t/,$_);
        print STDOUT "heder is @heder\n";
        $length = scalar @heder;
        print STDOUT "length of heder is $length\n";
        my @indiv = @heder[9 .. $length - 1];
        print STDOUT "exporting individuals @indiv to a table\n";
        print FH2 join("\t", $heder[0], $heder[1], map { $_, $_ }  @indiv) . "\n";
        }

     if ($_ =~ /^[\dX]/){
        
        my @data = split(/\t/,$_);
        my $ref_allele = $data[3];
        my $alt_allele = $data[4];
        my @alleles = ();

        for(my $i=9; $i <= $length - 1; $i++) {                       
                my @geno = split /[:\/\|]/, $data[$i];
                #print STDOUT "my geno is @geno\n";

                                #assign allele 1  
                                if ($geno[0] =~ 0){
                        push @alleles, $ref_allele;
                } elsif ($geno[0]=~ 1){
                    push @alleles, $alt_allele;
                                } else {
                                        push @alleles, ".";
                                }
                        
                                #assign allele 2  
                                if ($geno[1] =~ 0){
                        push @alleles, $ref_allele;
                }
                                elsif ($geno[1]=~ 1){
                    push @alleles, $alt_allele;
                                }
                                else {
                                        push @alleles, ".";
                                }
                        }
        print FH2 "$data[0]\t$data[1]\t@alleles\n";
        }
}            

