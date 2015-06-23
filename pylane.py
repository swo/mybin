#!/usr/bin/env python
#
# author: scott olesen <swo@mit.edu>

import argparse, fileinput

if __name__ == '__main__':
    p = argparse.ArgumentParser(description="", formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    p.add_argument('script')
    p.add_argument('--delimiter', '-F', default='\t')
    p.add_argument('--no_print', '-n', action='store_true')
    p.add_argument('--no_strip', '-s', action='store_true')
    p.add_argument('input', nargs='*')
    args = p.parse_args()

    for line in fileinput.input(args.input):
        if args.no_strip:
            _ = line
        else:
            _ = line.rstrip()

        F = _.split(args.delimiter)

        if args.no_print:
            eval(args.script)
        else:
            print(eval(args.script))
