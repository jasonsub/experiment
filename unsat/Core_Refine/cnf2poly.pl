#!/usr/bin/perl -w

use 5.014;
use strict;
use warnings;

# Update: 02/18/2016 by Xiaojun Sun
# Note: Expand capability to 5-SAT
# Note2: cancel alphabet, use v1 v2 v3... instead
# Note3: add a line as list of vars for Singular use

# Note: this is a simple version for 3-SAT CNF parser
# Edit: 03/31/2015 by Xiaojun Sun
# Objective: do scratch investigation on GB based UNSAT core extraction

open CNF, "<", $ARGV[0];   # first argument as input
open POLY, ">", $ARGV[1];  # second argument as output
my $cnt = 0;

my $i;
my $tmp;
my $clauses;
my $vars;

#my @alphabet = qw /a b c d e f g h/;
my @args;

while(<CNF>){
	chomp;
	my $read_in = $_;
	my @items = split /\s+/;
	$cnt++;
	if(!defined($items[0])) {next;}  # skip empty lines
	if($items[0] =~ /c/) {next;}  # skip comments
	if($items[0] =~ /p/){  # write vanishing polys based on inputs
	  $vars = $items[2];
	  $clauses = $items[3];
	  print POLY "ring Q = 2, (";
	  foreach $i (1..($vars-1)) {
		print POLY "v$i,";
	  }
	  print POLY "v$vars), Dp;\n\nideal I = ";
	  next;
	}
	if(defined($items[5]) && $items[5] != 0) {  # for max-5-SAT problems
	  print "Error in Line$cnt!\n";
	  next;
	}
	undef @args;
	for($i = 0; $i < 5; $i++)
	{
	  if($items[$i] < 0)
	  {
		$tmp = 0 - $items[$i];
#		print "What is tmp?? It is $tmp!!!!!!!";
		push @args, "1+v".$tmp;
	  }
	  elsif($items[$i] > 0)
	  {
		$tmp = $items[$i];
		push @args, "v".$tmp;
	  }
	  else {last;} # when touch 0, clause ends
	}
	printf POLY "\n1+or%d(", 1+$#args; # $#args is NOT the number but the last index, which is 3-1=2 here
	for($i = 0; $i <= $#args; $i++)
	{
	  print POLY $args[$i];
	  if($i < $#args) 
	  {print POLY ',';}
	}
	print POLY "),";
}
print POLY ";\n\nideal J0 = v1^2+v1";
for($i = 2; $i <= $vars; $i++) {
	print POLY ", v$i^2+v$i";
}
print POLY ";\n";
close POLY;
if($cnt != $clauses + 1) 
{print "Warning: # of clauses not match! May exist empty lines\n";}
