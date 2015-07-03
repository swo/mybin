#!/usr/bin/env python
#
# author: scott olesen <swo@mit.edu>

import argparse, re, fileinput

if __name__ == '__main__':
    p = argparse.ArgumentParser(description="replace whitespace with tabs", formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    p.add_argument('--regex', '-r', metavar='PATTERN', default='\s+', help="regex used to split line")
    p.add_argument('--in_place', '-i', metavar='EXT', nargs='?', default=False, help="edit file in place? use '.bak' if no EXT specified")
    p.add_argument('--delimiter', '-F', metavar='SEP', default="\t", help="output separator (the famous tab)")
    p.add_argument('input', nargs='*', metavar='FILE')
    args = p.parse_args()

    # in the case of "retab.py -i file", argparse thinks that "file" is the option
    # for -i, when it's actually the value for input, since when using -i, you must
    # take at least one input file
    if args.input == [] and args.in_place != False:
        args.input.append(args.in_place)
        args.in_place = None

    if args.in_place == False:
        kwargs = {}
    else:
        if args.in_place is None:
            kwargs = {'inplace': True, 'backup': '.bak'}
        else:
            kwargs = {'inplace': True, 'backup': '.' + args.in_place}

    for line in fileinput.input(args.input, **kwargs):
        fields = re.split(args.regex, line)
        new_line = args.delimiter.join(fields)
        print(new_line)
