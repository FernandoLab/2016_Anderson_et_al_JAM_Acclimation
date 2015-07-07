#!/usr/bin/perl -w

use strict;
use Getopt::Long;

#Command line parameters:
my $distance_file = "";
my $mapping_file = "";
my $category = "";

#Setup the command line options using Getopt:Long
my $commandline = GetOptions("distance_file:s", \$distance_file,
			"mapping_file:s", \$mapping_file,
			"category:s", \$category);

if (!$commandline || $distance_file eq "" || $mapping_file eq "" || $category eq ""  ) {
	print STDERR "\nUsage: $0 -distance_file -mapping_file -category \n\n";
	exit;
}

open (my $MAPPING, "$mapping_file") or die "Can't open mapping file!";
open (my $DIST, "$distance_file") or die "Can't open distance file!";
open (my $OUTPUT, ">treatment_distances.txt") or die "Can't open output file!";

my %grouping_hash;
my $line_number = 0;
my $category_number = "";

#need to store the treatment/grouping for each sample in hash
while (my $line = readline($MAPPING)) {
	chomp $line;
	my @line_split = split /\t/, $line;
	$line_number ++;
	if ($line_number == 1) {
		my $counter = 0;
		foreach my $ele (@line_split) {
			if ($category eq $ele) {
				$category_number = $counter;
			}
			$counter ++;
		}
	} else {
		$grouping_hash{$line_split[0]} = $line_split[$category_number];
	}
}

print $OUTPUT "Sample1Diet_Sample2Diet\tSample1\tSample1_Diet\tSample2\tSample2_Diet\tDistance\n";

my $pairwise_in = -1;

