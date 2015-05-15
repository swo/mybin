#!/usr/bin/env python
#
# author: scott olesen <swo@mit.edu>

import argparse, fileinput, sys, io

if __name__ == '__main__':
    p = argparse.ArgumentParser(description="replace \r with \n", formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    p.add_argument('files', nargs='*')
    args = p.parse_args()

    for chunk in fileinput.input(args.files, mode='rb', bufsize=io.DEFAULT_BUFFER_SIZE):
        sys.stdout.buffer.write(chunk.replace(b"\r", b"\n"))
