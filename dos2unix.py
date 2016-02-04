#!/usr/bin/env python3
#
# author: scott olesen <swo@mit.edu>

import argparse, fileinput, sys, io, os, shutil

if __name__ == '__main__':
    p = argparse.ArgumentParser(description="replace \r with \n", formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    p.add_argument('-i', '--in-place', help="do replacement in place?")
    p.add_argument('files', nargs='*')
    args = p.parse_args()

    if args.in_place is None:
        for chunk in fileinput.input(args.files, mode='rb', bufsize=io.DEFAULT_BUFFER_SIZE):
            sys.stdout.buffer.write(chunk.replace(b"\r", b"\n"))
    else:
        # check that the input and output files exist
        if not os.path.isfile(args.in_place):
            raise RuntimeError("file {} not found".format(args.in_place))

        new_fn = args.in_place + ".bak"
        if os.path.isfile(new_fn):
            raise RuntimeError("backup location {} is not empty".format(new_fn))

        # move the file to the backup location
        shutil.move(args.in_place, new_fn)

        with open(new_fn, 'rb') as inf, open(args.in_place, 'wb') as outf:
            for chunk in inf:
                outf.write(chunk.replace(b"\r", b"\n"))
