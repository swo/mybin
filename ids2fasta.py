#!/usr/bin/env python

'''

'''

import argparse, cPickle as pickle
from Bio import SeqIO

def ids_to_fasta(ids, seq_dict):
    for i in ids:
        seq = seq_dict[i]


def fasta_file_to_dict(fh):
    '''fasta file to {id => sequence}'''
    return {record.id: str(record.seq) for record in SeqIO.parse(fh, 'fasta')}


if __name__ == '__main__':
    # parse command line arguments
    parser = argparse.ArgumentParser()
    parser.add_argument('pickle', help='fasta pickle')
    parser.add_argument('ids')
    args = parser.parse_args()

    with open(args.pickle, 'rb') as f:
        d = pickle.load(f)

    with open(args.ids) as f:
        for line in f:
            i = line.strip()
            print ">{}\n{}".format(i, d[i])
