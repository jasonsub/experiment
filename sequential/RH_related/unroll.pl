#!/usr/bin/perl -w

use 5.014;
use strict;
use warnings;

my $size = 11; # remember to change the size!!
open CEC, ">", "unroll_$size"."bit.blif";

my @idx = qw /1 0 8 6 8 4 5 3 9 3 7 2 9 5 10 1 2 4 6 7 10/;
my @array;
foreach(1..$size)
{ 
  push @array, $_-1;
}
my $tmp;
my $i;
print CEC ".model unrollckt\n.inputs ";
for($i=0;$i<$size;$i++){
print CEC "a$i b$i ";
}
print CEC "\n.outputs";
for($i=0;$i<$size;$i++)
{
  print CEC " R$i";
}
print CEC "\n";

$i = 1;
my $c = 1;
while($i < 2*($size-1)){
 printf CEC ".names a%d a%d c%d\_ph0\n10 1\n01 1\n", $array[($idx[$i]+$c)%$size], $array[($idx[$i+1]+$c)%$size], $c;
 $i += 2;
 $c ++;
}

printf CEC (".names a%d b%d r0\_ph1\n11 1\n", $array[$idx[0]], $array[0]);
$i = 1;
$c = 1;
while($i < $size){
 printf CEC (".names c%d\_ph0 b%d r%d\_ph1\n11 1\n", $c, $array[($i+$c)%$size], $c);
 $i ++;
 $c ++;
}
$tmp = pop @array;
unshift @array, $tmp;

my $j =1;
for($j = 1; $j < $size - 1; $j++)
{
  $i = 1;
  $c = 1;
  while($i < 2*($size-1)){
    printf CEC ".names a%d a%d c%d\_ph%d\n10 1\n01 1\n", $array[($idx[$i]+$c)%$size], $array[($idx[$i+1]+$c)%$size], $c, $j;
    $i += 2;
    $c ++;
  }

  printf CEC (".names a%d b%d d0\_ph%d\n11 1\n", $array[$idx[0]], $array[0], $j);
  printf CEC (".names d0\_ph%d r%d\_ph%d r0\_ph%d\n10 1\n01 1\n", $j, $size-1, $j, $j+1);
  $i = 1;
  $c = 1;
  while($i < $size){
    printf CEC (".names c%d\_ph%d b%d d%d\_ph%d\n11 1\n", $c, $j, $array[($i+$c)%$size], $c, $j);
    printf CEC (".names d%d\_ph%d r%d\_ph%d r%d\_ph%d\n10 1\n01 1\n", $c, $j, $c-1, $j, $c, $j+1);
   $i ++;
   $c ++;
  }
  $tmp = pop @array;
  unshift @array, $tmp;
}

  $i = 1;
  $c = 1;
  while($i < 2*($size-1)){
    printf CEC ".names a%d a%d c%d\_ph%d\n10 1\n01 1\n", $array[($idx[$i]+$c)%$size], $array[($idx[$i+1]+$c)%$size], $c, $j;
    $i += 2;
    $c ++;
  }

  printf CEC (".names a%d b%d d0\_ph%d\n11 1\n", $array[$idx[0]], $array[0], $j);
  printf CEC (".names d0\_ph%d r%d\_ph%d R1\n10 1\n01 1\n", $j, $size-1, $j);
  $i = 1;
  $c = 1;
  while($i < $size){
    printf CEC (".names c%d\_ph%d b%d d%d\_ph%d\n11 1\n", $c, $j, $array[($i+$c)%$size], $c, $j);
    printf CEC (".names d%d\_ph%d r%d\_ph%d R%d\n10 1\n01 1\n", $c, $j, $c-1, $j, ($c+1)%$size);
   $i ++;
   $c ++;
  }
print CEC ".end";
close CEC;
