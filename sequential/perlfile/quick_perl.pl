#!/usr/bin/perl -w

use 5.014;
use strict;
use warnings;

#open SING, ">", "temp.sing";

=outputStdBasisPoly
my $i = 1;
print "f = a0 + a1*X";
for($i=2;$i<33;$i++)
{
  print " + a$i"."*X^$i";
}
print "\n";
=cut

=vanishIdeal
my $i = 0;
for($i=0;$i<33;$i++)
{
  print "a$i"."^2+a$i, ";
}
print "\n";
=cut

=fromSATcntResult
my @cnt = qw /1 -2 3 -4 5 -6 7 8 -9 10 -11 -12 -13 -14 15 16 17 -18 -19 20 -21 22 23 -24 -25 -26 27 28 -29 30 31 -32 33/;
my $i = 1;
for($i=0;$i<33;$i++)
{
  if($cnt[$i] > 0){
  	print "X^$i+";
  }
}
print "\n";
=cut

my $i = 0;
for($i=0;$i<33;$i++)
{
  print "R$i,";
}
for($i=0;$i<33;$i++)
{
  print "r$i,";
}
for($i=1;$i<33;$i++)
{
  print "c$i,";
}
for($i=0;$i<33;$i++)
{
  print "b$i,";
}
for($i=0;$i<33;$i++)
{
  print "a$i,";
}
print "R,r,A,B;\n";
