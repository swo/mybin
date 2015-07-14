#!/usr/bin/env python
#
# author: scott olesen <swo@mit.edu>

import argparse, fileinput, csv

if __name__ == '__main__':
    p = argparse.ArgumentParser(description="in a file with column labels, sum delimited data", formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    p.add_argument('--index', '-i', action='store_true', help='ignore first column?')
    p.add_argument('--delimiter', '-F', default="\t", help='record delimiter')
    p.add_argument('--cast', '-c', default="float(x)", help='function to cast record to numeric type (lambda x: ...)')
    p.add_argument('input', nargs='+')
    args = p.parse_args()

    reader = csv.DictReader(fileinput.input(args.input), delimiter=args.delimiter, quoting=csv.QUOTE_MINIMAL)

    cast = eval("lambda x: " + args.cast)

    if args.index:
        fields = reader.fieldnames[1:]
    else:
        fields = reader.fieldnames

    accs = {field: 0 for field in fields}

    for row in reader:
        for field in fields:
            accs[field] += cast.__call__(row[field])

    for field in fields:
        print(field, accs[field], sep=args.delimiter)
