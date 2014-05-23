#!/usr/bin/perl -w

use 5.014;
use strict;
use warnings;

my $size = 18; # change the size
open CEC, ">", "unroll_$size"."bit.blif"; # change the filename

my @idx = qw /1 0 8 5 8 14 16 7 13 2 9 12 16 4 17 1 2 5 14 11 12 10 15 6 10 4 15 3 9 11 13 3 6 7 17/;
my @array;

foreach(1..$size)
{ push @array, $_-1; }

#my @idx = qw /1 0 3 3 4 1 2 2 4/;
#my @array = qw /0 1 2 3 4/;
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
