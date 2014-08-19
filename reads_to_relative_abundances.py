#!/usr/bin/env python

'''
reads_to_relative_abundances.py

author: scott w olesen (swo@mit.edu)

goes from counts to relative abundances
'''

import pysurvey as ps, numpy as np
import argparse

if __name__ == '__main__':
	p = argparse.ArgumentParser(description='counts to relative abundances')
	p.add_argument('table', help='input otu table')
	p.add_argument('out', help='output otu table')
	p.add_argument('-p', '--pseudo', type=int, help='add pseudocounts?')
	args = p.parse_args()

	# read in table
	table = ps.read_txt(args.table, verbose=False)

	# normalize
	if args.pseudo:
		table = ps.to_fractions(table, method='pseudo', p_counts=arg.pseudo)
	else:
		table = ps.to_fractions(table, method='normalize')

	# write the output table
	ps.write_txt(table, args.out)