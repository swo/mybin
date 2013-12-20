#!/usr/bin/env perl

use warnings;
use strict;
use 5.10.1;

my $flag;
while(<>) {
    chomp;
    my @F = split /,/;

    unless ($flag) {
        $flag = 1;
        print "OTU_ID\t";
        say join "\t", map { "S$_" } (1 .. @F);
    }

    print "otu$.\t";
    say join "\t", @F;
}


__END__

reads in a csv file and writes out a fake OTU table representation

csv2otu.pl FILENAME
