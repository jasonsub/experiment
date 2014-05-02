#!/usr/bin/perl -w

use 5.014;
use strict;
use warnings;

open MAT, ">", "matrix.txt";
open VEC, ">", "vector.txt";
my $size = 17;

my $i;
my $j;
my $n1;
my $n2;

print $#tmp;

for($j = 0; $j < $size; $j++){
	push @Mat, [@tmp];
}

while(<>){
	chomp;
	my $read_in = $_;
	my @items = split /\s+/;
	$Mat[$items[0]-1][$items[1]-1] = 1;
	$Mat[$items[1]-1][$items[0]-1] = 1;
	if($items[0] == 1)


for ($i = 0; $i < $size; $i++){
	for($j=0; $j<$size; $j++){
		print MAT "$Mat[$i][$j] ";
	}
	print MAT "\n";
}
