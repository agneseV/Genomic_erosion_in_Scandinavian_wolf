#!usr/bin/perl
#This script reads in a vcf file with SNP genotypes and transforms it into an inputfile for PHASE 
#Chromosome needs to be specified
#Usage: perl Transform_VCF2PHASE.pl input.vcf PHASE.inp chromosome

use strict;
use warnings;
local $" = "\t";

open (FH, '<', $ARGV[0]) or die "Can't open $ARGV[0]: $!\n"; # input vcf 
open (FH2, '>', $ARGV[1]) or die "Can't open $ARGV[1]: $!\n"; # output file

my $chr=$ARGV[2];
my @samples;
my @colums;
my @POS;
my $type = '';;
my $nr_of_samples = '';
my $nr_of_SNPs = '';

while (<FH>) {
        my $line = $_;
        my @data;
        chomp $line;
        if ($_ =~ /^#CHROM/){
        
                @colums = split(/\t/,$line);
                $nr_of_samples = scalar @colums - 9;
                @samples = @colums[9..scalar @colums -1];
                                                
                #print STDOUT "@colums\n$nr_of_samples\t@samples";              
                }

    elsif ($_ =~ /^$chr/){
  
        @data = split(/\t/,$line);
        $type = join '', $type, 'S';
        push @POS, $data[1];
        }
        $nr_of_SNPs = scalar @POS;
     
     }
#print STDOUT "@POS\n";
print FH2 "$nr_of_samples\n$nr_of_SNPs\nP@POS\n$type\n";

my $i = 9;
foreach my $ind (@samples){
     
     open (FH, '<', $ARGV[0]) or die "Can't open $ARGV[0]: $!\n";

     my $geno= '';
     my @alleleA;
     my @alleleB;
    
     
     while (<FH>) {
        my @data;
        my $line = $_;
                if ($_ =~ /^$chr/){
                        chomp $line;
                @data = split(/\t/,$line);
                $geno = $data[$i];
                #print STDOUT "$geno and $data[$i]\n";
                }       
                if ($geno =~ /^0[\/\|]0/){
                        push @alleleA, $data[3];
                        push @alleleB, $data[3];
                        }
                elsif ($geno=~ /^1[\/\|]0/){
                        push @alleleA, $data[4];
                        push @alleleB, $data[3];
                        }
                elsif ($geno =~ /^0[\/\|]1/){
                        push @alleleA, $data[3];
                        push @alleleB, $data[4];
                        }
                elsif ($geno =~ /^1[\/\|]1/){
                        push @alleleA, $data[4];
                        push @alleleB, $data[4];
                        }
                elsif ($geno =~ /^\.[\/\|]\./){
                        push @alleleA, "?";
                        push @alleleB, "?";
                        }
                }       
        print FH2 "#$ind\n@alleleA\n@alleleB\n";
    $i++;
    #print STDOUT "$i\n";               
    }

