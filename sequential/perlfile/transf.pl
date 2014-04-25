#!/usr/bin/perl -w

use 5.014;
use strict;
use warnings;

open BEDROCK, ">", "var_list.dat";
open CPLEX, ">", "output.dat";

my $readin;  #read-in lines (currently working on)
my @var;  #list of i/o and wires
my @items;  #splitted elements in word within one line
my $cnt_tmp = 0;  #count of temporary variable
my $cnt_lines = 0;  #No. of read in lines
my $i;  #okay we always use it to count
my $def_var;  #just record i/o or wire name for current processing line
my $flag_unit = 0;  #judge if now there's any unit calc
my $cnt_unit = 0;  #count for total potential unit calc 
my $unit = 99;  # position of current unit operator
my %var_list;  # hash table used to store exist variables with their bits(width)
my $subject = 0;

while (<>) {
	chomp;
	$cnt_lines ++;
	print CPLEX "\n\#Constrains for line $cnt_lines :\n";
	$readin = $_;
	@items = split /\s+/;
	$i = 1;
	my $flag_io = 0;
	my $flag_eq = 0;
	my $cnt_eq = 0;
	next unless $items[1];
	while ( $items[$i] ) {
		$_ = $items[$i];
		if (/input|output/) {$flag_io = 1;}
		if (/=/ && !$flag_eq)
		{
			$flag_eq = 1;
			$cnt_eq = $i;
		}
		$i ++;
	}
	$_ = "";  
	my $leng = $i-1;
	if ($flag_io) {$_ = $items[$leng]; s/;/\n/; chomp; print BEDROCK "var $_;\n"; } # -1 more is [] info, if no [] then max 1
	if ($flag_eq) {$_ = $items[$cnt_eq-1]; print BEDROCK "var $_;\n"; }
	chomp;
	if ($_) {push @var, $_; $def_var = $_;}
	$_ = $readin;
	if (/assign/) {pop @var;}  # remove existed var if assign sentence recognized
	#before shift, need upper limit constrain based on bits definition
	elsif ($flag_io || $flag_eq) {
#		print CPLEX "$items[2]\n";
		if ($items[2] =~ /\[(\d+)\:/) {
			$var_list{$def_var} = $1 +1;
		}
		else {$var_list{$def_var} = 1;}
	}
	
	if ($flag_eq) {
		foreach (0..$cnt_eq) {
			shift @items; 
=noneed
			if(/[.]/)  {
				#pick number between [ and : , page136
				#print upper limit (maximum) with $def_var
				# store bits count n in hash
			}
=cut
		}
	}
	else {next;}
	
	$cnt_eq = index ($readin, "=");
	$readin = substr($readin, $cnt_eq+2);
	@items = split /\s+/, $readin;
	chomp(@items);
	
#	print CPLEX "We provide: $readin\n";
	####################################### try to not pass @items, but pass string removed unneed 

	&process;
}
=hash
my $key;
my $value;
while ( ($key, $value) = each %var_list )  {
	print CPLEX "$key => $value\n";
}
=cut


sub process  {


$i = 0;  # split with comma
while($items[$i])  {
	if ( ($items[$i] =~ /,/) && (index($items[$i], ",")!= 0) )  {
		my @comma = split /,/, $items[$i];
		my $new_comma = join " , ", @comma;
		@comma = split /\s+/, $new_comma;
		splice(@items, $i, 1, @comma);
		$i += 2;
	}
	$i ++;
}

$i = 0;
$flag_unit = 0;
$cnt_unit = 0;
$unit = 99;

my $minus = 0;
my $flag_minus = 0;

#print "@items\n";
while ($items[$i])  {
	if ( ($items[$i] =~ /\(/) && ($items[$i] =~ /\)/) )  {  ################### removing redundant () to recognize unit operation############
#		print "!!!!!!!!!!!!!!!!!!!!!!!!!!found!!!!!!!!!!!!!!!!!!!!!!!$items[$i]\n";
		while (($items[$i] =~ /\(/) && ($items[$i] =~ /\)/))  {
			substr($items[$i], rindex ($items[$i], "("), 1) = "";
			substr($items[$i], index ($items[$i], ")"), 1) = "";
		}
#		print "After: $items[$i]\n";
	}
	$i++;
}

$i = 0;
while ($items[$i])  #maybe not full set; also can try eq "==" etc.
{
#################################################################################### fix this! use eq, see what happens
################ we only have , + * < == here######################################
	
	
	if ($items[$i] =~ /\+|\-|\*|\<|\=\=|,/)  {
		$cnt_unit ++;
		if (($items[$i] =~ /\-/) && ($items[$i] =~ /\(/) && ($items[$i] =~ /\)/) )  {$flag_minus = 1; $minus = $i;}
		if (!$i) {$i++; next;}
		if ($items[$i-1] =~ /\}|\)/)  {$i++; next;}
		if ($items[$i+1] =~ /\{|\(/)  {$i++; next;}
		if ($items[$i] =~ /\-/) {$i++; next;}
		if (!$flag_unit) {$unit = $i;}
		$flag_unit = 1;
	}
	$i ++;
}
#print "$cnt_unit\n";
#print "$items[$unit-1]    AND    $items[$unit]    AND    $items[$unit+1]\n";

##################################################################################### if no unit? Then directly assign!!
if (!$cnt_unit)  {
	my $dir_var = substr($items[0], 0, length($items[0])-1);
	&directassign($dir_var);
}#{goto direct assign: $def_var = $item[0]}

while ($cnt_unit)  {
	
	if ((!$flag_minus) && (!$flag_unit)) {print "What a mess!!!!\n"; last;}
	#take out part w/o (){}
	my $tmp_var01 = $items[$unit-1];
	my $tmp_var02 = $items[$unit+1];
##################################################################################### judge "-" "[:]"
#first, need to fix judge "-" as one unit operator
	if ($flag_minus)  {
		my $pos_minus = index ($items[$minus], "-");
		my $end_minus = index ($items[$minus], ")");
		my $start_minus = $pos_minus -1;
		$tmp_var01 = substr($items[$minus], $pos_minus+1, $end_minus-$pos_minus-1);
#		print "I got an minus, var: $tmp_var01\n";
		substr($items[$minus], $start_minus, $end_minus-$start_minus+1) = "my_var_$cnt_tmp";
		&minus($tmp_var01, "my_var_$cnt_tmp");
		$cnt_tmp ++;
		$flag_minus = 0;
		$cnt_unit --;
		$flag_unit = 0;
		$i = 0;
		while ($items[$i])
		{
			if ($items[$i] =~ /\+|\-|\*|\<|\=\=|,/)  {
				if (($items[$i] =~ /\-/) && ($items[$i] =~ /\(/) && ($items[$i] =~ /\)/) )  {
#					print "I found a minus again!\n";
					$flag_minus = 1; $minus = $i;last;
				}
				if (!$i) {$i++; next;}
				if ($items[$i-1] =~ /\}|\)/)  {$i++; next;}
				if ($items[$i+1] =~ /\{|\(/)  {$i++; next;}
				if ($items[$i] =~ /\-/) {$i++; next;}
				if (!$flag_unit) {$unit = $i;}
				$flag_unit = 1;
			}
			$i ++;
		}
		next;
	}

#just finish "-" processing, next is regular process
	while ($tmp_var01 =~ /\{|\(/) {$tmp_var01 = substr($tmp_var01, 1);}
	while ($tmp_var02 =~ /\}|\)/) {$tmp_var02 = substr($tmp_var02, 0, length($tmp_var02)-1);}

############################################# process [i:j] ######################################	
	if (($tmp_var01 =~ /\[(\d+)\:(\d+)\]/) || ($tmp_var02 =~ /\[(\d+)\:(\d+)\]/))  {
		my $bit1 = $1;
		my $bit2 = $2;
		substr($tmp_var01, rindex($tmp_var01, "[")) = "";
		my $tmp_bit = $tmp_var01;
#		print "I'm processing a bit snip for $tmp_var01 from bit$bit1 to bit$bit2!\n";
		$tmp_var01 = "my_var_$cnt_tmp";
		$var_list{$tmp_var01} = 1;
#		print "$tmp_bit (<= $var_list{$tmp_bit})[n-1:n-1] = $tmp_var01 (<= $var_list{$tmp_var01})\n";
		&bitsnip($tmp_bit, $tmp_var01);
		substr($items[$unit-1], rindex($items[$unit-1], "(") + 1) = $tmp_var01;
		$cnt_tmp ++;
		
	}
		 
	
	#search 2 operands in hash, find out the bits
	
	# for example, C = A + B, we are getting representing for C, and change A + B to C.
	my $name_C;
	my $tmp_long = $items[$unit-1].$items[$unit+1];
	my $br_left; my $br_right;
	if ($items[$unit] eq ",")  {
		$br_left = rindex ($tmp_long, "{");
		$br_right = index ($tmp_long, "}");
#		print "Catenated!\n";
	}
	else  {
		$br_left = rindex ($tmp_long, "(");
		$br_right = index ($tmp_long, ")");
	}
	substr($tmp_long, $br_left, 1) = "";
	substr($tmp_long, $br_right - 1, 1) = "";  #because the length of str will decrease when we remove first one
	
	$cnt_unit --;  #we have successfully got one
	if ($cnt_unit)  {  #not the last one, build new my_var
		$name_C = "my_var_$cnt_tmp";
		$cnt_tmp ++;
	}
	else {$name_C = $def_var;}  #last one, just give head var name
	
	
	###################
	
	my $clip = substr($tmp_long, $br_left, $br_right - $br_left -1);
#	print "Clipped string: $clip\n";
	substr($tmp_long, $br_left, $br_right - $br_left -1) = $name_C;  #substitude name of C
	
	given($items[$unit])  {  #okay, output with A, B, C and maybe other parameter like n
		when(/\+/)  {print "constrains about $tmp_var01 + $tmp_var02 : \n";&add($tmp_var01, $tmp_var02, $name_C);}
#		when(/\-/)  {print "constrains about $tmp_var01 - $tmp_var02 : \n";}
		when(/\*/)  {print "constrains about $tmp_var01 * $tmp_var02 : \n";&multi($tmp_var01, $tmp_var02, $name_C);}
#		when(/\%/)  {print "constrains about $tmp_var01 % $tmp_var02 : \n";}
		when(/\</)  {print "constrains about $tmp_var01 < $tmp_var02 : \n";&lessthan($tmp_var01, $tmp_var02, $name_C);}
#		when(/\<\=/)  {print "constrains about $tmp_var01 <= $tmp_var02 : \n";}
#		when(/\>/)  {print "constrains about $tmp_var01 > $tmp_var02 : \n";}
#		when(/\>\=/)  {print "constrains about $tmp_var01 >= $tmp_var02 : \n";}
		when(/\=\=/)  {print "constrains about $tmp_var01 == $tmp_var02 : \n";&equal($tmp_var01, $tmp_var02, $name_C);}
		when(/,/)  {print "constrains about { $tmp_var01 , $tmp_var02 }: \n";&caten($tmp_var01, $tmp_var02, $name_C);}
		default {print "No match! But I got $items[$unit] as operator\n";}
	}
#	print "This is the cycle $cnt_unit, with tmp_var name : $name_C \n*********************************************\n";
	
	splice(@items, $unit-1, 3, $tmp_long);  # yeah, substitude of original 'A' '+' 'B' for 'C'
	
#	print "\nNow string: @items\n\n";
	
	if (!$cnt_unit) {last;}
	
	$i = 0; $flag_unit = 0;  # start new searching
	while ($items[$i])
	{
		if ($items[$i] =~ /\+|\-|\*|\<|\=\=|,/)  {
			if (($items[$i] =~ /\-/) && ($items[$i] =~ /\(/) && ($items[$i] =~ /\)/) )  {
#				print "I found a minus!\n";
				$flag_minus = 1; 
				$minus = $i;
				last;
			}
			if (!$i) {$i++; next;}
			if ($items[$i-1] =~ /\}|\)/)  {$i++; next;}
			if ($items[$i+1] =~ /\{|\(/)  {$i++; next;}
			if ($items[$i] =~ /\-/) {$i++; next;}
			if (!$flag_unit) {$unit = $i;}
			$flag_unit = 1;
		}
		$i ++;
	}
}
}
foreach (0..$cnt_tmp-1)  {
	print BEDROCK "var my_var_$_;\n";
}

sub directassign  {
	my $op = $_[0];
	print CPLEX "subject to K_$subject\n";
	$subject ++;
	print CPLEX " :$def_var - $op = 0;\n";
}
sub minus  {
	my $op = $_[0];
	my $obj = $_[1];
	print CPLEX "subject to K_$subject\n";
	$subject ++;
	print CPLEX " :$obj + $op = 0;\n";
	$var_list{$obj} = $var_list{$op};
}
sub bitsnip  {
	my $op = $_[0];
	my $obj = $_[1];
	print CPLEX "subject to K_$subject\n";
	$subject ++;
	my $bits = $var_list{$op}-1;
	print CPLEX "\#ok we are processing $op\[$bits\:$bits\] => $obj;\n";
}
sub add  {
	my $op1 = &const($_[0]);
	my $op2 = &const($_[1]);
	my $obj = $_[2];
	print CPLEX "subject to K_$subject\n";
	$subject ++;
	print CPLEX " :$obj - $op1 - $op2 = 0;\n";
	$var_list{$obj} = ($var_list{$_[0]} > $var_list{$_[1]})?$var_list{$_[0]}:$var_list{$_[1]};
}
sub lessthan  {
	my $op1 = &const($_[0]);
	my $op2 = &const($_[1]);
	my $obj = $_[2];
	$var_list{$obj} = ($var_list{$_[0]} > $var_list{$_[1]})?$var_list{$_[0]}:$var_list{$_[1]};
	print CPLEX "subject to K_$subject\n";
	$subject ++;
	print CPLEX " :$op1 - $op2 + (2^$var_list{$obj} - 1) * $obj <= -1 + (2^$var_list{$obj} - 1);\n";
	print CPLEX "subject to K_$subject\n";
	$subject ++;
	print CPLEX " :$op1 - $op2 + (2^$var_list{$obj} - 1) * $obj >= 0;\n";
}
sub equal  {
	my $op1 = &const($_[0]);
	my $op2 = &const($_[1]);
	my $obj = $_[2];
	$var_list{$obj} = 1;
	print CPLEX "subject to K_$subject\n";
	$subject ++;
	print CPLEX " :$op2 - $op1 <= 0;\n";
	print CPLEX "subject to K_$subject\n";
	$subject ++;
	print CPLEX " :$op2 - $op1 + 1 >= 1;\n";
	print CPLEX "subject to K_$subject\n";
	$subject ++;
	print CPLEX " :$op1 - $op2 + 1 >= 1;\n";
	print CPLEX "subject to K_$subject\n";
	$subject ++;
	print CPLEX " :$obj -1 = 0;\n";
}
sub multi  {
	my $op1 = &const($_[0]);
	my $op2 = &const($_[1]);
	my $obj = $_[2];
	$var_list{$obj} = ($var_list{$_[0]} > $var_list{$_[1]})?$var_list{$_[0]}:$var_list{$_[1]};
	print CPLEX "subject to K_$subject\n";
	$subject ++;
	print CPLEX "\#ok we are processing $op1 * $op2 = $obj;\n";
}
sub caten  {
	my $op1 = &const($_[0]);
	my $op2 = &const($_[1]);
	my $obj = $_[2];
	$var_list{$obj} = $var_list{$_[0]} + $var_list{$_[1]};
	print CPLEX "subject to K_$subject\n";
	$subject ++;
	print CPLEX " :$obj - (2^$var_list{$_[1]}) * $op1 - $op2 = 0;\n";
}
	

sub const  {
	my $string = $_[0];
	if($string =~ /'b/)  {
		my @num = split /'b/, $string;
		$var_list{$string} = $num[0];
		$string = oct('0b'.$num[1]);
	}
	return $string;
}