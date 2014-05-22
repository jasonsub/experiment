#!/usr/bin/perl -w

use 5.014;
use strict;
use warnings;

open CEC, ">", "autoRH_5bitX.blif"; # change the filename

my $size = 5; # change the size
my $v = 2; # change half-size accordingly

#my @idx = qw /1 0 8 6 8 4 5 3 9 3 7 2 9 5 10 1 2 4 6 7 10/;
#my @array = qw /0 1 2 3 4 5 6 7 8 9 10/;

my @idx = qw /1 0 3 3 4 1 2 2 4/;
my @array = qw /0 1 2 3 4/;

my $tmp;
my $i;
my $j;
my $c;
my $k;

print CEC ".model RHmulti\n.inputs ";
for($i=0;$i<$size;$i++){
  print CEC "a$i b$i ";
}
print CEC "\n.outputs";
for($i=0;$i<$size;$i++)
{
  print CEC " R$i";
}
print CEC "\n";

for($k = 0; $k < $size; $k++)
{
  $c = 1;
  printf CEC ".names a%d b%d d0\_ph%d\n11 1\n", $array[$size-2], $array[$size-2], $k;
  for($j = 1; $j <= $v; $j++)
  {
    printf CEC ".names a%d b%d c%d\_ph%d\n11 1\n", $array[$size-1], $array[($size-1+$j)%$size], $c, $k;
    $c++;
    printf CEC ".names b%d a%d c%d\_ph%d\n11 1\n", $array[$size-1], $array[($size-1+$j)%$size], $c, $k;
    $c++;
    printf CEC ".names c%d\_ph%d c%d\_ph%d d%d\_ph%d\n10 1\n01 1\n", $c-2, $k, $c-1, $k, $j, $k;
  }
  # note: following part is manually done, need revise afterwards
print CEC ".names d0\_ph$k d1\_ph$k e0\_ph$k\n01 1\n10 1\n";
  print CEC ".names d1\_ph$k d2\_ph$k e3\_ph$k\n01 1\n10 1\n";
  print CEC ".names d2\_ph$k e4\_ph$k\n1 1\n";

  for($i=0;$i<$size;$i++)
  {
  	if($k < $size -1){
  		printf CEC ".names r%d\_ph%d e%d\_ph%d r%d\_ph%d\n01 1\n10 1\n", ($i+$size-1)%$size, $k, $i, $k, $i, $k+1;
  	}
  	else{
  		printf CEC ".names r%d\_ph%d e%d\_ph%d R%d\n01 1\n10 1\n", ($i+$size-1)%$size, $k, $i, $k, $i;
  	}
  }
  $tmp = pop @array;
  unshift @array, $tmp;
}

print CEC ".end";
close CEC;
