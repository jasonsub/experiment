#!/usr/bin/perl -w

use 5.014;
use strict;
use warnings;

open SING, ">", "100bitnew.sing"; # if you want keep all copies, change this filename

my $size = 100; # remember to change the size!!

#              1 0 8 6 8 4 5 3 9 3 7 2 9 5 10 1 2 4 6 7 10
#my @idx = qw /1 0 8 6 8 4 5 3 9 3 7 2 9 5 10 1 2 4 6 7 10/;
my @idx = qw /50 50 51 19 52 53 59 43 54 34 55 56 97 17 57 58 73 20 59 16 60 57 61 62 87 63 75 28 64 65 92 10 66 7 67 23 68 2 69 9 70 66 71 48 72 18 73 52 74 75 88 46 76 77 85 14 78 42 79 54 80 32 81 31 82 81 83 5 84 47 85 72 86 58 87 53 88 80 89 83 90 91 94 29 92 4 93 84 94 77 95 26 96 35 97 22 98 68 99 0 1 1 69 2 24 3 38 4 30 5 82 6 90 7 11 8 37 3 9 10 93 11 91 12 65 13 71 14 86 15 62 16 21 17 98 18 49 19 51 20 74 21 63 22 36 8 23 24 70 13 25 26 78 27 45 28 76 29 95 30 39 31 33 32 55 33 40 34 44 27 35 36 64 12 37 25 38 39 96 40 56 41 61 15 42 43 60 41 44 45 79 46 89 6 47 48 67 49 99/;

=thisismultiplicationtableof11bit
0 1 0 0 0 0 0 0 0 0 0 
1 0 0 0 0 0 0 0 1 0 0 
0 0 0 0 0 0 1 0 1 0 0 
0 0 0 0 1 1 0 0 0 0 0 
0 0 0 1 0 0 0 0 0 1 0 
0 0 0 1 0 0 0 1 0 0 0 
0 0 1 0 0 0 0 0 0 1 0 
0 0 0 0 0 1 0 0 0 0 1 
0 1 1 0 0 0 0 0 0 0 0 
0 0 0 0 1 0 1 0 0 0 0 
0 0 0 0 0 0 0 1 0 0 1 
1 0 8 6 8 4 5 3 9 3 7 2 9 5 10 1 2 4 6 7 10
=cut
 
#print SING "/*\n";

#my $i,$j,$c,$rr,$R;
my $i = 1;
my $c = 1;
while($i < 2*($size-1)){  # correctness guarantee: currently for M^0 matrix, the first line always only has 1 entry
 printf SING "array_A[%d]+array_A[%d]+c%d,\n", ($idx[$i]+$c)%$size+1, ($idx[$i+1]+$c)%$size+1, $c;
 $i += 2;
 $c ++;
}
print SING "/***************************************************/\n";

printf SING ("array_A[%d]*array_B[1]+r%d+R0,\n", $idx[0]+1, $size-1); 
$i = 1; 
$c = 1;
while($i < $size){
 printf SING "c%d*array_B[%d]+r%d+R%d,\n", $c, ($i+$c)%$size+1, $c-1, $c;
 $i ++;
 $c ++;
}
print SING "/***************************************************/\n";

=bigpolynotneedanymore

$i = 1;
my $deg = 1;
#$c = 293;
#note we use a "number" var -- beta -- instead of accu. value
while($i <= $size){
  if($i == 1){
	printf SING "a%d*beta+", $i-1;
  }
  else{
  	printf SING "a%d*beta^%d+", $i-1, $deg;
  }
  $i ++;
  $deg = $deg*2;
}
print SING "A,\n";


$i = 1;
$deg = 1;
while($i <= $size){
  if($i == 1){
	printf SING "b%d*beta+", $i-1;
  }
  else{
  	printf SING "b%d*beta^%d+", $i-1, $deg;
  }
  $i ++;
  $deg = $deg*2;
}
print SING "B,\n";

$i = 1;
$deg = 1;
while($i <= $size){
  if($i == 1){
	printf SING "r%d*beta+", $i-1;
  }
  else{
  	printf SING "r%d*beta^%d+", $i-1, $deg;
  }
  $i ++;
  $deg = $deg*2;
}
print SING "r,\n";

$i = 1;
$deg = 1;
while($i <= $size){
  if($i == 1){
	printf SING "R%d*beta+", $i-1;
  }
  else{
  	printf SING "R%d*beta^%d+", $i-1, $deg;
  }
  $i ++;
  $deg = $deg*2;
}
print SING "R;\n";

print SING"\n\n\n\n************************(special one)**********************\n";
$i = 1;
$deg = 1;
while($i <= $size){
  if($i == 1){
	printf SING "R%d*beta+", $size-1;
  }
  else{
  	printf SING "R%d*beta^%d+", $i-2, $deg;
  }
  $i ++;
  $deg = $deg*2;
}
print SING "R;\n";

print SING "\n\n\n\n\n";
print SING "poly f0 = ";
$i = 1;
$deg = 1;
while($i <= $size){
  if($i == 1){
	printf SING "a%d*beta+", $i-1;
  }
  else{
  	printf SING "a%d*beta^%d+", $i-1, $deg;
  }
  $i ++;
  $deg = $deg*2;
}
print SING "A;\n";

#print SING "A^$deg+A, B^$deg+B, r^$deg+r, R^$deg+R,\n";
#print SING "r_in;\n";

=cut

print SING "ideal va = ";

for($i = 0; $i < $size; $i++){
  printf SING "a%d^2+a%d, ", $i, $i;
#  printf SING "b%d^2+b%d, ", $i, $i;
#  printf SING "r%d^2+r%d, ", $i, $i;
#  printf SING "R%d^2+R%d,\n", $i, $i;
}
#print SING "A^$deg+A;";

print SING "\n\n********************** ring var ***********************\n\n";
for($i=0;$i<$size;$i++)
{
  print SING "R$i,";
}
for($i=0;$i<$size;$i++)
{
  print SING "r$i,";
}
for($i=1;$i<$size;$i++)
{
  print SING "c$i,";
}
for($i=0;$i<$size;$i++)
{
  print SING "b$i,";
}
for($i=0;$i<$size;$i++)
{
  print SING "a$i,";
}
print SING "R,r,A,B\n";

print SING "\n\n********************** Word vectors ***********************\n\n";
print SING "ideal A_in = a0";
for($i=1;$i<$size;$i++)
{
  print SING ",a$i";
}
print SING ";\n";
print SING "ideal B_in = b0";
for($i=1;$i<$size;$i++)
{
  print SING ",b$i";
}
print SING ";\n";
print SING "ideal vec_r = r0";
for($i=1;$i<$size;$i++)
{
  print SING ",r$i";
}
print SING ";\n";
print SING "ideal vec_R = R0";
for($i=1;$i<$size;$i++)
{
  print SING ",R$i";
}
print SING ";\n";

print SING "\n\n************************** Min-poly ************************\n\n";
print SING "minpoly = ";
for($i=$size;$i>1;$i--){
  print SING "X^$i + ";
}
print SING "X + 1;\n";

close SING;
