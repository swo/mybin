#!/usr/bin/env python

import argparse, pysurvey as ps, pandas as pd, numpy as np

def shannon(x):
    y = np.array(x, dtype=float)
    y = y[y > 0]    # get nonzero values
    y /= np.sum(y)  # convert to rel abund
    return -np.sum(y * np.log2(y))

if __name__ == '__main__':
    p = argparse.ArgumentParser()
    p.add_argument('table', help='input otu table')
    p.add_argument('-o', '--output_dir', default='proc', help='output directory (default: proc)')
    args = p.parse_args()

    otu_sum_fn, sample_sum_fn, shannon_fn, abund_fn, log_fn = ["{}/{}.txt".format(args.output_dir, n) for n in ['otu_sum', 'sample_sum', 'shannon', 'abund', 'log']]

    table = ps.read_txt(args.table)

    otu_sum = table.apply(np.sum, axis=0)
    np.savetxt(otu_sum_fn, otu_sum)

    sample_sum = table.apply(np.sum, axis=1)
    np.savetxt(sample_sum_fn, sample_sum)

    shannon_vals = table.apply(shannon, axis=1)
    np.savetxt(shannon_fn, shannon_vals)

    abund = ps.normalize(table)
    ps.write_txt(abund, abund_fn)

    abund_with_pseudocount = ps.to_fractions(table, method='pseudo', p_counts=1)
    log_table = np.log10(abund_with_pseudocount)
    ps.write_txt(log_table, log_fn)
