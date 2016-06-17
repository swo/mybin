#!/usr/bin/env python3
#
# author: scott olesen <swo@mit.edu>

import argparse, os.path, os, sys, glob

if __name__ == '__main__':
    p = argparse.ArgumentParser(description="'smart' pandoc: a wrapper with some intelligent defaults")
    p.add_argument('input', nargs='?', help='markdown file (leave blank and spandoc will use the only markdown file in this directory)')
    p.add_argument('--to', '-t', default='pdf', choices=['pdf', 'docx'], help='output format')
    p.add_argument('--verbose', '-v', action='store_true', help='print pandoc command?')
    p.add_argument('--force', '-f', action='store_true', help='overwrite existing file?')
    args = p.parse_args()

    # if there is no input, then see if there is one .md in the path
    if args.input is None:
        possible_mds = glob.glob(os.path.join(os.getcwd(), '*.md')) + glob.glob(os.path.join(os.getcwd(), '*.markdown'))
        if len(possible_mds) == 1:
            args.input = possible_mds[0]
        elif len(possible_mds) == 0:
            print("no markdown file found in this directory; specify one")
            sys.exit(1)
        elif len(possible_mds) > 1:
            print("multiple markdown files in this directory; specify one")
            sys.exit(1)

    # check that this is a markdown file
    root, ext = os.path.splitext(args.input)
    assert ext in ['.md', '.markdown']

    # figure out pandoc "to" type based on the extension
    if args.to == 'pdf':
        pandoc_to = 'latex'
    else:
        pandoc_to = args.to

    new_path = root + '.' + args.to

    if not args.force and os.path.isfile(new_path):
        resp = input("file '{}' already exists. overwite? [y/N] ".format(new_path))
        if resp.lower() not in ['y', 'yes']:
            print("not overwriting")
            sys.exit(0)

    command = "pandoc --to {} -o {} {}".format(pandoc_to, new_path, args.input)

    if args.verbose:
        print(command)

    os.system(command)
