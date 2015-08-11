#!/usr/bin/env python3
#
# author: scott olesen <swo@mit.edu>

import argparse, glob, subprocess

if __name__ == '__main__':
    p = argparse.ArgumentParser(description="call cmd in parallel on left & right functions", formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    p.add_argument('cmd')
    p.add_argument('left')
    p.add_argument('right')
    p.add_argument('--force', '-f', action='store_true')
    args = p.parse_args()

    left_fns = glob.glob(args.left)
    right_fns = glob.glob(args.right)

    if len(left_fns) != len(right_fns):
        raise RuntimeError("unequal numbers of left and right arguments\nlefts: {}\nrights:{}".format(args.left, args.right))

    cmd_args = args.cmd.split()
    cmd = ['parallel', '--xapply'] + cmd_args + [':::'] + left_fns + [':::'] + right_fns
    print(*cmd)

    if not args.force:
        proceed = input('proceed? [y/N] ').lower()
        if proceed not in ['y', 'yes']:
            print('  cancelled')
            sys.exit(0)

    subprocess.call(cmd)
