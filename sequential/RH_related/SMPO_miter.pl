#!/usr/bin/perl -w

use 5.014;
use strict;
use warnings;

open MTR, ">", "SATmiter4.blif"; # change filename

my $size = 4; # change this size

my $d = 1;
my $c = 1;
my $b = 1;
my $i = 0;
my @idx = qw /2 2 3 0 1 1 3/;

my @array = qw /0 1 2 3/;


#my @array = qw /0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64/;

#my @idx = qw /1 0 3 3 4 1 2 2 4/;
my $j = 1;

print MTR ".model SMPOmiter\n.inputs ";
for($i=0;$i<$size;$i++){
print MTR "a$i b$i ";
}
print MTR "\n.outputs Z\n";

my $k;
for($k = 0; $k < $size; $k++){
printf MTR ".names b%d a%d d0\_r%d\n11 1\n", $k, ($idx[0]+$k)%$size, $k;
$j = 1; $b = 1; $c = 1; $d = 1;
while ($j < $size) {
printf MTR (".names a%d a%d c%d\_r%d\n01 1\n10 1\n", ($idx[$j*2-1]+$k)%$size, ($idx[$j*2]+$k)%$size, $c, $k); $c++;
printf MTR (".names b%d c%d\_r%d d%d\_r%d\n11 1\n", ($b+$k)%$size, $c-1, $k, $d, $k); $b++; $d++;
$j ++;
}
$i = 0;
printf MTR ".names d0\_r%d d1\_r%d tmp0\_r%d\n01 1\n10 1\n", $k, $k, $k;
for($i = 2; $i < $size - 1; $i++){
printf MTR (".names tmp%d\_r%d d%d\_r%d tmp%d\_r%d\n01 1\n10 1\n", $i-2,$k, $i,$k, $i-1,$k);
}

printf MTR (".names tmp%d\_r%d d%d\_r%d Rs%d\n01 1\n10 1\n", $size-3,$k, $size-1,$k,$k);
}
####################################  Fen Ge Xian   #########################################
my $tmp;
$i = 1;
$c = 1;
while($i < 2*($size-1)){
 printf MTR ".names a%d a%d c%d\_ph0\n10 1\n01 1\n", $array[($idx[$i]+$c)%$size], $array[($idx[$i+1]+$c)%$size], $c;
 $i += 2;
 $c ++;
}

printf MTR (".names a%d b%d r0\_ph1\n11 1\n", $array[$idx[0]], $array[0]);
$i = 1;
$c = 1;
while($i < $size){
 printf MTR (".names c%d\_ph0 b%d r%d\_ph1\n11 1\n", $c, $array[($i+$c)%$size], $c);
 $i ++;
 $c ++;
}
$tmp = pop @array;
unshift @array, $tmp;

$j =1;
for($j = 1; $j < $size - 1; $j++)
{
  $i = 1;
  $c = 1;
  while($i < 2*($size-1)){
    printf MTR ".names a%d a%d c%d\_ph%d\n10 1\n01 1\n", $array[($idx[$i]+$c)%$size], $array[($idx[$i+1]+$c)%$size], $c, $j;
    $i += 2;
    $c ++;
  }

  printf MTR (".names a%d b%d d0\_ph%d\n11 1\n", $array[$idx[0]], $array[0], $j);
  printf MTR (".names d0\_ph%d r%d\_ph%d r0\_ph%d\n10 1\n01 1\n", $j, $size-1, $j, $j+1);
  $i = 1;
  $c = 1;
  while($i < $size){
    printf MTR (".names c%d\_ph%d b%d d%d\_ph%d\n11 1\n", $c, $j, $array[($i+$c)%$size], $c, $j);
    printf MTR (".names d%d\_ph%d r%d\_ph%d r%d\_ph%d\n10 1\n01 1\n", $c, $j, $c-1, $j, $c, $j+1);
   $i ++;
   $c ++;
  }
  $tmp = pop @array;
  unshift @array, $tmp;
}

  $i = 1;
  $c = 1;
  while($i < 2*($size-1)){
    printf MTR ".names a%d a%d c%d\_ph%d\n10 1\n01 1\n", $array[($idx[$i]+$c)%$size], $array[($idx[$i+1]+$c)%$size], $c, $j;
    $i += 2;
    $c ++;
  }

  printf MTR (".names a%d b%d d0\_ph%d\n11 1\n", $array[$idx[0]], $array[0], $j);
  printf MTR (".names d0\_ph%d r%d\_ph%d Ru1\n10 1\n01 1\n", $j, $size-1, $j);
  $i = 1;
  $c = 1;
  while($i < $size){
    printf MTR (".names c%d\_ph%d b%d d%d\_ph%d\n11 1\n", $c, $j, $array[($i+$c)%$size], $c, $j);
    printf MTR (".names d%d\_ph%d r%d\_ph%d Ru%d\n10 1\n01 1\n", $c, $j, $c-1, $j, ($c+1)%$size);
   $i ++;
   $c ++;
  }
for($i=0;$i<$size;$i++)
{
  print MTR ".names Rs$i Ru$i mo$i\n01 1\n10 1\n";
}

# after generate miter for each bit, add following big OR gate:
print MTR ".names ";
for($k = 0; $k < $size; $k++)
{
	print MTR "mo$k ";
}
print MTR "Z\n";
for($i = 0; $i < $size; $i++)
{
	for($j = 0; $j < $size; $j++)
	{
		if($j == $i){
			print MTR "1";
		}
		else
		{
			print MTR "-";
		}
	}
	print MTR " 1\n";
}
print MTR ".end";
