#!/usr/bin/perl -w

use 5.014;
use strict;
use warnings;

my $size = 99; # remember to change the size!!
open SING, ">", "RH$size"."bit.temp";
my $v = int $size/2;
say "V = $v";

my @idx = qw /1 0 85 48 85 71 91 34 60 13 80 16 63 41 74 11 94 56 79 35 93 8 42 39 79 5 61 15 16 14 62 6 14 41 62 36 81 24 54 29 32 59 76 50 72 44 53 19 82 32 89 66 70 49 87 31 77 20 55 76 95 28 88 20 25 59 66 4 92 10 80 18 42 52 54 51 78 12 43 61 73 7 17 11 36 39 52 23 73 64 82 69 97 84 90 2 86 27 71 22 77 38 53 37 43 23 51 19 37 29 78 9 95 68 93 65 75 21 33 4 72 13 40 15 17 6 81 45 74 58 69 26 33 87 92 57 96 46 65 26 90 3 49 22 60 40 44 7 64 58 94 21 30 28 50 38 55 9 12 5 35 18 63 24 45 89 97 47 98 1 2 48 91 27 67 31 96 25 83 47 70 3 86 34 67 10 57 8 75 30 56 68 88 46 83 84 98/;
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
