#!/usr/bin/env perl

use strict;
use warnings;

my $expr = shift();
my @fns = @ARGV;

# assemble a list of new filenames
my @new_fns = ();
my %counts = ();
for my $fn (@fns) {
    my $new_fn = $fn;
    eval "\$new_fn =~ $expr";
    push @new_fns, $new_fn;
    $counts{$new_fn}++;
    print "`$fn' -> `$new_fn'\n";
}

# check for duplicates
while (my ($k, $v) = each %counts) {
    if ($v > 1) {
        warn "filename $k repeated";
    }
}

# ask for proceeding
print "proceed? [Y/n] ";
chomp(my $input = lc <STDIN>);

# do the replacements
if ($input eq 'y') {
    for my $i (0..$#fns) {
        my $fn = $fns[$i];
        my $new_fn = $new_fns[$i];
        my $change = "`$fn' -> `$new_fn'";
        if (-e $new_fn) {
            die "file $fn exists";
        } elsif (rename $fn => $new_fn) {
            print $change;
        } else {
            warn "$change failed: $!\n";
        }
    }
}
