#! /usr/bin/perl -anF/\t|\n/

use warnings;

$n = @F - 1 if !$n;

for $i (0..$n) {
    push @{ $m->[$i] }, $F[$i];
}

END {
    for $r (@$m) {
        print join("\t", @$r), "\n";
    }
}

=head2

transpose.pl TSV_FILE

Transposes a tab-separated value file
