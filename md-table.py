#!/usr/bin/env python3

import argparse, sys

def md_table(records, margin=1):
    # all should be the same length
    assert len(set([len(r) for r in records])) == 1

    # find the width of all the columns
    columns = list(zip(*records))
    widths = [max([len(r) for r in column]) for column in columns]

    justified_columns = [[field.ljust(width) for field in column] for column, width in zip(columns, widths)]
    justified_columns[-1] = [r.rstrip() for r in justified_columns[-1]]
    justified_records = list(zip(*justified_columns))

    sep = " " * margin
    out = [sep.join(justified_records[0])]
    out.append(sep.join(["-" * w for w in widths]))

    for row in justified_records[1:]:
        out.append(sep.join(row))

    return out


if __name__ == '__main__':
    p = argparse.ArgumentParser(description="create a markdown table")
    p.add_argument('input', type=argparse.FileType('r'), nargs='*')
    args = p.parse_args()

    if len(args.input) == 0:
        args.input = [sys.stdin]

    records = []
    for inp in args.input:
        records += [line.rstrip().split() for line in inp]

    table = md_table(records)
    for line in table:
        print(line)
