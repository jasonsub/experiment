#!/usr/bin/perl -w

use 5.014;
use strict;
use warnings;

open SING, ">", "130bitnew.sing"; # if you want keep all copies, change this filename

my $size = 130; # remember to change the size!!

#              1 0 8 6 8 4 5 3 9 3 7 2 9 5 10 1 2 4 6 7 10
#my @idx = qw /1 0 8 6 8 4 5 3 9 3 7 2 9 5 10 1 2 4 6 7 10/;
my @idx = qw /65 65 66 7 67 31 68 53 69 70 94 45 71 2 72 73 96 18 74 75 92 62 76 77 109 30 78 68 79 80 108 77 81 82 120 9 83 27 84 50 85 86 98 87 102 88 122 89 125 49 90 85 91 19 92 93 115 54 94 13 95 3 96 97 118 51 98 99 107 80 100 101 106 99 102 103 113 61 104 76 105 81 106 52 107 69 108 63 109 6 110 67 111 79 112 100 113 25 114 20 115 33 116 42 117 4 118 29 119 78 120 112 121 103 122 59 123 58 124 123 125 39 126 11 127 44 128 71 129 0 1 1 72 2 46 3 14 4 43 5 128 6 64 7 66 8 111 9 121 10 88 11 40 12 16 13 55 14 47 15 35 16 41 17 117 18 97 19 86 20 26 21 84 22 91 23 75 24 105 25 101 26 87 10 27 28 127 5 29 30 110 8 31 32 83 21 33 34 37 35 48 36 90 22 37 38 57 39 124 40 89 36 41 34 42 15 43 12 44 45 95 46 73 47 56 38 48 49 126 28 50 51 119 52 82 32 53 54 116 17 55 56 74 23 57 58 60 59 104 24 60 61 114 62 93 63 70 64 129/;

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
