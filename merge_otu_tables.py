#!/usr/bin/env python

import argparse, pandas as pd

def get0(df, h, i, default=0):
    '''get a value from dataframe df corresponding to header h and index i, or return default'''
    if h not in df:
        return default
    else:
        if i not in df[h]:
            return default
        else:
            return df[h][i]

p = argparse.ArgumentParser(description="Combine reads from two otu tables")
p.add_argument("table1", type=str, help="input OTU table 1")
p.add_argument("table2", type=str, help="input OTU table 2")
args = p.parse_args()

# read in data tables
t1 = pd.read_table(args.table1, index_col=0)
t2 = pd.read_table(args.table2, index_col=0)

# get the headers and indices (otu ids) for each sample
h1 = t1.keys()
h2 = t2.keys()
i1 = t1.index
i2 = t2.index

# get a common list of headers and indices
hs = sorted(list(set(list(h1) + list(h2))))
ix = sorted(list(set(list(i1) + list(i2))))

# print out the header
print "\t".join(["OTU_ID"] + hs)

# print out the following lines
for i in ix:
    print "\t".join([i] + [str(get0(t1, h, i) + get0(t2, h, i)) for h in hs])
