#!/usr/bin/env python3

'''
author: scott w olesen (swo@mit.edu)
'''

import argparse, sys, csv

if __name__ == '__main__':
    p = argparse.ArgumentParser(description='melt a data table using the first column', formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    p.add_argument('table', type=argparse.FileType('r'))
    p.add_argument('--meta', '-m', type=argparse.FileType('r'), help='add variable metadata?')
    p.add_argument('--delimiter', '-F', default='\t')
    p.add_argument('--id', default='id', help='id column name')
    p.add_argument('--variable', default='variable', help='variable column name')
    p.add_argument('--value', default='value', help='value column name')
    p.add_argument('--output', '-o', type=argparse.FileType('w'), default=sys.stdout)
    args = p.parse_args()

    if args.meta is not None:
        reader = csv.DictReader(args.meta, delimiter='\t')
        meta_sample_header = reader.fieldnames[0]
        meta_headers = reader.fieldnames[1:]
        meta = {row[meta_sample_header]: row for row in reader}

    reader = csv.DictReader(args.table, delimiter=args.delimiter)
    idx = reader.fieldnames[0]
    variables = reader.fieldnames[1:]

    
    if args.meta is not None:
        header = [args.id, args.variable] + meta_headers + [args.value]
    else:
        header = [args.id, args.variable, args.value]

    print(*header, sep=args.delimiter, file=args.output)
    for row in reader:
        for v in variables:
            if args.meta is not None:
                words = [row[idx], v] + [meta[v][h] for h in meta_headers] + [row[v]]
            else:
                words = [row[idx], v, row[v]]

            print(*words, sep=args.delimiter, file=args.output)
