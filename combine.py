#!/usr/bin/env python

# author:: scott olesen (swo@mit.edu)

import argparse, fileinput

if __name__ == '__main__':
    p = argparse.ArgumentParser(description="combines two files columnwise. output has length of first file.", formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    p.add_argument('--separator', '-F', default="\t")
    p.add_argument('left')
    p.add_argument('right')
    args = p.parse_args()

    for line1, line2 in zip(fileinput.input(args.left), fileinput.input(args.right)):
        print("\t".join([line.rstrip() for line in [line1, line2]]))