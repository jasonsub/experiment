#!/usr/bin/perl -w

use 5.014;
use strict;
use warnings;

open SING, ">", "11bitnew.sing";

my @idx = qw /1 0 8 6 8 4 5 3 9 3 7 2 9 5 10 1 2 4 6 7 10/;

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
while($i < 20){
 printf SING "array_A[%d]+array_A[%d]+c%d,\n", ($idx[$i]+$c)%11+1, ($idx[$i+1]+$c)%11+1, $c;
 $i += 2;
 $c ++;
}
print SING "/***************************************************/\n";

print SING "array_A[2]*array_B[1]+r10+R0,\n";
$i = 1; 
$c = 1;
while($i < 11){
 printf SING "c%d*array_B[%d]+r%d+R%d,\n", $c, ($i+$c)%11+1, $c-1, $c;
 $i ++;
 $c ++;
}
print SING "/***************************************************/\n";

$i = 1;
$c = 293;
print SING "A";
while($i < 12){
  printf SING "+a%d*X^%d", $i-1, $c;
  $i ++;
  $c = $c*2%2047;
}
print SING ",\n";

$i = 1;
$c = 293;
print SING "B";
while($i < 12){
  printf SING "+b%d*X^%d", $i-1, $c;
  $i ++;
  $c = $c*2%2047;
}
print SING ",\n";

$i = 1;
$c = 293;
print SING "r";
while($i < 12){
  printf SING "+r%d*X^%d", $i-1, $c;
  $i ++;
  $c = $c*2%2047;
}
print SING ",\n";

$i = 1;
$c = 293;
print SING "R";
while($i < 12){
  printf SING "+R%d*X^%d", $i-1, $c;
  $i ++;
  $c = $c*2%2047;
}
print SING ",\n";

for($i = 0; $i < 11; $i++){
  printf SING "a%d^2+a%d, ", $i, $i;
  printf SING "b%d^2+b%d, ", $i, $i;
  printf SING "r%d^2+r%d, ", $i, $i;
  printf SING "R%d^2+R%d,\n", $i, $i;
}

print SING "A^2048+A, B^2048+B, r^2048+r, R^2048+R,\n";
print SING "r_in;\n";

close SING;
