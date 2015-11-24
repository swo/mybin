#!/usr/bin/env python3

'''
author: scott w olesen (swo@mit.edu)
'''

import numpy as np, pandas as pd
import argparse, itertools, sys, itertools

import warnings
warnings.filterwarnings("ignore", category = RuntimeWarning)

def jsd(x, y):
    p = np.array(x)
    q = np.array(y)
    m = 0.5 * (p + q)
    d1 = p * np.log2(p / m)
    d2 = q * np.log2(q / m)
    d1[np.isnan(d1)] = 0
    d2[np.isnan(d2)] = 0

    d = 0.5 * np.sum(d1) + 0.5 * np.sum(d2)
    return d

def distance_matrix(table):
    nrow, ncol = table.shape

    dist = pd.DataFrame(index=table.columns, columns=table.columns)

    for col1, col2 in itertools.combinations_with_replacement(table.columns.values, 2):
        d = jsd(table[col1], table[col2])
        dist[col1][col2] = d
        dist[col2][col1] = d

    return dist

if __name__ == '__main__':
    p = argparse.ArgumentParser(description='make a list of JSD values')
    p.add_argument('table', help='otu table (will be normalized automatically)')
    p.add_argument('--output', '-o', type=argparse.FileType('w'), default=sys.stdout, help='output list')
    args = p.parse_args()

    table = pd.read_table(args.table, index_col=0)
    norm = table.apply(lambda col: col.astype(float) / np.sum(col), axis=0)
    dist = distance_matrix(norm)

    print('sample1', 'sample2', 'jsd', sep="\t", file=args.output)
    for a, b in itertools.combinations(dist.index, 2):
        print(a, b, dist[a][b], sep='\t', file=args.output)
