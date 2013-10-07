#!/usr/bin/env perl -w

use strict;
use File::SortedSeek ':all';

while (<>) {
    chomp;
    my $number = $_;
    if ($number eq 'not_found') {
        print "not_found\n";
        next;
    }

    open F, '/Users/scott/alm/data/ncbi/gi_taxid_nucl.dmp' or die $!;

    my $tell = numeric(*F, $number, \&get_first);
    my $line = <F>;
    chomp $line;

    if (File::SortedSeek::was_exact()) {
        my @a = split "\t", $line;
        print "$a[1]\n";
    } else {
        print "not_found\n";
    }
}

sub get_first {
    my $line = shift;
    return undef unless defined $line;

    my @bits = split "\t", $line;
    return $bits[0];
}

=head2 USAGE
gi2taxid.pl GI_NUMBER

Gets the corresponding NCBI Taxonomy ID by doing an intelligent search of the NCBI dump file
