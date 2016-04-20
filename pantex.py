#!/usr/bin/env python3
#
# author: scott olesen <swo@mit.edu>

import argparse, os.path, os, sys

if __name__ == '__main__':
    p = argparse.ArgumentParser(description="", formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    p.add_argument('input')
    args = p.parse_args()

    # check that this is a markdown file
    root, ext = os.path.splitext(args.input)
    assert ext in ['.md', '.markdown']

    new_path = root + '.pdf'

    command = "pandoc --to latex -o {} {}".format(new_path, args.input)
    os.system(command)
