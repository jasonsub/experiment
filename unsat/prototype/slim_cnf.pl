#!/usr/bin/perl -w

use 5.014;
use strict;
use warnings;

# slim_cnf: abstract certain clauses from a CNF file
# Edit: 03/31/2015 by Xiaojun Sun
# Objective: do scratch investigation on GB based UNSAT core extraction

open CNF, ">", "extr65.cnf";  # change the name
my $cnt = 0;
my @idx = qw/1 2 3 4 5 6 7 9 10 11 12 13 15 16 18 19 23 24 26 27 29 30 31 36 40 42 44 48 52 53 58 63/;

while(<>){
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