#!/usr/bin/env python3
#
# author: scott olesen <swo@mit.edu>

import argparse, tempfile, subprocess, os.path, shutil

if __name__ == '__main__':
    p = argparse.ArgumentParser(description="diff two files after using pandoc to convert them into a new format", formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    p.add_argument("left")
    p.add_argument("right")
    p.add_argument("--to", "-t", default="markdown", help="output format")
    p.add_argument("options", nargs=argparse.REMAINDER, help="arguments to pass to diff")
    args = p.parse_args()

    # figure out places for temporary files
    tempdir = tempfile._get_default_tempdir()
    fn1 = os.path.join(tempdir, next(tempfile._get_candidate_names()))
    fn2 = os.path.join(tempdir, next(tempfile._get_candidate_names()))

    # convert the two files
    subprocess.run(["pandoc", "-t", args.to, args.left, "-o", fn1])
    subprocess.run(["pandoc", "-t", args.to, args.right, "-o", fn2])

    # actually run diff
    subprocess.run(["diff", fn1, fn2])

    # clean up temporary files
    os.remove(fn1)
    os.remove(fn2)
