#!/usr/bin/env python3
#
# author: scott w olesen <swo@mit.edu>

import argparse, re, sys
from Bio import SeqIO

class EntryMatcher:
    def __init__(self, pattern, entries, inverted=False, max_count=None):
        self.pattern = pattern
        self.entries = entries
        self.inverted = inverted
        self.max_count = max_count
        self.count = 0

        if self.inverted:
            self.is_good_entry = lambda entry: not self.is_match(entry)
        else:
            self.is_good_entry = lambda entry: self.is_match(entry)

    def is_match(self, entry):
        return re.search(self.pattern, entry.id) is not None

    def parse(self):
        return iter(self)

    def __iter__(self):
        for entry in self.entries:
            if self.max_count is not None and self.count >= self.max_count:
                raise StopIteration

            if self.is_good_entry(entry):
                self.count += 1
                yield entry


def matching_entries(pattern, entries, inverted=False, max_count=None):
    if inverted:
        is_match = lambda entry: re.search(args.pattern, entry.id) is None
    else:
        is_match = lambda entry: re.search(args.pattern, entry.id) is not None

    for entry in entries:
        if is_match(entry):
            yield entry

if __name__ == '__main__':
    p = argparse.ArgumentParser()
    p.add_argument('pattern')
    p.add_argument('fasta', type=argparse.FileType('r'))
    p.add_argument('--max_count', '-m', metavar='M', type=int, default=None, help='stop reading after M matching entries')
    p.add_argument('--inverse', '-v', action='store_true', help='return nonmatching entries?')
    args = p.parse_args()

    entries = EntryMatcher(args.pattern, SeqIO.parse(args.fasta, 'fasta'), args.inverse, max_count=args.max_count).parse()
    SeqIO.write(entries, sys.stdout, 'fasta')
