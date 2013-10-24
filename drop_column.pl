#!/usr/bin/env perl -w

use strict;

use Getopt::Long;

my %opts;
GetOptions(\%opts, 'help|?', 'delimiter|d=s');
die "drop_column.pl --delimiter/-d=',' N FILENAME\n" if $opts{'help'};

my $delim = $opts{'delimiter'};
$delim = ',' unless defined $delim;

my ($col, $fn) = @ARGV;
my $fh;

if (defined $fn) {
    open $fh, $fn or die $!;
} else {
    $fh = *STDIN;
}

while (<$fh>) {
    my @a = split $delim;
    splice @a, $col, 1;
    print join $delim, @a;
}

=head1

reads a csv file from file or standard input and deletes a particular column

drop_column.pl N FILENAME
