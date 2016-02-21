#!/usr/bin/perl -w

use 5.014;
use strict;
use warnings;

# Update: 02/20/2016 by Xiaojun Sun
# Add second arg for output filename

# slim_cnf: abstract certain clauses from a CNF file
# Edit: 03/31/2015 by Xiaojun Sun
# Objective: do scratch investigation on GB based UNSAT core extraction

open RIN, "<", $ARGV[0];
open CNF, ">", $ARGV[1];
my $cnt = 0;
my @idx = qw/223 215 231 229 230 205 233 234 196 198 199 197 235 236 192 220 194 224 193 201 189 187 174 97 117 118 160 155 170 171 92 182 176 119 183 179 141 143 120 173 147 178 137 139 142 144 146 169 133 135 138 140 129 131 134 136 130 132 238 105 78 114 83 75 77 66 71 73 106 68 62 67 64 69 63 65 25 46 110 23 49 48 24 57 43 52 53 47 33 58 59 28 55 19 21 60 51 15 20 13 14 240 3 1 2/;

while(<RIN>){
	chomp;
	my $read_in = $_;
	my @items = split /\s+/;
	if(!defined($items[0])) {next;}  # skip empty lines
	if($items[0] =~ /c/) {next;}  # skip comments
	if($items[0] =~ /p/){  # write vanishing polys based on inputs
	  print CNF "p cnf $items[2] ";
	  print CNF $#idx+1;
	  next;
	}
	$cnt++;
	if($cnt ~~ @idx)
	{print CNF "\n$read_in";}
}
