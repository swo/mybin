#!/usr/bin/env perl

use warnings;
use strict;
use 5.10.1;

if (grep($_ eq "-h" || $_ eq "--help", @ARGV)) {
  say "usage: trim_lines.pl N [files]";
  exit;
}

my $N = shift @ARGV;

unless ($N =~ /^[1-9][0-9]*$/) {
  say "error: I can't cast '$N' as a number";
  exit;
}

while (<>) {
  say +(substr $_, 0, $N);
}

__END__
