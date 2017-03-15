#!/usr/bin/env python3
#
# author: scott w olesen <swo@mit.edu>

import argparse, re, sys
from Bio import SeqIO

class EntryMatcher:
    def __init__(self, patterns, entries, inverted=False, max_count=None, whole_name=False):
        self.patterns = patterns
        self.entries = entries
        self.inverted = inverted
        self.max_count = max_count
        self.whole_name = whole_name
        self.count = 0

        if self.inverted:
            self.is_good_entry = lambda entry: not self.is_match(entry)
        else:
            self.is_good_entry = lambda entry: self.is_match(entry)

        if self.whole_name:
            self.patterns = ['^' + x + '$' for x in self.patterns]

    def is_match(self, entry):
        for p in self.patterns:
            if re.search(p, entry.id) is not None:
                return True

        return False

    def parse(self):
        return iter(self)

    def __iter__(self):
        for entry in self.entries:
            if self.max_count is not None and self.count >= self.max_count:
                raise StopIteration

            if self.is_good_entry(entry):
                self.count += 1
                yield entry


if __name__ == '__main__':
    p = argparse.ArgumentParser()
    p.add_argument('pattern', nargs='?')
    p.add_argument('fasta', type=argparse.FileType('r'))
    p.add_argument('--max_count', '-m', metavar='M', type=int, default=None, help='stop reading after M matching entries')
    p.add_argument('--inverse', '-v', action='store_true', help='return nonmatching entries?')
    p.add_argument('--word', '-W', action='store_true', help='match name only?')
    p.add_argument('--file', '-f', default=None, help='read patterns from file')
    args = p.parse_args()

    if args.file is None:
        if args.pattern is None:
            raise RuntimeError('pattern or -f required')
        else:
            patterns = [args.pattern]
    else:
        with open(args.file) as f:
            patterns = [line.rstrip() for line in f]

    entries = EntryMatcher(patterns, SeqIO.parse(args.fasta, 'fasta'), args.inverse, max_count=args.max_count, whole_name=args.word).parse()
    SeqIO.write(entries, sys.stdout, 'fasta')
