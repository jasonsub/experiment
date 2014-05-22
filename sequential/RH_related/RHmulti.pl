#!/usr/bin/perl -w

use 5.014;
use strict;
use warnings;

open CEC, ">", "testRH_33bit.blif"; # change the filename

my $size = 33; # change the size
my $v = 16; # change half-size accordingly

#my @idx = qw /1 0 8 6 8 4 5 3 9 3 7 2 9 5 10 1 2 4 6 7 10/;
#my @array = qw /0 1 2 3 4 5 6 7 8 9 10/;

my @idx = qw / 1 0 6 6 15 12 23 21 31 14 32 1 2 15 23 19 26 28 30 13 17 22 25 3 16 10 31 5 22 2 7 12 26 10 29 20 25 8 24 18 30 4 24 11 14 3 7 19 21 11 18 8 16 28 29 9 27 17 27 9 20 4 13 5 32 /;
my @array = qw /0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32/;

#my @idx = qw /1 0 3 3 4 1 2 2 4/;
#my @array = qw /0 1 2 3 4/;

my $tmp;
my $i;
my $j;
my $c;
my $k;
my $strid = 'head'; #new
my @elist; #new
my $cnt; #new

my (@Mat, @tmprow);
foreach(1..$size)
{ push @tmprow, 0;}

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

my $specstr = $strid; # record DFF to be used for propagation
my $lastspec = $strid; # record DFF already used for propagation
my $pass_specstr = $specstr; #temp recorder within one clock cycle
	my $pass_lastspec = $lastspec;

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
  printf CEC ".names a%d b%d d0\_ph%d\n11 1\n", $array[$size-1], $array[$size-1], $k;
  for($j = 1; $j <= $v; $j++)
  {
    printf CEC ".names a%d a%d c%d\_ph%d\n01 1\n10 1\n", $array[$size-1], $array[($size-1+$j)%$size], $c, $k;
    $c++;
    printf CEC ".names b%d b%d c%d\_ph%d\n01 1\n10 1\n", $array[$size-1], $array[($size-1+$j)%$size], $c, $k;
    $c++;
    printf CEC ".names c%d\_ph%d c%d\_ph%d d%d\_ph%d\n11 1\n", $c-2, $k, $c-1, $k, $j, $k;
  }
  # note: following part is manually done, need revise afterwards
=thisis33bitXORarray
  print CEC ".names d0\_ph$k d1\_ph$k e0\_ph$k\n01 1\n10 1\n";
  print CEC ".names d3\_ph$k d16\_ph$k e12\_ph$k\n01 1\n10 1\n";
  print CEC ".names d1\_ph$k d2\_ph$k e6\_ph$k\n01 1\n10 1\n";
  print CEC ".names d3\_ph$k d7\_ph$k e23\_ph$k\n01 1\n10 1\n";
  print CEC ".names d4\_ph$k d13\_ph$k e31\_ph$k\n01 1\n10 1\n";
  print CEC ".names d6\_ph$k d15\_ph$k e2\_ph$k\n01 1\n10 1\n";
  print CEC ".names d8\_ph$k d6\_ph$k e26\_ph$k\n01 1\n10 1\n";
  print CEC ".names d11\_ph$k d14\_ph$k e22\_ph$k\n01 1\n10 1\n";
  print CEC ".names d2\_ph$k d7\_ph$k e15\_ph$k\n01 1\n10 1\n";
 
  print CEC ".names d4\_ph$k e21\_ph$k\n1 1\n";
  print CEC ".names d5\_ph$k e14\_ph$k\n1 1\n";
  print CEC ".names d5\_ph$k e32\_ph$k\n1 1\n";
  print CEC ".names d6\_ph$k e1\_ph$k\n1 1\n";

  print CEC ".names d8\_ph$k e19\_ph$k\n1 1\n";
  print CEC ".names d9\_ph$k e28\_ph$k\n1 1\n";
  print CEC ".names d9\_ph$k e30\_ph$k\n1 1\n";
  print CEC ".names d10\_ph$k e13\_ph$k\n1 1\n";
  print CEC ".names d10\_ph$k e17\_ph$k\n1 1\n";
  print CEC ".names d11\_ph$k e25\_ph$k\n1 1\n";
  print CEC ".names d12\_ph$k e3\_ph$k\n1 1\n";
  print CEC ".names d12\_ph$k e16\_ph$k\n1 1\n";
  print CEC ".names d13\_ph$k e10\_ph$k\n1 1\n";
  print CEC ".names d14\_ph$k e5\_ph$k\n1 1\n";
  print CEC ".names d15\_ph$k e7\_ph$k\n1 1\n";
