#!/usr/bin/env python3
#
# author: scott olesen <swo@mit.edu>

import argparse, fileinput

def try_round(x, n_digits):
    try:
        y = float(x)
        return round(y, n_digits)
    except ValueError:
        return x

if __name__ == '__main__':
    p = argparse.ArgumentParser(description='round all float entries', formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    p.add_argument('--digits', '-n', metavar='N', type=int, default=2, help='digits after decimal place')
    p.add_argument('--separator', '-F', metavar='SEP', default='\t', help='record separator')
    p.add_argument('input', nargs='*', help='input files or stdin')
    args = p.parse_args()

    for line in fileinput.input(args.input):
        fields = line.rstrip().split(args.separator)
        new_fields = [try_round(field, args.digits) for field in fields]
        print(*new_fields, sep=args.separator)
