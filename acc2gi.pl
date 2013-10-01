#!/usr/bin/env perl -w

use strict;
use LWP::Simple;

my $acc = $ARGV[0];
if (not $acc) { $acc = <STDIN>; }

#assemble the URL
my $base = 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/';
my $url = $base . "efetch.fcgi?db=nucleotide&id=$acc&rettype=gi";

#post the URL
my $output = get($url);
print $output;


=head2 USAGE
./acc2gi.pl ACCESSION_NUMBER

or reads from standard input

Queries the NCBI server to get the number
