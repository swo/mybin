#!/usr/bin/env python

from Bio import SeqIO
import argparse, itertools

def compare_fasta(fasta1, fasta2):
    for record1, record2 in itertools.izip(SeqIO.parse(fasta1, 'fasta'), SeqIO.parse(fasta2, 'fasta')):
        if record1.id != record2.id:
            return "records do not match: '{}' and '{}'".format(record1.id, record2.id)

        if str(record1.seq) != str(record2.seq):
            return "sequences do not match for records {} and {}".format(record1.id, record2.id)        	

    return "fastas identical"

if __name__ == '__main__':
    p = argparse.ArgumentParser(description="compare fasta entries, ignoring formatting differences")
    p.add_argument('fasta1')
    p.add_argument('fasta2')
    args = p.parse_args()

    print compare_fasta(args.fasta1, args.fasta2)