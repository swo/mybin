#!/usr/bin/env perl

use warnings;
use strict;
use 5.10.1;

if (grep($_ eq "-h" || $_ eq "--help", @ARGV)) {
  say "usage: fasta_grep.pl PATTERN [files]"; exit;
}

my $pattern = shift @ARGV;

my $state = 0;
while (<>) {
  if (/^>/) {
    if (/$pattern/) {
      $state = 1;
      print;
    } else {
      $state = 0;
    }
  } elsif ($state == 1) {
    print;
  }
}

__END__
