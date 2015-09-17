#!/usr/bin/env perl

use warnings;
use strict;
use 5.10.1;

if (grep($_ eq "-h" || $_ eq "--help", @ARGV)) {
  say "usage: fasta_grep.pl M PATTERN [files]"; exit;
}

my $max_hits = shift @ARGV;
my $pattern = shift @ARGV;
my $hits = 0;

my $state = 0;
while (<>) {
  if (/^>/) {
    if ($hits >= $max_hits) {
      last;
    } elsif (/$pattern/) {
      $state = 1;
      $hits += 1;
      print;
    } else {
      $state = 0;
    }
  } elsif ($state == 1) {
    print;
  }
}

__END__
