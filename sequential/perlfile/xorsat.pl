#!/usr/bin/perl -w

use 5.014;
use strict;
use warnings;

open BEDROCK, ">", "xor_o.dat";
open LAVA, ">", "new_o.dat";

my %record;
my $readin;
my @items;
my $n = 33; ################## This is ONB size

while(<>){
	chomp;
	$readin = $_;
	@items = split /\+/;
	print BEDROCK "x-";
	my $i = 0;
	while($items[$i])
	{
		if($items[$i] =~ /\*/)
		{
			if(exists $record{$items[$i]})
			{
				print BEDROCK $n+1+$record{$items[$i]};
				print BEDROCK " ";
			}
			else
			{
				my $k = &create_new($items[$i]);
				print BEDROCK $n+1+$k;
				print BEDROCK " ";
			}
		}
		else
		{
			my $idx = substr($items[$i],1);
			print BEDROCK $idx+1;
			print BEDROCK " ";
		}
		$i++;
	}
	print BEDROCK "0\n";
}
my $size = keys %record;
printf LAVA "p cnf %d %d", $n+$size, $n+3*$size;

sub create_new {
  my $arg = $_[0];
  $_ = $arg;
  chomp;
  my @s0 = split /\*/;
  my $s1 = substr($s0[0],1);
  my $s2 = substr($s0[1],1);
  my $s3 = keys %record;
  printf LAVA "-%d -%d %d 0\n", $s1+1, $s2+1, $n+$s3+1;
  printf LAVA "%d -%d 0\n", $s1+1, $n+$s3+1;
  printf LAVA "%d -%d 0\n", $s2+1, $n+$s3+1;
  $record{$arg} = $s3;
  return $s3;
}