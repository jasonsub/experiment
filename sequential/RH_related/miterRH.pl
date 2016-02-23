#!/usr/bin/perl -w

use 5.014;
use strict;
use warnings;

# Update: 02/23/2016 by Xiaojun Sun
# Note: Revised according to major update of autogen_RHmulti.pl
# NOW support Type-1 ONB!!!!

my $size = 4; # change this size
open MTR, ">", "miterRH$size.blif";

my $v = int $size/2;
my $d = 1;
my $c = 1;
my $b = 1;
my $i = 0;
my @idx = qw /2 2 3 0 1 1 3/; # this is M^0, by default first row only have 1 entry
my @array;
foreach(1..$size)
{
  push @array, $_-1;
}

my $j = 1;

my $tmp;
my $k;
my $strid = 'head 0'; # e0 is always needed because of special beta monomial
my @elist; #new
my $cnt; #new

my (@Mat, @tmprow);
foreach(1..$size)
{ push @tmprow, 0;}

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

my $specstr = $strid; # record DFF to be used for propagation
my $lastspec = $strid; # record DFF already used for propagation
my $pass_specstr = $specstr; #temp recorder within one clock cycle
my $pass_lastspec = $lastspec;

print MTR ".model RHmiter\n.inputs ";
for($i=0;$i<$size;$i++){
print MTR "a$i b$i ";
}
print MTR "\n.outputs Z\n";

