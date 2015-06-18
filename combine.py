#!/usr/bin/env python

# author:: scott olesen (swo@mit.edu)

import argparse, fileinput

if __name__ == '__main__':
    p = argparse.ArgumentParser(description="combines two files columnwise. output has length of first file.", formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    p.add_argument('--separator', '-F', default="\t")
    p.add_argument('input', nargs='+')
    args = p.parse_args()

    if len(args.input) < 2:
        raise RuntimeError('found only {} inputs, need at least 2'.format(len(args.input)))

    for lines in zip(*[fileinput.input(inp) for inp in args.input]):
        print(*[line.rstrip() for line in lines], sep="\t")
