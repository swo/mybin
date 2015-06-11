#!/usr/bin/env python
#
# author: scott olesen <swo@mit.edu>

import argparse, os.path, os, re, subprocess

if __name__ == '__main__':
    p = argparse.ArgumentParser(description="make a tmp folder and extract the zip", formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    p.add_argument('zip')
    p.add_argument('--dir', '-d', help='specify dir name?', dest='direc')
    args = p.parse_args()

    # check that the zip pointed to exists
    if not os.path.exists(args.zip):
        raise RuntimeError("file {} not found".format(args.zip))

    # get the directory name
    if args.direc is None:
        zip_base = os.path.basename(args.zip)
        stripped = re.sub(" ", "_", re.sub("\.zip$", "", zip_base))
        direc = "tmp_{}".format(stripped)
    else:
        direc = args.direc

    # make the directory; it's ok if it exists already
    os.makedirs(direc, exist_ok=True)

    # move the tar into the new directory
    dest = os.path.join(direc, args.zip)
    os.rename(args.zip, dest)

    # unzip
    commands = ['unzip', dest, '-d', direc]
    print(" ".join(commands))
    subprocess.call(commands)
