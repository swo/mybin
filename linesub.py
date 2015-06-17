#!/usr/bin/env python
#
# author: scott olesen <swo@mit.edu>

import argparse, fileinput, re

if __name__ == '__main__':
    p = argparse.ArgumentParser(description="replace a line if it matches a pattern", formatter_class=argparse.ArgumentDefaultsHelpFormatter, epilog='the patterns are searched in the order given')
    p.add_argument('--separator', '-F', default='/', help='separator in pattern/replacement items', metavar='SEP')
    p.add_argument('pattern/replacement', metavar='P/R', nargs='+', help='if line matches P, replace the whole line with R')
    p.add_argument('input', nargs='?', help='a list of files, or empty to use stdin')
    args = vars(p.parse_args())

    # parse the patterns and replacements
    prs = []
    inputs = []
    while args['pattern/replacement']:
        word = args['pattern/replacement'].pop(0)
        parts = word.split(args['separator'])

        if len(parts) == 2:
            prs.append(parts)
        elif len(parts) == 1:
            # put the rest of the arguments into inputs
            inputs = [word] + args['pattern/replacement']
            break
        else:
            raise RuntimeError("command-line argument '{}' splits into {} pieces".format(word, len(parts)))
            

    def replaced_line(line):
        for pattern, replacement in prs:
            if re.search(pattern, line) is not None:
                return replacement

        return line

    for line in fileinput.input(inputs):
        print(replaced_line(line.rstrip()))
