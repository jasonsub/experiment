#!/usr/bin/perl -w

use 5.014;
use strict;
use warnings;

# Update: 02/20/2016 by Xiaojun Sun
# Add second arg for output filename

# slim_cnf: abstract certain clauses from a CNF file
# Edit: 03/31/2015 by Xiaojun Sun
# Objective: do scratch investigation on GB based UNSAT core extraction

open RIN, "<", $ARGV[0];
open CNF, ">", $ARGV[1];
my $cnt = 0;
my @idx = qw/116 3 1 5 35 12 23 13 41 84 58/;

while(<RIN>){
	chomp;
	my $read_in = $_;
	my @items = split /\s+/;
	if(!defined($items[0])) {next;}  # skip empty lines
	if($items[0] =~ /c/) {next;}  # skip comments
	if($items[0] =~ /p/){  # write vanishing polys based on inputs
	  print CNF "p cnf $items[2] ";
	  print CNF $#idx+1;
	  next;
	}
	$cnt++;
	if($cnt ~~ @idx)
	{print CNF "\n$read_in";}
}
