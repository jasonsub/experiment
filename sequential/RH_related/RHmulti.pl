#!/usr/bin/perl -w

use 5.014;
use strict;
use warnings;

my $size = 18; # change the size
open CEC, ">", "testRH_$size"."bit.blif"; # change the filename

my $v = int $size/2;

#my @idx = qw /1 0 8 6 8 4 5 3 9 3 7 2 9 5 10 1 2 4 6 7 10/;

my @idx = qw / 1 0 8 5 8 14 16 7 13 2 9 12 16 4 17 1 2 5 14 11 12 10 15 6 10 4 15 3 9 11 13 3 6 7 17 /;
my @array;

#my @idx = qw /1 0 3 3 4 1 2 2 4/;

foreach(1..$size)
{ push @array, $_-1; }

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
    # Following part is for even number branching
    if( ($j == $v) && ($size == 2*$v) )
    {
	  printf CEC ".names b%d c%d\_ph%d\n1 1\n", $array[$size-1], $c, $k;
	}
    else{ 
	  printf CEC ".names b%d b%d c%d\_ph%d\n01 1\n10 1\n", $array[$size-1], $array[($size-1+$j)%$size], $c, $k;
	}
    $c++;
    printf CEC ".names c%d\_ph%d c%d\_ph%d d%d\_ph%d\n11 1\n", $c-2, $k, $c-1, $k, $j, $k;
  }

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
  	}
  }
  $specstr = $pass_specstr;
  $lastspec = $pass_lastspec;
  $tmp = pop @array;
  unshift @array, $tmp;
}

print CEC ".end";
close CEC;
