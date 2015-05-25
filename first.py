#!/usr/bin/env python
#
# author: scott w olesen <swo@mit.edu>

import argparse, fileinput

if __name__ == '__main__':
    p = argparse.ArgumentParser(description="get the first field from every line")
    p.add_argument('--separator', '-F', default="\t")
    p.add_argument('input', nargs='*')
    args = p.parse_args()

    for line in fileinput.input(args.input):
        print(line.rstrip().split(args.separator)[0])