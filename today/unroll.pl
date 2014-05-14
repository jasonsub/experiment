#!/usr/bin/perl -w

use 5.014;
use strict;
use warnings;

open CEC, ">", "unroll_11bit.blif";  # change the filename

my $size = 11;  # change the size

my @idx = qw /1 0 8 6 8 4 5 3 9 3 7 2 9 5 10 1 2 4 6 7 10/;
my @array = qw /0 1 2 3 4 5 6 7 8 9 10/;

my $i = 1;
my $c = 1;
while($i < 2*($size-1)){
 printf SING ".names a%d a%d c%d\_ph0\n10 1\n01 1\n", $array[($idx[$i]+$c)%$size], $array[($idx[$i+1]+$c)%$size], $c;
 $i += 2;
 $c ++;
}

printf SING (".names a%d b%d r%d\_ph1\n", $array[$idx[0]], $array[0], $size-1);
$i = 1; 
$c = 1;
while($i < $size){
 printf SING "c%d*array_B[%d] r%d\_ph1,\n", $c, ($i+$c)%$size+1, $c-1, $c;
 $i ++;
 $c ++;
}
