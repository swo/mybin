#!/usr/bin/env python

'''
Load a fasta, keep track of all the sequences. If one entry has the same sequence or a
subsequence of another, make note of that.
'''

import argparse, sys
from Bio import SeqIO

def out_line(source, rid, op):
	out = "{} {} ".format(rid, op)
	for kid in source:
		out += "{} ".format(kid)

	return out


if __name__ == '__main__':
    # parse command line arguments
    parser = argparse.ArgumentParser(description='create a mapping of fasta sequences')
    parser.add_argument('fasta', help='input fasta file')
    parser.add_argument('-o', '--output', default=sys.stdout, type=argparse.FileType('w'), help='output file (default stdout)')
    args = parser.parse_args()

    knowns = {}
    for record in SeqIO.parse(args.fasta, 'fasta'):
    	seq = str(record.seq)
    	equals = [known_id for known_id, known_seq in knowns.items() if seq == known_seq]
    	if equals:
    		print out_line(equals, record.id, '=')
    	else:
    		substrings = [known_id for known_id, known_seq in knowns.items() if seq in known_seq]

    		if substrings:
    			print out_line(substrings, record.id, 'substring of')
    		else:
				knowns[record.id] = seq