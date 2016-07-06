#!/usr/bin/perl -w

use strict;
use warnings;

my $gene_results_file = $ARGV[0];
my $results_file = $ARGV[1];
my $pair_file = $ARGV[2];

open(RESULTS, $gene_results_file) || die("dead");
my $header = <RESULTS>;
while (my $line_in = <RESULTS>)
{
   chomp $line_in;
   my ($gene, $muts) = split("\t", $line_in);

   if($gene ne "." && $gene ne "1")
   {
      my $sample = `grep -w $gene $results_file | sort -k4,4 -n | cut -f 1 | head -1`;
      chomp $sample;

      my $lane = `grep -w $sample $pair_file | cut -f 2 | sed 's/#/_/'`;
      chomp $lane;

      my $gff_res = `grep "gene=$gene;" /lustre/scratch108/bacteria/jl11/assemblies/$lane/annotation.gff`;
      my @gff_ret = split("\t", $gff_res);

      if (!defined($gff_ret[4]))
      {
         $gff_res = `grep "gene=$gene\_1;" /lustre/scratch108/bacteria/jl11/assemblies/$lane/annotation.gff`;
         @gff_ret = split("\t", $gff_res);
      }

      my $length = $gff_ret[4]-$gff_ret[3]+1;

      print join("\t", $gene, $muts, $length) . "\n";
   }
}

exit(0);

