my ($col, $fn) = @ARGV;

if (defined $fn) {
    open $fh, $fn or die $!;
} else {
    $fh = *STDIN;
}

while (<$fh>) {
    @a = split ',';
    splice @a, $col, 1;
    print join ',', @a;
}

=head2

reads a csv file from file or standard input and deletes a particular column

drop_column.pl N FILENAME
