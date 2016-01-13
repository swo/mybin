#!/usr/bin/env python3

import argparse

p = argparse.ArgumentParser(description="join files column-wise")
p.add_argument('--sep', '-F', default="\t")
p.add_argument('fn', type=argparse.FileType('r'), nargs='+')
args = p.parse_args()

for lines in zip(*args.fn):
    print(*[l.rstrip() for l in lines], sep=args.sep)
