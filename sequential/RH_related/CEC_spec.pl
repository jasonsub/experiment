#!/usr/bin/perl -w

use 5.014;
use strict;
use warnings;

open BL, ">", "spec_11bit.blif"; # change filename

my $size = 11; # change this size

my $d = 1;
my $c = 1;
my $b = 1;
my $i = 0;
my @idx = qw /1 0 8 6 8 4 5 3 9 3 7 2 9 5 10 1 2 4 6 7 10/;

#my @idx = qw /1 0 3 3 4 1 2 2 4/;
my $j = 1;

print BL ".model specckt\n.inputs ";
for($i=0;$i<$size;$i++){
print BL "a$i b$i ";
}
print BL "\n.outputs";
for($i=0;$i<$size;$i++)
{
  print BL " R$i";
}
print BL "\n";
my $k;
for($k = 0; $k < $size; $k++){
printf BL ".names b%d a%d d0\_r%d\n11 1\n", $k, ($k+1)%$size, $k;
$j = 1; $b = 1; $c = 1; $d = 1;
while ($j < $size) {
printf BL (".names a%d a%d c%d\_r%d\n01 1\n10 1\n", ($idx[$j*2-1]+$k)%$size, ($idx[$j*2]+$k)%$size, $c, $k); $c++;
printf BL (".names b%d c%d\_r%d d%d\_r%d\n11 1\n", ($b+$k)%$size, $c-1, $k, $d, $k); $b++; $d++;
$j ++;
}
$i = 0;
printf BL ".names d0\_r%d d1\_r%d tmp0\_r%d\n01 1\n10 1\n", $k, $k, $k;
for($i = 2; $i < $size - 1; $i++){
printf BL (".names tmp%d\_r%d d%d\_r%d tmp%d\_r%d\n01 1\n10 1\n", $i-2,$k, $i,$k, $i-1,$k);
}

printf BL (".names tmp%d\_r%d d%d\_r%d R%d\n01 1\n10 1\n", $size-3,$k, $size-1,$k,$k);
}
print BL ".end\n";
