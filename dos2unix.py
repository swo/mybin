#!/usr/bin/env python
#
# author: scott olesen <swo@mit.edu>

import argparse, fileinput, sys

if __name__ == '__main__':
    p = argparse.ArgumentParser(description="", formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    p.add_argument('files', nargs='*')
    args = p.parse_args()

    #args.files = [sys.stdin if f == '-' else f for f in args.files]

    trans = str.maketrans('', '', '\r')

    for line in fileinput.input(args.files):
        print("this file is {}".format(fileinput.filename()))
        #print(line.translate(trans), end='')
        print(line, end='')
