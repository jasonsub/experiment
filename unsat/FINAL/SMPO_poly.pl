#!/usr/bin/perl -w

use 5.014;
use strict;
use warnings;

open MTR, ">", "SMPOmiter3.sing"; # change filename

my $size = 3; # change this size

my $d = 1;
my $c = 1;
my $b = 1;
my $i = 0;
#my @idx = qw /2 2 3 0 1 1 3/;

my @array = qw /0 1 2/;


#my @array = qw /0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64/;

#my @idx = qw /1 0 3 3 4 1 2 2 4/;
my @idx = qw/1 0 2 1 2/;
my $j = 1;
my @names;
print MTR "ideal I = \n";
for($i=0;$i<$size;$i++){
push @names, "a".$i;
push @names, "b".$i;
push @names, "Rs".$i;
push @names, "Ru".$i;
}

my $k;
for($k = 0; $k < $size; $k++){
printf MTR "b%d*a%d+d0\_r%d,\n", $k, ($idx[0]+$k)%$size, $k;
push @names, "d0\_r".$k;
$j = 1; $b = 1; $c = 1; $d = 1;
while ($j < $size) {
printf MTR ("a%d+a%d+c%d\_r%d,\n", ($idx[$j*2-1]+$k)%$size, ($idx[$j*2]+$k)%$size, $c, $k); 
push @names, "c".$c."\_r".$k;$c++;
printf MTR ("b%d*c%d\_r%d+d%d\_r%d,\n", ($b+$k)%$size, $c-1, $k, $d, $k); 
push @names, "d".$d."\_r".$k; $b++; $d++;
$j ++;
}
$i = 0;
printf MTR "d0\_r%d+d1\_r%d+tmp0\_r%d,\n", $k, $k, $k;
push @names, "tmp0\_r".$k;
for($i = 2; $i < $size - 1; $i++){
printf MTR ("tmp%d\_r%d+d%d\_r%d+tmp%d\_r%d,\n", $i-2,$k, $i,$k, $i-1,$k);
push @names, "tmp".($i-1)."\_r".$k;
}

printf MTR ("tmp%d\_r%d+d%d\_r%d+Rs%d,\n", $size-3,$k, $size-1,$k,$k);
}
####################################  Fen Ge Xian   #########################################
my $tmp;
$i = 1;
$c = 1;
while($i < 2*($size-1)){
 printf MTR "a%d+a%d+c%d\_ph0,\n", $array[($idx[$i]+$c)%$size], $array[($idx[$i+1]+$c)%$size], $c;
 push @names, "c".$c."\_ph0";
 $i += 2;
 $c ++;
}

printf MTR ("a%d*b%d+r0\_ph1,\n", $array[$idx[0]], $array[0]);
push @names, "r0\_ph1";
$i = 1;
$c = 1;
while($i < $size){
 printf MTR ("c%d\_ph0*b%d+r%d\_ph1,\n", $c, $array[($i+$c)%$size], $c);
 push @names, "r".$c."\_ph1";
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
    printf MTR "a%d+a%d+c%d\_ph%d,\n", $array[($idx[$i]+$c)%$size], $array[($idx[$i+1]+$c)%$size], $c, $j;
    push @names, "c".$c."\_ph".$j;
    $i += 2;
    $c ++;
  }
# This line is diff from copy in miterRH_poly.pl
  printf MTR ("a%d*b%d+d0\_ph%d,\n", $array[$idx[0]], $array[0], $j);
  printf MTR ("d0\_ph%d+r%d\_ph%d+r0\_ph%d,\n", $j, $size-1, $j, $j+1);
  push @names, "d0\_ph".$j;
  push @names, "r0\_ph".($j+1);
  $i = 1;
  $c = 1;
  while($i < $size){
    printf MTR ("c%d\_ph%d*b%d+d%d\_ph%d,\n", $c, $j, $array[($i+$c)%$size], $c, $j);
    printf MTR ("d%d\_ph%d+r%d\_ph%d+r%d\_ph%d,\n", $c, $j, $c-1, $j, $c, $j+1);
    push @names, "d".$c."\_ph".$j;
    push @names, "r".$c."\_ph".($j+1);
   $i ++;
   $c ++;
  }
  $tmp = pop @array;
  unshift @array, $tmp;
}

  $i = 1;
  $c = 1;
  while($i < 2*($size-1)){
    printf MTR "a%d+a%d+c%d\_ph%d,\n", $array[($idx[$i]+$c)%$size], $array[($idx[$i+1]+$c)%$size], $c, $j;
    push @names, "c".$c."\_ph".$j;
    $i += 2;
    $c ++;
  }

  printf MTR ("a%d*b%d+d0\_ph%d,\n", $array[$idx[0]], $array[0], $j);
  push @names, "d0\_ph".$j;
  printf MTR ("d0\_ph%d+r%d\_ph%d+Ru1,\n", $j, $size-1, $j);
  $i = 1;
  $c = 1;
  while($i < $size){
    printf MTR ("c%d\_ph%d*b%d+d%d\_ph%d,\n", $c, $j, $array[($i+$c)%$size], $c, $j);
    push @names, "d".$c."\_ph".$j;
    printf MTR ("d%d\_ph%d+r%d\_ph%d+Ru%d,\n", $c, $j, $c-1, $j, ($c+1)%$size);
   $i ++;
   $c ++;
  }
for($i=0;$i<$size-1;$i++)
{
  print MTR "Rs$i+Ru$i+1,\n";
}
print MTR "Rs$i+Ru$i+1;\n\n";

# print vars
print MTR "ring Q = 2, ($names[0]";
for($i=1;$i<=$#names;$i++)
{
  print MTR ",$names[$i]";
}
print MTR "), Dp;\n\nideal J0 = $names[0]^2+$names[0]";
for($i=1;$i<=$#names;$i++)
{
  print MTR ",$names[$i]^2+$names[$i]";
}
print MTR ";\n"
