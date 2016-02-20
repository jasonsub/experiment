#!/usr/bin/perl -w

use 5.014;
use strict;
use warnings;

# Update: Xiaojun Sun, 02/19/2016
# Change 1: Input format change, now first line add #var as 3rd arg, then each line index and coeff are alternating
# e.g. line "10 2 1 5 ab 4 c" means f_10 = 1*f_2 + ab*f_5 + c*f_4
# Change 2: Besides newick tree output, added another output file listing coefficients for each poly
# involved with s-poly/reduction (not simplified), it is meant to be fed to Singular to check if any of
# them reduced to 0. Excluding those, remaining nonzero coeffs represents the core. Note for fitting
# the size of total poly, coeff[last] must be defined (if not used, then define as 0)

# Note: read_in file format:
# first line: start with "s", then a single number means # of original polys, then # of total GBs include "1" 
# followed by n lines means n new polys added to GB
# those lines: start with index of newly added poly (from s+1 to s+n)
# then a pair of numbers means spoly pair
# if more following, they mean polys used for reduction, exactly divided in the same order
# last line start with "e" means the spoly reduced to "1"
# start with "c" for comments
# Edit: 04/20/2015 by Xiaojun Sun
# Objective: translate the output from singular file (computing GB for UNSAT) showing all original polys involved for
# spoly and reduction to newick tree format displaying the hierarchy

open TREE, ">", $ARGV[0].".nh";  # auto-assign name
open COEF, ">", "tmp.coef";
my $cnt = 0;

my $i;
my $tmp;
my %lines;
my $origin;
my $n;
my $nvars;

while(<>){
	chomp;
	my $read_in = $_;
	my @items = split /\s+/;
	if(!defined($items[0])) {next;}  # skip empty lines
	if($items[0] =~ /c/) {next;}  # skip comments
	if($items[0] =~ /s/){  # starting line
	  $origin = $items[1];
	  $n = $items[2];
	  $nvars = $items[3];
	  next;
	}
	$cnt++;
	$tmp = "(".$items[1].":1,".$items[3].":1)";
	if(defined($items[5]))  # this line has reduction polys
	{
	  for($i = 5; $i <= $#items; $i=$i+2)
	  {
		$tmp = "(".$tmp.":0.5,".$items[$i].":0.5)";
	  }
	}
	$lines{$items[0]} = $tmp;
	if($items[0] =~ /e/)
	{
	  my @keys = sort keys %lines;
	  print "1..$origin ";
	  print "@keys\n";
	  last;
	}
}

$tmp = $lines{"e"}.":0.5;";
for($i = $n-1; $i > $origin; $i--)
{
	my $op1 = $i.":";
	my $op2 = $lines{$i}.":";
	$tmp =~ s/$op1/$op2/g;
}

print TREE $tmp;
close TREE;