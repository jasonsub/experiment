#!/usr/bin/perl -w

use 5.014;
use strict;
use warnings;

# Create by Xiaojun Sun @ OCT 12, 2016
# Read-in multiplication table manually, transform to lambda-Matrix

my $size = 8; # remember to change the size!!

my @row1 = qw /0 1 0 0 0 0 0 0/; # Read-in M^0 for generating multi table
my @row2 = qw /0 1 0 0 1 1 0 1/;
my @row3 = qw /0 0 1 1 0 1 0 1/;
my @row4 = qw /0 0 0 0 0 0 0 1/;
my @row5 = qw /1 1 1 1 1 1 1 1/;
my @row6 = qw /0 0 0 0 1 0 0 0/;
my @row7 = qw /1 1 0 1 0 1 0 0/;
my @row8 = qw /1 0 0 1 1 0 1 0/;
my @mtable;
push @mtable, [@row1];
push @mtable, [@row2];
push @mtable, [@row3];
push @mtable, [@row4];
push @mtable, [@row5];
push @mtable, [@row6];
push @mtable, [@row7];
push @mtable, [@row8];


my $tmp;
my $i;
my $j;
my $c;
my $k;

my (@Mat, @tmprow);
foreach(1..$size)
{ 
  push @tmprow, 0;
}

for($j = 0; $j < $size; $j++){ # init lambda-mat
	push @Mat, [@tmprow];
}

#print $Mat[0][0];

for($i = 0; $i < $size; $i++)
{	
    for($j = 0; $j < $size; $j++)
    {
	if($mtable[($j-$i)%$size][(0-$i)%$size] == 1) 
		{$Mat[$i][$j]=1;}
    }
}
for($i=0;$i<$size;$i++){
for($j = 0; $j < $size; $j++){
	print "$Mat[$i][$j] ";
}
print "\n";
}
