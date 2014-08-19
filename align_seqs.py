#!/usr/bin/env python

'''
author : scott olesen <swo@mit.edu>
'''

import argparse, subprocess, tempfile, os

def align(A, B):
    # create a temporary fasta file
    s = "\n".join(['>A', A, '>B', B]) + "\n"
    fh, fn = tempfile.mkstemp()
    os.write(fh, s)

    # feed that into clustalo
    o = subprocess.check_output(['clustalo', '-i', fn, '--outfmt=clu'])
    return o

if __name__ == '__main__':
    p = argparse.ArgumentParser(description='align two sequences using clustalo')
    p.add_argument('A', help='one sequence')
    p.add_argument('B', help='other sequence')
    args = p.parse_args()

    print align(args.A, args.B)
