#!/usr/bin/perl -w

use 5.014;
use strict;
use warnings;
use List::MoreUtils qw(uniq);

# Modification from version A: Xiaojun Sun, 04/05/2016
# Remove coef output file, restore nh output file

# Update: Xiaojun Sun, 02/19/2016
# Change 1: Input format change, now first line add #var as 3rd arg, then each line index and coeff are alternating
# e.g. line "10 2 1 5 ab 4 c" means f_10 = 1*f_2 + ab*f_5 + c*f_4
# Change 2: Besides newick tree output, added another output file listing coefficients for each poly
# involved with s-poly/reduction (not simplified), it is meant to be fed to Singular to check if any of
# them reduced to 0. Excluding those, remaining nonzero coeffs represents the core. Note for fitting
# the size of total poly, coeff[last] must be defined (if not used, then define as 0)
# Change 3: add another output file for dist&freq

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
#open COEF, ">", "tmp.coef";
open DIST, ">", "tmp.dist";
my $cnt = 0;

my $i;
my $tmp;
my %lines;
my $origin;
my $n;
my $nvars;
my %olines;
#my %coefs;
my %dist;
my %freq;

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
	$olines{$items[0]} = $read_in;
	if($items[0] =~ /e/)
	{
	  my @keys = sort keys %lines;
	  print "1..$origin ";
	  print "@keys\n";
	  last;
	}
}

$tmp = $lines{"e"}.":0.5;";
# Substitution loop may occur in s///g...still need to debug
for($i = $n-1; $i > $origin; $i--)
{
	my $op1 = $i.":";
	my $op2 = $lines{$i}.":";
	my $opl = ",".$op1;
	my $opr = ",".$op2;
#	$tmp =~ s/$opl/$opr/g;
	$opl = "\(".$op1;
	$opr = "\(".$op2;
#	$tmp =~ s/$opl/$opr/g;
}

print TREE $tmp;
close TREE;
print "I am here!\n";

# Analysis for coef, dist and freq starts here!
$tmp = $olines{"e"};
my @items = split /\s+/, $tmp;
my @newpoly;
for($i = 1; $i <= $#items; $i=$i+2)
{
	if($items[$i] > $origin) {@newpoly = sort {$a <=> $b} $items[$i], @newpoly;} # add new poly involved to sorted array
	@newpoly = uniq(@newpoly);
#	if(exists $coefs{$items[$i]}) {$coefs{$items[$i]} = $coefs{$items[$i]}."+".$items[$i+1];}#
#	if(!exists $coefs{$items[$i]}) {$coefs{$items[$i]} = $items[$i+1];}
	my $tmpdist = ( $i == 1 )?($#items/2 -1):( ($#items+1-$i)/2 ); # min distance = 1, spoly have same dist
	print "Update dist: $items[$i] <= $tmpdist;\n";
	if(exists $dist{$items[$i]}) {$dist{$items[$i]} = ($tmpdist < $dist{$items[$i]})?$tmpdist:$dist{$items[$i]}; }
	if(!exists $dist{$items[$i]}) {$dist{$items[$i]} = $tmpdist; }
	if(exists $freq{$items[$i]}) {$freq{$items[$i]} ++; }
	if(!exists $freq{$items[$i]}) {$freq{$items[$i]} = 1; }
}
undef @items;

# Now iteratively pop largest new poly from array, do analysis
# Note we need to consider base coeff (multiply) and base distance (add) now
while(1)
{
	my $polytrace = pop @newpoly;
	if(!defined($polytrace)) {last;}
	print "$polytrace ";
	$tmp = $olines{$polytrace};
	if (!defined $tmp) {print "FATAL ERROR occurs when $polytrace is taken!!!!!";last;}
	@items = split /\s+/, $tmp;
	for($i = 1; $i <= $#items; $i=$i+2)
	{
		if($items[$i] > $origin && $items[$i] < $polytrace) {@newpoly = sort {$a <=> $b} $items[$i], @newpoly;} # add new poly involved to sorted array
		@newpoly = uniq(@newpoly);
		# local coef multiply by coef of current poly previous stored
#		if(exists $coefs{$items[$i]}) {$coefs{$items[$i]} = $coefs{$items[$i]}."+(".$coefs{$polytrace}.")*".$items[$i+1];}
#		if(!exists $coefs{$items[$i]}) {$coefs{$items[$i]} = "(".$coefs{$polytrace}.")*".$items[$i+1];}
		# local distance added to dist of current poly previously called
		my $tmpdist = $dist{$polytrace} + (( $i == 1 )?($#items/2 -1):( ($#items+1-$i)/2 )); # min distance = 1, spoly have same dist
		print "Update dist: $items[$i] <= $tmpdist;\n";
		if(exists $dist{$items[$i]}) {$dist{$items[$i]} = ($tmpdist < $dist{$items[$i]})?$tmpdist:$dist{$items[$i]}; }
		if(!exists $dist{$items[$i]}) {$dist{$items[$i]} = $tmpdist; }
		if(exists $freq{$items[$i]}) {$freq{$items[$i]} += $freq{$polytrace}; }
		if(!exists $freq{$items[$i]}) {$freq{$items[$i]} = $freq{$polytrace}; }
	}
}
=coef
# Print coef files send to Singular for vanishing coef checking (if there exists)
print COEF "ring Q = 2, (";
for($i = 1; $i < $nvars; $i++) {
	print COEF "v$i,";
}
print COEF "v$nvars), Dp;\nideal CF;\n";
for($i = 1; $i < $origin; $i++) {
	if(exists $coefs{$i}) {printf COEF "CF[%d] = %s;\n", $i, $coefs{$i}; }
}
if(exists $coefs{$origin}) {
	printf COEF "CF[%d] = %s;\n", $origin, $coefs{$origin};
}
else {
	print COEF "CF[$i] = 0;\n";
}

# For reducing ^2 terms
print COEF "ideal J0 = v1^2+v1";
for($i = 2; $i <= $nvars; $i++) {
	print COEF ", v$i^2+v$i";
}
print COEF ";\nCF = reduce(CF,J0);\n";

print COEF "string st = \"\";\nfor(int i = 1; i <= $origin; i++)\n\{\n\tif(CF[i] != 0) \{\n\t\tst = st+string(i)+\" \";\n\t\}\n\}\n";
print COEF "link l = \":w tmp.simp\";\nwrite(l,st);\nclose(l);\nquit;";
close COEF;
=cut
# Print dist files for reordering, format is poly index -> dist -> freq
print DIST "c idx dist freq\n";
for($i = 1; $i <= $origin; $i++) {
	if(exists $dist{$i}) {printf DIST "%d %d %d\n", $i, $dist{$i}, $freq{$i}; }
}
