#!/usr/bin/env python3
#
# author: scott olesen <swo@mit.edu>

import argparse, os, re, sys

if __name__ == '__main__':
    p = argparse.ArgumentParser(description='rename many files using a substitution pattern', formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    p.add_argument('pattern', help='python regex')
    p.add_argument('repl', help='replacement string')
    p.add_argument('files', nargs='+', help='files to rename')
    p.add_argument('--force', '-f', action='store_true', help='skip confirmation?')
    args = p.parse_args()

    new_fns = [re.sub(args.pattern, args.repl, fn) for fn in args.files]
    for fn, new_fn in zip(args.files, new_fns):
        if fn == new_fn:
            print('  ', fn, ': no change')
        else:
            print('  ', fn, '->', new_fn)

    if not args.force:
        proceed = input('proceed with renaming? [y/N] ').lower()
        if proceed not in ['y', 'yes']:
            print('  not renaming')
            sys.exit(0)

    for fn, new_fn in zip(args.files, new_fns):
        if fn != new_fn:
            os.rename(fn, new_fn)
            print('  renamed', fn, '->', new_fn)
