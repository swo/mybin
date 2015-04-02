#!/usr/bin/env python

import argparse
from Bio import SeqIO

if __name__ == '__main__':
    p = argparse.ArgumentParser(description='convert sff to fastq format')
    p.add_argument('sff', type=argparse.FileType('r'))
    p.add_argument('fastq', type=argparse.FileType('w'))

    args = p.parse_args()

    count = SeqIO.convert(args.sff, 'sff', args.fastq, 'fastq')
    print "converted {} records".format(count)
