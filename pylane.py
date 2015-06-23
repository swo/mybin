#!/usr/bin/env python
#
# author: scott olesen <swo@mit.edu>

import argparse, fileinput

def execute_script(script, space):
    # split up the script into individual actions
    actions = script.split(';')

    if len(actions) == 1:
        return eval(actions[0], space)
    else:
        final_action = actions.pop()
        for action in actions:
            exec(action, space)

        return eval(final_action, space)

if __name__ == '__main__':
    p = argparse.ArgumentParser(description="", formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    p.add_argument('script')
    p.add_argument('--delimiter', '-F', default='\t')
    p.add_argument('--no_print', '-n', action='store_true')
    p.add_argument('--no_strip', '-s', action='store_true')
    p.add_argument('input', nargs='*')
    args = p.parse_args()

    for line in fileinput.input(args.input):
        if args.no_strip:
            _ = line
        else:
            _ = line.rstrip()

        F = _.split(args.delimiter)

        output = execute_script(args.script, {'_': _, 'F': F})

        if not args.no_print:
            print(output)