while (my $line = readline($DIST)) {
	chomp $line;
	$line =~ s/\"//g;
	my @line_split = split /\t/, $line;
	$pairwise_in ++;
	if ($pairwise_in == 0) {
		next;
	}
	if ($grouping_hash{$line_split[0]} eq "C1") {
		print $OUTPUT "$grouping_hash{$line_split[0]}"."_$grouping_hash{$line_split[1]}\t$line_split[0]\t$grouping_hash{$line_split[0]}\t$line_split[1]\t$grouping_hash{$line_split[1]}\t$line_split[2]\n";
		next;
	}
	if ($grouping_hash{$line_split[1]} eq "C1") {
		print $OUTPUT "$grouping_hash{$line_split[1]}"."_$grouping_hash{$line_split[0]}\t$line_split[1]\t$grouping_hash{$line_split[1]}\t$line_split[0]\t$grouping_hash{$line_split[0]}\t$line_split[2]\n";
		next;
	}
	if ($grouping_hash{$line_split[0]} eq "R1") {
		print $OUTPUT "$grouping_hash{$line_split[0]}"."_$grouping_hash{$line_split[1]}\t$line_split[0]\t$grouping_hash{$line_split[0]}\t$line_split[1]\t$grouping_hash{$line_split[1]}\t$line_split[2]\n";
		next;
	}
	if ($grouping_hash{$line_split[1]} eq "R1") {
		print $OUTPUT "$grouping_hash{$line_split[1]}"."_$grouping_hash{$line_split[0]}\t$line_split[1]\t$grouping_hash{$line_split[1]}\t$line_split[0]\t$grouping_hash{$line_split[0]}\t$line_split[2]\n";
		next;
	}
	
	
	if ($grouping_hash{$line_split[0]} eq "C2") {
		print $OUTPUT "$grouping_hash{$line_split[0]}"."_$grouping_hash{$line_split[1]}\t$line_split[0]\t$grouping_hash{$line_split[0]}\t$line_split[1]\t$grouping_hash{$line_split[1]}\t$line_split[2]\n";
		next;
	}
	if ($grouping_hash{$line_split[1]} eq "C2") {
		print $OUTPUT "$grouping_hash{$line_split[1]}"."_$grouping_hash{$line_split[0]}\t$line_split[1]\t$grouping_hash{$line_split[1]}\t$line_split[0]\t$grouping_hash{$line_split[0]}\t$line_split[2]\n";
		next;
	}
	if ($grouping_hash{$line_split[0]} eq "R2") {
		print $OUTPUT "$grouping_hash{$line_split[0]}"."_$grouping_hash{$line_split[1]}\t$line_split[0]\t$grouping_hash{$line_split[0]}\t$line_split[1]\t$grouping_hash{$line_split[1]}\t$line_split[2]\n";
		next;
	}
	if ($grouping_hash{$line_split[1]} eq "R2") {
		print $OUTPUT "$grouping_hash{$line_split[1]}"."_$grouping_hash{$line_split[0]}\t$line_split[1]\t$grouping_hash{$line_split[1]}\t$line_split[0]\t$grouping_hash{$line_split[0]}\t$line_split[2]\n";
		next;
	}
	
	if ($grouping_hash{$line_split[0]} eq "C3") {
		print $OUTPUT "$grouping_hash{$line_split[0]}"."_$grouping_hash{$line_split[1]}\t$line_split[0]\t$grouping_hash{$line_split[0]}\t$line_split[1]\t$grouping_hash{$line_split[1]}\t$line_split[2]\n";
		next;
	}
	if ($grouping_hash{$line_split[1]} eq "C3") {
		print $OUTPUT "$grouping_hash{$line_split[1]}"."_$grouping_hash{$line_split[0]}\t$line_split[1]\t$grouping_hash{$line_split[1]}\t$line_split[0]\t$grouping_hash{$line_split[0]}\t$line_split[2]\n";
		next;
	}
	if ($grouping_hash{$line_split[0]} eq "R3") {
		print $OUTPUT "$grouping_hash{$line_split[0]}"."_$grouping_hash{$line_split[1]}\t$line_split[0]\t$grouping_hash{$line_split[0]}\t$line_split[1]\t$grouping_hash{$line_split[1]}\t$line_split[2]\n";
		next;
	}
	if ($grouping_hash{$line_split[1]} eq "R3") {
		print $OUTPUT "$grouping_hash{$line_split[1]}"."_$grouping_hash{$line_split[0]}\t$line_split[1]\t$grouping_hash{$line_split[1]}\t$line_split[0]\t$grouping_hash{$line_split[0]}\t$line_split[2]\n";
		next;
	}
	
	
	if ($grouping_hash{$line_split[0]} eq "C4") {
		print $OUTPUT "$grouping_hash{$line_split[0]}"."_$grouping_hash{$line_split[1]}\t$line_split[0]\t$grouping_hash{$line_split[0]}\t$line_split[1]\t$grouping_hash{$line_split[1]}\t$line_split[2]\n";
		next;
	}
	if ($grouping_hash{$line_split[1]} eq "C4") {
		print $OUTPUT "$grouping_hash{$line_split[1]}"."_$grouping_hash{$line_split[0]}\t$line_split[1]\t$grouping_hash{$line_split[1]}\t$line_split[0]\t$grouping_hash{$line_split[0]}\t$line_split[2]\n";
		next;
	}
	if ($grouping_hash{$line_split[0]} eq "R4") {
		print $OUTPUT "$grouping_hash{$line_split[0]}"."_$grouping_hash{$line_split[1]}\t$line_split[0]\t$grouping_hash{$line_split[0]}\t$line_split[1]\t$grouping_hash{$line_split[1]}\t$line_split[2]\n";
		next;
	}
	if ($grouping_hash{$line_split[1]} eq "R4") {
		print $OUTPUT "$grouping_hash{$line_split[1]}"."_$grouping_hash{$line_split[0]}\t$line_split[1]\t$grouping_hash{$line_split[1]}\t$line_split[0]\t$grouping_hash{$line_split[0]}\t$line_split[2]\n";
		next;
	}
	
	if ($grouping_hash{$line_split[0]} eq "CF") {
		print $OUTPUT "$grouping_hash{$line_split[0]}"."_$grouping_hash{$line_split[1]}\t$line_split[0]\t$grouping_hash{$line_split[0]}\t$line_split[1]\t$grouping_hash{$line_split[1]}\t$line_split[2]\n";
		next;
	}
	if ($grouping_hash{$line_split[1]} eq "CF") {
		print $OUTPUT "$grouping_hash{$line_split[1]}"."_$grouping_hash{$line_split[0]}\t$line_split[1]\t$grouping_hash{$line_split[1]}\t$line_split[0]\t$grouping_hash{$line_split[0]}\t$line_split[2]\n";
		next;
	}
	if ($grouping_hash{$line_split[0]} eq "RF") {
		print $OUTPUT "$grouping_hash{$line_split[0]}"."_$grouping_hash{$line_split[1]}\t$line_split[0]\t$grouping_hash{$line_split[0]}\t$line_split[1]\t$grouping_hash{$line_split[1]}\t$line_split[2]\n";
		next;
	}
	if ($grouping_hash{$line_split[1]} eq "RF") {
		print $OUTPUT "$grouping_hash{$line_split[1]}"."_$grouping_hash{$line_split[0]}\t$line_split[1]\t$grouping_hash{$line_split[1]}\t$line_split[0]\t$grouping_hash{$line_split[0]}\t$line_split[2]\n";
		next;
	}
	
	
}


print "\nNumber of pairwise comparisons read in: $pairwise_in\n\n";








#read in sample ID from distance matrix
#look up ID in mapping file to get diet
#will need user input for mapping column to use, then find it in header line and number
#push all values to array or hash
#print all values to output file that can be used for box and whisker
