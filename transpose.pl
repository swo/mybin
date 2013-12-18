#! /usr/bin/perl

use warnings;
use 5.10.1;

use Getopt::Long;
my %opts;
GetOptions(\%opts, 'help|?', 'delimiter|d=s');
die "transpose.pl --delimiter/-d=',' FILENAME\n" if $opts{'help'};

my $delim = $opts{'delimiter'};
$delim = ',' unless defined $delim;
$delim = "\t" if $delim eq 'tab';

my $fn = shift;
my $fh;
if (defined $fn) {
    open $fh, $fn or die $!;
} else {
    $fh = *STDIN;
}

while (<$fh>) {
    chomp;
    @F = split /$delim/;

    for $i (0..$#F) {
        push @{$m->[$i]}, $F[$i];
    }
}

for $r (@$m) {
    say join $delim, @$r;
}

=head2

Transposes a tab-separated value file

default delimiter is comma. Tab can be set with -d=tab or -d="whatever"

transpose.pl FILENAME
