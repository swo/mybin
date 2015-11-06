#!/usr/bin/env python
#
# author: scott olesen <swo@mit.edu>

import argparse, subprocess, json, os.path

if __name__ == '__main__':
    p = argparse.ArgumentParser(description="", formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    p.add_argument('fasta', help='input fasta')
    p.add_argument('output', help='output tab-delimited file')
    p.add_argument('--format', '-f', choices=['fixrank', 'allrank'], default='fixrank', help='output format')
    p.add_argument('--config', '-c', default='.rdpconfig.json', help='config file')
    p.add_argument('--jar', '-j', metavar='/path/to/classifier.jar', help='path to RDP classifier jar')
    p.add_argument('--java', '-x', metavar='/path/to/java', help='java binary')
    p.add_argument('--verbose', '-v', action='store_true', help='show commands being executed?')
    args = p.parse_args()

    if args.jar or args.java:
        if not (args.jar and args.java):
            raise RuntimeError("if specifying --jar or --java, then need to specify both")
    else:
        # read in the json file
        path = os.path.dirname(os.path.realpath(__file__))
        config_fn = os.path.join(path, args.config)
        with open(config_fn) as f:
            config = json.load(f)

        args.jar = config['jar']
        args.java = config['java']

    cmd = [args.java, '-Xmx1g', '-jar', args.jar, 'classify', '-o', args.output, args.fasta]

    if args.verbose:
        print(" ".join(cmd))

    subprocess.check_call(cmd)
