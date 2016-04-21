#!/usr/bin/env python3
#
# author: scott olesen <swo@mit.edu>

import argparse, os.path, os, sys

if __name__ == '__main__':
    p = argparse.ArgumentParser(description="", formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    p.add_argument('input')
    p.add_argument('--to', '-t', default='pdf', choices=['pdf', 'docx'])
    p.add_argument('--verbose', '-v', action='store_true')
    args = p.parse_args()

    # check that this is a markdown file
    root, ext = os.path.splitext(args.input)
    assert ext in ['.md', '.markdown']

    # figure out pandoc "to" type based on the extension
    if args.to == 'pdf':
        pandoc_to = 'latex'
    else:
        pandoc_to = args.to

    new_path = root + '.' + args.to

    command = "pandoc --to {} -o {} {}".format(pandoc_to, new_path, args.input)

    if args.verbose:
        print(command)

    os.system(command)
