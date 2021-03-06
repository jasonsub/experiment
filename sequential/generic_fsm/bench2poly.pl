#!/usr/bin/perl -w

use 5.014;
use strict;
use warnings;

open POLY, ">", "news27.sing";  # change the name
open TOPO, ">", "s27.graph";
#open RED, ">", "reduce953.singular";
my $cnt = 0;

my $i;
my $tmp;
my $idx;

my @PI;
my @inputs;
my @outputs;
my @var;

print POLY "ideal I = ";

while(<>){
	chomp;
	my $read_in = $_;
	my @items = split /\s+/;
	$cnt++;
	if(!defined($items[0])) {next;}  # skip empty lines
	if($items[0] =~ /#/) {next;}  # skip comments
	if($read_in =~ /INPUT\(/){  # write vanishing polys based on inputs
	  $tmp = &abstract($read_in); # 'abstract' is to retract string in parenthesis
	  push @PI, $tmp;
	  push @var, $tmp;
	  next;
	}
	if($read_in =~ /OUTPUT\(/) {  # PO: only record for graph
	  $tmp = &abstract($read_in);
	  push @var, $tmp;
	  next;
	}
	if($read_in =~ /DFF\(/){  # record pseudo in/out, require space besides '=' 
	  $tmp = &abstract($items[2]);
	  push @outputs, $tmp;
	  push @inputs, $items[0];
	  $idx = &query($items[0]);
	  $idx = &query($tmp);
	  next;
	}
	if($read_in =~ /NAND\(/){  # because 'NAND' contains 'AND', so take this first. Directly write poly
	  $tmp = &abstract($items[2]);
	  &write_nand($items[0],$tmp);
	  next;
	}
	if($read_in =~ /AND\(/){  # now comes to 'AND'
	  $tmp = &abstract($items[2]);
	  &write_and($items[0],$tmp);
	  next;
	}
	if($read_in =~ /NOR\(/){  # note possibly exceed the set bound for gate inputs, so pass the cnt to deal exception
	  $tmp = &abstract($items[2]);
	  &write_nor($items[0],$tmp,$cnt);
	  next;
	}
	if($read_in =~ /OR\(/){  # similar for OR gates
	  $tmp = &abstract($items[2]);
	  &write_or($items[0],$tmp,$cnt);
	  next;
	}
	if($read_in =~ /NOT\(/){  # NOT gate, directly write
	  $tmp = &abstract($items[2]);
	  print POLY "$items[0]+1+$tmp, ";
#	  print RED "$items[0]+1+$tmp,\n";
	  $idx = &query($items[0]);
	  print TOPO "$idx ";
	  $idx = &query($tmp);
	  print TOPO "$idx\n";
	  next;
	}
}
print POLY "\n";
for($i=0; $i<=$#PI;$i++)  # write vanishing poly for every input, include PIs and pseudo inputs
{
	print POLY "$PI[$i]^2+$PI[$i], ";
#	print RED "$PI[$i]^2+$PI[$i],\n";
}
for($i=0; $i<=$#inputs;$i++) 
{
	print POLY "$inputs[$i]^2+$inputs[$i], ";
#	print RED "$inputs[$i]^2+$inputs[$i],\n";
}
print POLY "\nS+$inputs[0]";  # word-level input
#print RED "\nS+$inputs[0]";
for($i=1; $i<=$#inputs;$i++) 
{
	print POLY "+X^$i*$inputs[$i]";
#	print RED "+X^$i*$inputs[$i]";
}
print POLY ", ";
print POLY "\nT+$outputs[0]";  # word-level output
#print RED ", ";
#print RED "\nT+$outputs[0]";
for($i=1; $i<=$#outputs;$i++) 
{
	print POLY "+X^$i*$outputs[$i]";
#	print RED "+X^$i*$outputs[$i]";
}
print POLY "; ";
#print RED "; ";
for($i=0;$i<=$#var;$i++)  # this line is for C++ toposort alg. to print the name of nodes rather than indices
{
  print TOPO "$var[$i] ";
}
print TOPO "\n# Remember to fill in the edge number then put following line at beginning, then delete this line\n";
$i = $#var+1;
print TOPO "$i ";

sub abstract{
  my $op = $_;
  my $n = index($op,"(");
  my $s = substr($op,$n+1,length($op)-$n-2);
  return($s);
}

sub query{
  my $target = $_[0];
  my %cvar;
  my $j = 0;
  map { $cvar{$_} = $j++ } @var;
  if (exists $cvar{$target})
  {
	return($cvar{$target}+1);
  }
  else
  {
	push @var, $target;
	return($#var+1);
  }
}

sub write_nand{
  my $left = $_[0];
  my $right = $_[1];
  my @term = split /,\s/,$right;
  if(!defined($term[2]))  # which means this is 2-input NAND
  {
	print POLY "$left+1+$term[0]*$term[1], ";
#	print RED "$left+1+$term[0]*$term[1],\n";
	$idx = &query($left);
	print TOPO "$idx ";
	$idx = &query($term[0]);
	print TOPO "$idx\n";
	$idx = &query($left);  # repeat here, can improve
	print TOPO "$idx ";
	$idx = &query($term[1]);
	print TOPO "$idx\n";
  }
  else  # note: multi-input NAND
  {
	my $n = $#term + 1;
	$right = join "*", @term;
	print POLY "$left+1+$right, ";
#	print RED "$left+1+$right,\n";
	my $pos = &query($left);
	my $j;
	for($j=0;$j<$n;$j++){
	  $idx = &query($term[$j]);
	  print TOPO "$pos $idx\n";
	}
  }
}

sub write_and{  #copy from above; also for NOR and OR
  my $left = $_[0];
  my $right = $_[1];
  my @term = split /,\s/,$right;
  if(!defined($term[2]))  # which means this is 2-input AND
  {
	print POLY "$left+$term[0]*$term[1], ";
#	print RED "$left+$term[0]*$term[1],\n";
	$idx = &query($left);
	print TOPO "$idx ";
	$idx = &query($term[0]);
	print TOPO "$idx\n";
	$idx = &query($left);  # repeat here, can improve
	print TOPO "$idx ";
	$idx = &query($term[1]);
	print TOPO "$idx\n";
  }
  else  # note: multi-input AND
  {
	my $n = $#term + 1;
	$right = join "*", @term;
	print POLY "$left+$right, ";
#	print RED "$left+$right,\n";
	my $pos = &query($left);
	my $j;
	for($j=0;$j<$n;$j++){
	  $idx = &query($term[$j]);
	  print TOPO "$pos $idx\n";
	}
  }
}

sub write_nor{  # derive from NAND (add one argument)
  my $left = $_[0];
  my $right = $_[1];
  my $lines = $_[2];
  my @term = split /,\s/,$right;
  if(!defined($term[2]))  # which means this is 2-input NOR
  {
	print POLY "$left+1+or2($term[0],$term[1]), ";
#	print RED "$left+1+or2($term[0],$term[1]),\n";
	$idx = &query($left);
	print TOPO "$idx ";
	$idx = &query($term[0]);
	print TOPO "$idx\n";
	$idx = &query($left);  # repeat here, can improve
	print TOPO "$idx ";
	$idx = &query($term[1]);
	print TOPO "$idx\n";
  }
  else  # note: multi-input NOR
  {
	my $n = $#term + 1;
	if($n>5) {print "Warning: There is a multi-input gate exceeds bound of fanin, script may fail: Line $lines in bench file\n";}
	$right = join ",", @term;  # which can be skipped
	print POLY "$left+1+or$n($right), ";
#	print RED "$left+1+or$n($right),\n";
	my $pos = &query($left);
	my $j;
	for($j=0;$j<$n;$j++){
	  $idx = &query($term[$j]);
	  print TOPO "$pos $idx\n";
	}
  }
}

sub write_or{  # derive from NOR
  my $left = $_[0];
  my $right = $_[1];
  my $lines = $_[2];
  my @term = split /,\s/,$right;
  if(!defined($term[2]))  # which means this is 2-input OR
  {
	print POLY "$left+or2($term[0],$term[1]), ";
#	print RED "$left+or2($term[0],$term[1]),\n";
	$idx = &query($left);
	print TOPO "$idx ";
	$idx = &query($term[0]);
	print TOPO "$idx\n";
	$idx = &query($left);  # repeat here, can improve
	print TOPO "$idx ";
	$idx = &query($term[1]);
	print TOPO "$idx\n";
  }
  else  # note: multi-input OR
  {
	my $n = $#term + 1;
	if($n>5) {print "Warning: There is a multi-input gate exceeds bound of fanin, script may fail: Line $lines in bench file\n";}
	$right = join ",", @term;  # which can be skipped
	print POLY "$left+or$n($right), ";
#	print RED "$left+or$n($right),\n";
	my $pos = &query($left);
	my $j;
	for($j=0;$j<$n;$j++){
	  $idx = &query($term[$j]);
	  print TOPO "$pos $idx\n";
	}
  }
}
