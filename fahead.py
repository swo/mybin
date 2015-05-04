#!/usr/bin/env python
#
# author: scott w olesen <swo@mit.edu>

import argparse, sys, itertools
from Bio import SeqIO

if __name__ == '__main__':
    p = argparse.ArgumentParser()
    p.add_argument('--number', '-n', type=int, default=5, help='number of entries')
    p.add_argument('fasta', type=argparse.FileType('r'))
    args = p.parse_args()

    entries = itertools.islice(SeqIO.parse(args.fasta, 'fasta'), 0, args.number, 1)
    SeqIO.write(entries, sys.stdout, 'fasta')
