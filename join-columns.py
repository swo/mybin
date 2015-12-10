#!/usr/bin/env python3

import argparse

p = argparse.ArgumentParser(description="join files column-wise")
p.add_argument('--sep', '-F', default="\t")
p.add_argument('fn', nargs='+')
args = p.parse_args()

fhs = [open(fn) for fn in args.fn]
for lines in zip(*fhs):
    print(*[l.rstrip() for l in lines], sep=args.sep)
