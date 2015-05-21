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

    return vals[0]

def drop_first_page(input_fn, output_fn):
    # check how many pages are in the file
    n = number_of_pages(input_fn)
    pages_to_keep = "2-{}".format(n)

    subprocess.call(['pdftk', input_fn, 'cat', pages_to_keep, 'output', output_fn])


if __name__ == '__main__':
    p = argparse.ArgumentParser(description='drop the first page of a pdf using pdftk')
    p.add_argument('input')
    p.add_argument('output')
    args = p.parse_args()

    drop_first_page(args.input, args.output)
