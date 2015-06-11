#!/usr/bin/env python

# author: Scott Olesen <swo@mit.edu>

import argparse, re, subprocess

def number_of_pages(fn):
    data = subprocess.check_output(['pdftk', fn, 'dump_data', 'output', '-'])
    lines = data.decode().split("\n")
    matches = [re.match('NumberOfPages: (\d+)', l) for l in lines]
    vals = [m.group(1) for m in matches if not m is None]

    if len(vals) != 1:
        raise RuntimeError("error parsing data dump")

    return int(vals[0])

def drop_first_pages(input_fn, output_fn, n):
    # check how many pages are in the file
    total_n = number_of_pages(input_fn)

    if not n < total_n:
        raise RuntimeError("can't drop {} pages from a pdf with only {} pages".format(n, n_total))

    pages_to_keep = "{}-{}".format(n + 1, total_n)

    subprocess.call(['pdftk', input_fn, 'cat', pages_to_keep, 'output', output_fn])


if __name__ == '__main__':
    p = argparse.ArgumentParser(description='drop the first page(s) of a pdf using pdftk', formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    p.add_argument('input')
    p.add_argument('output')
    p.add_argument('-n', type=int, default=1, help='number of pages to drop')
    args = p.parse_args()

    drop_first_pages(args.input, args.output, args.n)
