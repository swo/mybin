#!/usr/bin/env perl

use strict;
use warnings;

# get filepaths from command line
my $fp1 = shift;
my $fp2 = shift;

open(my $fh1, $fp1);
open(my $fh2, $fp2);

my $l1 = <$fh1>;
my $l2 = <$fh2>;
while (not eof($fh1) and not eof($fh2)) {
    # extract the first column
    my $tax1 = +(split /\s+/, $l1)[0];
    my $tax2 = +(split /\s+/, $l2)[0];

    # if the first field is equal, then show the whole line
    # otherwise, move down a line
    if ($tax1 eq $tax2) {
        print $l1;
        $l1 = <$fh1>;
        $l2 = <$fh2>;
    } elsif ($tax1 lt $tax2) {
        $l1 = <$fh1>;
    } elsif ($tax1 gt $tax2) {
        $l2 = <$fh2>;
    }
}
