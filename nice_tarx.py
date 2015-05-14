#!/usr/bin/env python
#
# author: scott olesen <swo@mit.edu>

import argparse, os.path, os, re, subprocess

if __name__ == '__main__':
    p = argparse.ArgumentParser(description="make a tmp folder and extract the tar", formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    p.add_argument('tar')
    p.add_argument('--dir', '-d', help='specify dir name?', dest='direc')
    p.add_argument('--command', '-c', help='tar command', default='gnutar')
    args = p.parse_args()

    # check that the tar pointed to exists
    if not os.path.exists(args.tar):
        raise RuntimeError("file {} not found".format(args.tar))

    # get the directory name
    if args.direc is None:
        tar_base = os.path.basename(args.tar)
        stripped_tar = re.sub("\.tar$", "", re.sub("\.(gz|bz2)$", "", tar_base))
        direc = "tmp_{}".format(stripped_tar)
    else:
        direc = args.direc

    # make the directory; it's ok if it exists already
    os.makedirs(direc, exist_ok=True)

    # move the tar into the new directory
    tar_dest = os.path.join(direc, args.tar)
    os.rename(args.tar, tar_dest)

    # unpack that tar
    commands = [args.command, 'xvaf', tar_dest, '-C', direc]
    print(" ".join(commands))
    subprocess.call(commands)
