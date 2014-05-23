#!/usr/bin/perl -w

use 5.014;
use strict;
use warnings;

my $size = 89; # remember to change the size!!
open SING, ">", "RH$size"."bit.temp";
my $v = int $size/2;
say "V = $v";

my @idx = qw /1 0 19 19 49 38 82 68 77 34 62 31 74 10 27 45 56 22 26 7 75 45 53 16 51 66 80 24 37 21 50 12 46 80 87 48 88 1 2 49 82 15 25 9 46 36 75 14 67 21 83 9 57 7 32 56 61 69 84 71 73 6 63 27 58 41 61 5 78 74 86 23 47 14 81 3 50 54 77 42 60 33 59 40 78 59 65 52 55 8 11 16 22 36 87 18 81 2 20 15 38 12 54 44 66 11 76 39 51 44 60 8 28 26 84 32 64 41 43 40 55 28 33 5 69 31 72 58 85 43 79 13 52 24 76 4 83 29 62 71 72 30 70 63 70 30 85 6 35 10 23 53 67 4 39 34 42 65 86 13 17 37 48 3 20 25 68 29 57 64 73 35 79 17 47 18 88/;

my $tmp;
my $i;
my $j;
my $c;
my $k;
my $strid = 'head'; #new
my @elist; #new
my $cnt; #new

my @array; # here I build array myself (0,1,2,...,m-1)

my (@Mat, @tmprow);
foreach(1..$size)
{ 
  push @tmprow, 0;
  push @array, $_-1;
}

for($j = 0; $j <= $v; $j++){ # line 0 is for d0
	push @Mat, [@tmprow];
}
$Mat[0][0] = 1;
for($i = 1; $i <= $v; $i++)
{
	my $u = $idx[2*$i-1];
	$Mat[$i][$u] = 1;
	if($strid !~ /\b$u\b/)
	{
		$strid = $strid." $u";
		push @elist, $u;
	}
	$u = $idx[2*$i];
	$Mat[$i][$u] = 1;
	if($strid !~ /\b$u\b/)
	{
		$strid = $strid." $u";
		push @elist, $u;
	}
}
@elist = sort {$a <=> $b} @elist;
say "@elist";
#say $#elist;

# Preparation done, now output system polys
print SING "ideal I = ";
$c = 1;
  print SING "d0+array_A[$size]*array_B[$size],\n";
  for($j = 1; $j <= $v; $j++)
  {
    printf SING "c%d+array_A[%d]+array_A[%d],\n", $c, $size, ($size-1+$j)%$size+1;
    $c++;
    printf SING "c%d+array_B[%d]+array_B[%d],\n", $c, $size, ($size-1+$j)%$size+1;
    $c++;
    printf SING "d%d+c%d*c%d,\n", $j, $c-2, $c-1;
  }
	for($j = 0; $j < $size; $j++)
	{
		my $tmpstr = '';
		$cnt = 0;
		for($i = 0; $i <= $v; $i++)
		{
			if($Mat[$i][$j])
			{$tmpstr .= "d$i+";$cnt++;}
		}
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
