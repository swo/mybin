#!/usr/bin/env perl -w

use strict;
use LWP::Simple;

while (<>) {
    chomp;
    my $acc = $_;
    if ($acc eq "not_found") {
        print "not_found\n";
        next;
    }

    #assemble the URL
    my $base = 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/';
    my $url = $base . "efetch.fcgi?db=nucleotide&id=$acc&rettype=gi";

    #post the URL
    my $output = get($url);
    if ($output) {
        print $output;
    } else {
        print "not_found\n";
    }
}


=head2 USAGE
./acc2gi.pl ACCESSION_NUMBER

or reads from standard input

Queries the NCBI server to get the number
