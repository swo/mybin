#!/usr/bin/perl -w

use strict;

local $/ = ">";         # split 'lines' using > instead of \n

my $c = 0;              # initialize the count
while (<>) {
    next if m/^>/;      # the first 'line' in a file is just '>', so skip that
    chomp;              # remove the final '>' just after the newline
    print ">";          # print the '>' instead at the start of the line
    s/[^_]_\K[^ ]*/$c/; # replace 'Sample_123' with 'Sample_$c'
    print;              # paste the substituted line
    $c++;               # increment the counter
}

=head2

combine_fna.pl FILE1 FILE2 .. [--]

Loop over .fna files (or standard input), replacing the original Qiime numbers with a new set
of sequential numbers and concatenating the files, e.g.,

FILE1:
>Sample1_0 ...
>Sample1_1 ...
...
>Sample5_100 ...

FILE2:
>SampleA_0 ...
>SampleA_1 ...
...

becomes

>Sample1_0
>Sample1_1
...
>Sample5_100
>SampleA_101
>SampleA_102
...
