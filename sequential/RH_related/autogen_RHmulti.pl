#!/usr/bin/perl -w

use 5.014;
use strict;
use warnings;

# Major Update: 02/22/2016 by Xiaojun
# Add an important feature: Now can deal with type-1 ONB!

my $size = 5; # remember to change the size!!
open SING, ">", "RH$size"."bit.temp";
my $v = int $size/2;
say "V = $v";

my @idx = qw /1 0 3 3 4 1 2 2 4/; # Read-in M^0 for generating multi table
my $tmp;
my $i;
my $j;
my $c;
my $k;
my $strid = 'head 0'; # e0 is always needed because of special beta monomial
my @elist; #new
my $cnt; #new

my @array; # here I build array myself (0,1,2,...,m-1)

my (@Mat, @tmprow);
foreach(1..$size)
{ 
  push @tmprow, 0;
  push @array, $_-1;
}

for($j = 0; $j < $size; $j++){ # init multitable
	push @Mat, [@tmprow];
}
# $Mat[0][0] = 1; # obsolete code now, because we take care of d0 separately
# Following part we calculate multi table. If we use type-2 ONB, it is same with M^0
# However for generalization with type-1 ONB, we calculate using general rule for all rows
$i = 0; $j = $idx[0];
$Mat[($j-$i)%$size][(0-$i)%$size] = 1;
for($i = 1; $i < $size; $i++)
{
	$j = $idx[2*$i-1]; $Mat[($j-$i)%$size][(0-$i)%$size] = 1;
	$j = $idx[2*$i]; $Mat[($j-$i)%$size][(0-$i)%$size] = 1;
}
# Check those one who need "e" layer
push @elist, 0; # e0 is always needed...
for($i = 1; $i <= $v; $i++)
{
	for($j = 0; $j < $size; $j++)
	{
		if($Mat[$i][$j] == 1) {
			if($strid !~ /\b$j\b/)
			{
				$strid = $strid." $j";
				push @elist, $j;
			}
		}
	}
}
@elist = sort {$a <=> $b} @elist;
say "@elist";
#say $#elist;

# Preparation done, now output system polys
print SING "ideal I = ";
$c = 1;
  print SING "d0+array_A[$size]*array_B[$size],\n"; # d0 is special
  for($j = 1; $j <= $v; $j++) # deal with "d" layer
  {
    printf SING "c%d+array_A[%d]+array_A[%d],\n", $c, $size, ($size-1+$j)%$size+1;
    $c++;
    # branch for m is odd or even
    if ( ($j == $v) && ($size == $v*2) ) {printf SING "c%d+array_B[%d],\n", $c, $size; }
    else {printf SING "c%d+array_B[%d]+array_B[%d],\n", $c, $size, ($size-1+$j)%$size+1; }
    $c++;
    printf SING "d%d+c%d*c%d,\n", $j, $c-2, $c-1;
  }
  # Now the hard part begins: deal with "e" layer!
	for($j = 0; $j < $size; $j++) # the outer loop is for each item with monomial beta, beta^2 .. beta^{2^j}
	{  # If we find a "1" match in the j-th column in multi table, it means corresponding row works as the coef to the monomial
		my $tmpstr = '';
		$cnt = 0;
		if ($j == 0) {$tmpstr .= "d0+"; $cnt++; } # special case: a_i*b_i is always coef to beta^{2^0}, as in first part of F_i
		for($i = 1; $i <= $v; $i++) # General case: only consider from 1 to v as second part in F_i (plz read the paper if not understand)
		{
		# we can also skip $i not in strid ... but whatever, the cost is trivial
			if($Mat[$i][$j])
			{$tmpstr .= "d$i+";$cnt++;}
		}
		# You can get info to expand XOR size capability here
		if($cnt>2) {print "Need size $cnt XOR!\n";}
		elsif ($cnt > 0) {print SING "$tmpstr"."e$j,\n";}
	}
  for($i=0;$i<$size;$i++)
  {
  	if($strid =~ /\b$i\b/) {print SING "e$i+";}
  	printf SING "r%d+R%d,\n", ($i+$size-1)%$size, $i;
  }

print SING "\n\n********************** ring var ***********************\n\n";
for($i=0;$i<$size;$i++)
{
  print SING "R$i,";
}
for($i=0;$i<$size;$i++)
{
  print SING "r$i,";
}
for($i=0;$i<=$#elist;$i++)
{
  print SING "e$elist[$i],";
}
for($i=0;$i<=$v;$i++)
{
  print SING "d$i,";
}
for($i=1;$i<=2*$v;$i++)
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
