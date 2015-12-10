#!/usr/bin/env sed -n -f

:a
# if not the last line, append line to pattern space
$! N
# if pattern space doesn't begin with >
# then delete any newlines before anything but >
/^>/! s/\n\([^>]\)/\1/
# if that match worked (i.e., we weren't in a > line?), go to :a
t a
# print the first line of the pattern space
P
# delete the first line of the pattern space
D
