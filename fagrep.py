#!/usr/bin/env python
#
# author: scott w olesen <swo@mit.edu>

import argparse, re, sys
from Bio import SeqIO

def matching_entries(pattern, entries, inverted=False):
    for entry in entries:
        is_match = re.search(args.pattern, entry.id) is not None

        if inverted:
            is_match = not is_match

        if is_match:
            yield entry

if __name__ == '__main__':
    p = argparse.ArgumentParser()
    p.add_argument('pattern')
    p.add_argument('fasta', type=argparse.FileType('r'))
    p.add_argument('--inverse', '-v', action='store_true', help='return nonmatching entries?')
    args = p.parse_args()

    entries = matching_entries(args.pattern, SeqIO.parse(args.fasta, 'fasta'), args.inverse)
    SeqIO.write(entries, sys.stdout, 'fasta')