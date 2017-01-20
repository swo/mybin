#!/usr/bin/env python3
#
# author: scott olesen <swo@mit.edu>

import argparse, subprocess, os

if __name__ == '__main__':
    p = argparse.ArgumentParser(description='render a Rmd file', formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    p.add_argument('input', help='Rmd')
    p.add_argument('--output_format', '-o', default='pdf', choices=['pdf', 'html', 'word', 'docx'])
    p.add_argument('--verbose', '-v', action='store_true', help='show Rscript command?')
    args = p.parse_args()

    output_format_opts = {'pdf': 'pdf_document', 'html': 'html_document', 'word': 'word_document', 'docx': 'word_document'}
    output_format = output_format_opts[args.output_format]

    if args.verbose:
        print(cmd)

    cmd = " ".join(['Rscript', '-e', '"rmarkdown::render(\'{}\', output_format=\'{}\')"'.format(args.input, output_format)])
    os.system(cmd)
