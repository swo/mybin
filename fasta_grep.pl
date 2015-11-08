#!/usr/bin/env perl

use warnings;
use strict;
use 5.10.1;
use Getopt::ArgParse;

my $ap = Getopt::ArgParse->new_parser(
    prog => 'fasta grep'
    ,description => 'show entries whose IDs match a pattern'
);

$ap->add_arg('--max_hits', '-m', default => 0, help => 'stop after M hits');
$ap->add_arg('pattern', help => 'search sequence IDs for this pattern');
my $ns = $ap->parse_args();

my $hits = 0;
my $pattern = $ns->pattern;

my $state = 0;
while (<>) {
  if (/^>/) {
    if ($ns->max_hits ne 0 and $hits >= $ns->max_hits) {
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