for($k = 0; $k < $size; $k++)
{
  $c = 1;
  printf MTR ".names a%d b%d d0\_ck%d\n11 1\n", $array[$size-1], $array[$size-1], $k;
  for($j = 1; $j <= $v; $j++)
  {
    printf MTR ".names a%d a%d c%d\_ck%d\n01 1\n10 1\n", $array[$size-1], $array[($size-1+$j)%$size], $c, $k;
    $c++;
    # Following part is for even number branching
    if( ($j == $v) && ($size == 2*$v) )
    {
	  printf MTR ".names b%d c%d\_ck%d\n1 1\n", $array[$size-1], $c, $k;
	}
    else{ 
	  printf MTR ".names b%d b%d c%d\_ck%d\n01 1\n10 1\n", $array[$size-1], $array[($size-1+$j)%$size], $c, $k;
	}
	$c++;
    printf MTR ".names c%d\_ck%d c%d\_ck%d d%d\_ck%d\n11 1\n", $c-2, $k, $c-1, $k, $j, $k;
  }
  # Now the hard part begins: deal with "e" layer!
	for($j = 0; $j < $size; $j++) # the outer loop is for each item with monomial beta, beta^2 .. beta^{2^j}
	{  # If we find a "1" match in the j-th column in multi table, it means corresponding row works as the coef to the monomial
		my $tmpstr = '.names';
		$cnt = 0;
		if ($j == 0) {$tmpstr .= " d0\_ck$k"; $cnt++; } # special case
		for($i = 1; $i <= $v; $i++) # General case
		{
			if($Mat[$i][$j])
			{$tmpstr .= " d$i\_ck$k";$cnt++;}
		}
		if($cnt>3) { 
			print MTR "$tmpstr e$j\_ck$k\nUNDERCONSTRUCTION! XOR size $cnt\n\n";
			warn "Need Large XOR! Size is labeled in blif file with key word \"UNDERCONSTRUCTION\"\n";
		}
		elsif ($cnt == 3) {print MTR "$tmpstr e$j\_ck$k\n001 1\n010 1\n100 1\n111 1\n";}
		elsif ($cnt == 2) {print MTR "$tmpstr e$j\_ck$k\n01 1\n10 1\n";}
		elsif($cnt == 1) {print MTR "$tmpstr e$j\_ck$k\n1 1\n";}
	}
	
	$pass_specstr = $specstr;
	$pass_lastspec = $lastspec;

  for($i=0;$i<$size;$i++)
  {
  	if($specstr !~ /\b$i\b/) {print "Skipped Phase $k Bit $i\n"; next;}
  	if(($strid =~ /\b$i\b/) && ($k == 0)){
  		printf MTR ".names e%d\_ck%d r%d\_ck%d\n1 1\n", $i, $k, $i, $k+1;
  	}
  	if(($strid =~ /\b$i\b/) && ($k > 0) && ($k < $size-1)){
  		$j = ($i+$size-1)%$size;
  		if($lastspec =~ /\b$j\b/){
  			printf MTR ".names r%d\_ck%d e%d\_ck%d r%d\_ck%d\n01 1\n10 1\n", ($i+$size-1)%$size, $k, $i, $k, $i, $k+1;
  		}
  		else{
  			printf MTR ".names e%d\_ck%d r%d\_ck%d\n1 1\n", $i, $k, $i, $k+1;
  		}
  	}
  	if(($strid =~ /\b$i\b/) && ($k == $size - 1)){
  		printf MTR ".names r%d\_ck%d e%d\_ck%d Rs%d\n01 1\n10 1\n", ($i+$size-1)%$size, $k, $i, $k, $i;
  	}
  	if(($strid !~ /\b$i\b/) && ($specstr =~ /\b$i\b/) && ($k > 0) && ($k < $size-1)){
  		printf MTR ".names r%d\_ck%d r%d\_ck%d\n1 1\n", ($i+$size-1)%$size, $k, $i, $k+1;
  	}
  	if(($strid !~ /\b$i\b/) && ($specstr =~ /\b$i\b/) && ($k == $size-1)){
  		printf MTR ".names r%d\_ck%d Rs%d\n1 1\n", ($i+$size-1)%$size, $k, $i;
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
####################################  Next is unrolled SMPO   #########################################

$i = 1;
$c = 1;
while($i < 2*($size-1)){
 printf MTR ".names a%d a%d c%d\_ph0\n10 1\n01 1\n", $array[($idx[$i]+$c)%$size], $array[($idx[$i+1]+$c)%$size], $c;
 $i += 2;
 $c ++;
}

printf MTR (".names a%d b%d r0\_ph1\n11 1\n", $array[$idx[0]], $array[0]);
$i = 1;
$c = 1;
while($i < $size){
 printf MTR (".names c%d\_ph0 b%d r%d\_ph1\n11 1\n", $c, $array[($i+$c)%$size], $c);
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
    printf MTR ".names a%d a%d c%d\_ph%d\n10 1\n01 1\n", $array[($idx[$i]+$c)%$size], $array[($idx[$i+1]+$c)%$size], $c, $j;
    $i += 2;
    $c ++;
  }

  printf MTR (".names a%d b%d d0\_ph%d\n11 1\n", $array[$idx[0]], $array[0], $j);
  printf MTR (".names d0\_ph%d r%d\_ph%d r0\_ph%d\n10 1\n01 1\n", $j, $size-1, $j, $j+1);
  $i = 1;
  $c = 1;
  while($i < $size){
    printf MTR (".names c%d\_ph%d b%d d%d\_ph%d\n11 1\n", $c, $j, $array[($i+$c)%$size], $c, $j);
    printf MTR (".names d%d\_ph%d r%d\_ph%d r%d\_ph%d\n10 1\n01 1\n", $c, $j, $c-1, $j, $c, $j+1);
   $i ++;
   $c ++;
  }
  $tmp = pop @array;
  unshift @array, $tmp;
}

  $i = 1;
  $c = 1;
  while($i < 2*($size-1)){
    printf MTR ".names a%d a%d c%d\_ph%d\n10 1\n01 1\n", $array[($idx[$i]+$c)%$size], $array[($idx[$i+1]+$c)%$size], $c, $j;
    $i += 2;
    $c ++;
  }

  printf MTR (".names a%d b%d d0\_ph%d\n11 1\n", $array[$idx[0]], $array[0], $j);
  printf MTR (".names d0\_ph%d r%d\_ph%d Ru1\n10 1\n01 1\n", $j, $size-1, $j);
  $i = 1;
  $c = 1;
  while($i < $size){
    printf MTR (".names c%d\_ph%d b%d d%d\_ph%d\n11 1\n", $c, $j, $array[($i+$c)%$size], $c, $j);
    printf MTR (".names d%d\_ph%d r%d\_ph%d Ru%d\n10 1\n01 1\n", $c, $j, $c-1, $j, ($c+1)%$size);
   $i ++;
   $c ++;
  }
  
####################################   Next is miter part  ######################################
for($i=0;$i<$size;$i++)
{
  print MTR ".names Rs$i Ru$i mo$i\n01 1\n10 1\n";
}

# after generate miter for each bit, add following big OR gate:
print MTR ".names ";
for($k = 0; $k < $size; $k++)
{
	print MTR "mo$k ";
}
print MTR "Z\n";
for($i = 0; $i < $size; $i++)
{
	for($j = 0; $j < $size; $j++)
	{
		if($j == $i){
			print MTR "1";
		}
		else
		{
			print MTR "-";
		}
	}
	print MTR " 1\n";
}
print MTR ".end";
