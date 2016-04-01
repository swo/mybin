#!/usr/bin/env python
#
# author: scott olesen <swo@mit.edu>

import argparse, sys

if __name__ == '__main__':
    p = argparse.ArgumentParser(description="", formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    p.add_argument('input', type=argparse.FileType('r'), nargs='?', default=sys.stdin)
    p.add_argument('--margin', type=int, default=1)
    args = p.parse_args()

    margin = " " * args.margin

    lines = [l.rstrip() for l in args.input]
    columns = zip(*[line.split("\t") for line in lines])
    column_width = lambda fields: max([len(f) for f in fields])
    column_widths = [column_width(c) for c in columns]

    for i in range(len(lines)):
        fields = [c[i] for c in columns]
        out_fields = [field.ljust(width) for field, width in zip(fields, column_widths)]
        out_line = margin.join(out_fields)

        print(out_line)

        if i == 0:
            # also print a separating line for the header
            out_line = margin.join(["-" * width for width in column_widths])
            print(out_line)

    # end with a blank line
    print("")
