#!/usr/bin/perl -w

use 5.014;
use strict;
use warnings;

# Note: this is a simple version for 3-SAT CNF parser
# Edit: 03/31/2015 by Xiaojun Sun
# Objective: do scratch investigation on GB based UNSAT core extraction

open POLY, ">", "unsat65.sing";  # change the name
my $cnt = 0;

my $i;
my $tmp;
my $clauses;
my $vars;

my @alphabet = qw /a b c d e f g h/;
my @args;

print POLY "ideal f = ";

while(<>){
	chomp;
	my $read_in = $_;
	my @items = split /\s+/;
	$cnt++;
	if(!defined($items[0])) {next;}  # skip empty lines
	if($items[0] =~ /c/) {next;}  # skip comments
	if($items[0] =~ /p/){  # write vanishing polys based on inputs
	  $vars = $items[2];
	  $clauses = $items[3];
	  next;
	}
	if($items[3] != 0) {  # for 3-SAT problems
	  print "Error in Line$cnt!\n";
	  next;
	}
	undef @args;
	for($i = 0; $i < 3; $i++)
	{
	  if($items[$i] < 0)
	  {
		$tmp = 0 - $items[$i] -1;
#		print "What is tmp?? It is $tmp!!!!!!!";
		push @args, "1+".$alphabet[$tmp];
	  }
	  else
	  {
		$tmp = $items[$i] -1;
		push @args, $alphabet[$tmp];
	  }
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
print POLY ";\n";
if($cnt != $clauses + 1) 
{print "Error: # of clauses not match! May exist empty lines\n";}
