#!/usr/bin/env python3
#
# author: scott olesen <swo@mit.edu>

import argparse, os, os.path, hashlib, fnmatch

blocksize = 65536

def hash_file(fn):
    with open(fn, 'rb') as f:
        hasher = hashlib.md5()
        buf = f.read(blocksize)
        while len(buf) > 0:
            hasher.update(buf)
            buf = f.read(blocksize)

    return hasher.hexdigest()

def hash_files(d, ignore=[]):
    fns = os.listdir(d)

    for ig in ignore:
        fns = [fn for fn in fns if not fnmatch.fnmatch(fn, ig)]

    paths = [os.path.join(d, fn) for fn in fns]

    # make the hash, filtering out directories (not "isfile")
    return {fn: hash_file(path) for fn, path in zip(fns, paths) if os.path.isfile(path)}


if __name__ == '__main__':
    p = argparse.ArgumentParser(description="find which files in two directories are identical", formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    p.add_argument('dir1')
    p.add_argument('dir2')
    p.add_argument('--ignore', '-i', nargs='+', metavar='P', help='ignore some glob pattern(s). probably need to quote them.')
    args = p.parse_args()

    h1 = hash_files(args.dir1, ignore=args.ignore)
    h2 = hash_files(args.dir2, ignore=args.ignore)

    common_fn = set(h1.keys()) & set(h2.keys())
    matched = [fn for fn in common_fn if h1[fn] == h2[fn]]
    unmatched = [fn for fn in common_fn if fn not in matched]
    not_common = set(h1.keys()) ^ set(h2.keys())

    if len(matched) > 0:
        print("matched:")
        print(*matched, sep="\n")
        print()

    if len(unmatched) > 0:
        print("unmatched:")
        print(*unmatched, sep="\n")
        print()

    if len(not_common) > 0:
        print("files not in common:")
        print(*not_common, sep="\n")