=cut
	for($j = 0; $j < $size; $j++)
	{
		my $tmpstr = '.names';
		$cnt = 0;
		for($i = 0; $i <= $v; $i++)
		{
			if($Mat[$i][$j])
			{$tmpstr .= " d$i\_ph$k";$cnt++;}
		}
		if($cnt>2) {print "Need size $cnt XOR!\n";}
		elsif ($cnt == 2) {print CEC "$tmpstr e$j\_ph$k\n01 1\n10 1\n";}
		elsif($cnt == 1) {print CEC "$tmpstr e$j\_ph$k\n1 1\n";}
	}
	
	$pass_specstr = $specstr;
	$pass_lastspec = $lastspec;

  for($i=0;$i<$size;$i++)
  {
  	if($specstr !~ /\b$i\b/) {print "Skipped Phase $k Bit $i\n"; next;}
  	if(($strid =~ /\b$i\b/) && ($k == 0)){
  		printf CEC ".names e%d\_ph%d r%d\_ph%d\n1 1\n", $i, $k, $i, $k+1;
  	}
  	if(($strid =~ /\b$i\b/) && ($k > 0) && ($k < $size-1)){
  		$j = ($i+$size-1)%$size;
  		if($lastspec =~ /\b$j\b/){
  			printf CEC ".names r%d\_ph%d e%d\_ph%d r%d\_ph%d\n01 1\n10 1\n", ($i+$size-1)%$size, $k, $i, $k, $i, $k+1;
  		}
  		else{
  			printf CEC ".names e%d\_ph%d r%d\_ph%d\n1 1\n", $i, $k, $i, $k+1;
  		}
  	}
  	if(($strid =~ /\b$i\b/) && ($k == $size - 1)){
  		printf CEC ".names r%d\_ph%d e%d\_ph%d R%d\n01 1\n10 1\n", ($i+$size-1)%$size, $k, $i, $k, $i;
  	}
  	if(($strid !~ /\b$i\b/) && ($specstr =~ /\b$i\b/) && ($k > 0) && ($k < $size-1)){
  		printf CEC ".names r%d\_ph%d r%d\_ph%d\n1 1\n", ($i+$size-1)%$size, $k, $i, $k+1;
  	}
  	if(($strid !~ /\b$i\b/) && ($specstr =~ /\b$i\b/) && ($k == $size-1)){
  		printf CEC ".names r%d\_ph%d R%d\n1 1\n", ($i+$size-1)%$size, $k, $i;
  	}
  	# add i+1 into specstr, update lastspec
  	$j = ($i+1)%$size;
  	if(($lastspec !~ /\b$i\b/) || ($specstr !~ /\b$j\b/)){
  		$pass_lastspec = $specstr;
  		if($specstr !~ /\b$j\b/) {$pass_specstr .= " $j"};
#  		say "Phase $k Bit $i";
#  		say $lastspec;
#  		say $specstr;
  	}
  }
  $specstr = $pass_specstr;
  $lastspec = $pass_lastspec;
  $tmp = pop @array;
  unshift @array, $tmp;
}

print CEC ".end";
close CEC;
