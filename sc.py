#!/usr/bin/env python
#
# author: scott olesen <swo@mit.edu>

import argparse, subprocess

if __name__ == '__main__':
    p = argparse.ArgumentParser(description="pipes a delimited file (or stdin) into sc", formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    p.add_argument('files', nargs='*')
    p.add_argument('--delimiter', '-F', default='\t')
    args = p.parse_args()

    cmd = '''cat {} | psc -k -d '{}' | sc'''.format(" ".join(args.files), args.delimiter)
    subprocess.call(cmd, shell=True)
