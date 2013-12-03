#!/usr/bin/env perl -w

use strict;

use Getopt::Long;

my %opts;
GetOptions(\%opts, 'help|?', 'delimiter|d=s', 'last|l');
die "drop_column.pl --delimiter/-d=',' N FILENAME\n" if $opts{'help'};

my $delim = $opts{'delimiter'};
$delim = "\t" if $delim eq 'tab';
$delim = ',' unless defined $delim;

my $col = shift unless $opts{'last'};
my $fn = shift;

my $fh;
if (defined $fn) {
    open $fh, $fn or die $!;
} else {
    $fh = *STDIN;
}

while (<$fh>) {
    chomp;
    my @a = split $delim;

    if ($opts{'last'}) {
        pop @a;
    } else {
        splice @a, $col, 1;
    }

    print join $delim, @a;
    print "\n";
}

=head1

reads a csv file from file or standard input and deletes a particular column

default delimiter is comma. Tab can be set with -d=tab or -d="whatever"

drop_column.pl N FILENAME
