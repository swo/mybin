#!/usr/bin/env python
#
# author: scott olesen <swo@mit.edu>

import argparse, sys, fileinput

if __name__ == '__main__':
    p = argparse.ArgumentParser(description='get lines whose first entry matches some list', formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    p.add_argument('entries', type=argparse.FileType('r'), help='file with newline-separated entries')
    p.add_argument('input', nargs='*', help='list of filenames or - for stdin')
    p.add_argument('--delimiter', '-F', default='\t', help='input lines record separator')
    p.add_argument('--output', '-o', type=argparse.FileType('w'), default=sys.stdout)
    p.add_argument('--header', '-d', action='store_true', help='output first line of input?')
    args = p.parse_args()

    # grab the entries
    entries = {l.rstrip(): 0 for l in args.entries.readlines()}

    for line in fileinput.input(args.input):
        if (args.header and fileinput.lineno() == 1) or (line.split(args.delimiter)[0] in entries):
            args.output.write(line)