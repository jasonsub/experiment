#!/usr/bin/perl -w

use 5.014;
use strict;
use warnings;

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

open TREE, ">", "unsat11.nh";  # change the name
my $cnt = 0;

my $i;
my $tmp;
my %lines;
my $origin;
my $n;

while(<>){
	chomp;
	my $read_in = $_;
	my @items = split /\s+/;
	if(!defined($items[0])) {next;}  # skip empty lines
	if($items[0] =~ /c/) {next;}  # skip comments
	if($items[0] =~ /s/){  # starting line
	  $origin = $items[1];
	  $n = $items[2];
	  next;
	}
	$cnt++;
	$tmp = "(".$items[1].":1,".$items[2].":1)";
	if(defined($items[3]))  # this line has reduction polys
	{
	  for($i = 3; $i <= $#items; $i++)
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