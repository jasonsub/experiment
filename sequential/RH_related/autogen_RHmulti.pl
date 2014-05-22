#!/usr/bin/perl -w

use 5.014;
use strict;
use warnings;

my $size = 11; # remember to change the size!!
open SING, ">", "RH$size"."bit.temp";
my $v = int $size/2;
say "V = $v";

my @idx = qw /1 0 8 6 8 4 5 3 9 3 7 2 9 5 10 1 2 4 6 7 10/;
#my @idx = qw /50 50 51 19 52 53 59 43 54 34 55 56 97 17 57 58 73 20 59 16 60 57 61 62 87 63 75 28 64 65 92 10 66 7 67 23 68 2 69 9 70 66 71 48 72 18 73 52 74 75 88 46 76 77 85 14 78 42 79 54 80 32 81 31 82 81 83 5 84 47 85 72 86 58 87 53 88 80 89 83 90 91 94 29 92 4 93 84 94 77 95 26 96 35 97 22 98 68 99 0 1 1 69 2 24 3 38 4 30 5 82 6 90 7 11 8 37 3 9 10 93 11 91 12 65 13 71 14 86 15 62 16 21 17 98 18 49 19 51 20 74 21 63 22 36 8 23 24 70 13 25 26 78 27 45 28 76 29 95 30 39 31 33 32 55 33 40 34 44 27 35 36 64 12 37 25 38 39 96 40 56 41 61 15 42 43 60 41 44 45 79 46 89 6 47 48 67 49 99/;
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
