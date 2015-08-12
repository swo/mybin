#!/usr/bin/env python
#
# author: scott olesen <swo@mit.edu>

import argparse, fileinput, warnings

def execute_script(script, space):
    # split up the script into individual actions
    actions = script.split(';')

    if len(actions) == 1:
        return perl_eval(actions[0], space)
    else:
        final_action = actions.pop()
        for action in actions:
            exec(action, space)

        return perl_eval(final_action, space)

def perl_eval(action, space):
    res = eval(action, space)
    if callable(res):
        return res(space['_'])
    else:
        return res

if __name__ == '__main__':
    p = argparse.ArgumentParser(description="execute a one(ish)-liner", formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    p.add_argument('script', help='use "_" for this line, "F" for fields')
    p.add_argument('--delimiter', '-F', default='\t')
    p.add_argument('--no_print', '-n', action='store_true')
    p.add_argument('--no_strip', '-s', action='store_true')
    p.add_argument('--re', '-r', action='store_true', help='import regex module?')
    p.add_argument('--verbose', '-v', action='store_true', help='give explicit warnings?')
    p.add_argument('input', nargs='*')
    args = p.parse_args()

    if args.re:
        from re import *

    space = globals()
    for line in fileinput.input(args.input):
        if args.no_strip:
            _ = line
        else:
            _ = line.rstrip()

        F = _.split(args.delimiter)
        space.update({'_': _, 'F': F, 'lineno': fileinput.lineno()})

        output = execute_script(args.script, space)

        if not args.no_print:
            if output is None:
                if args.verbose:
                    warnings.warn("output from command was None; suppressing eval output", stacklevel=2)

                # suppress further output
                args.no_print = True
            else:
                print(output)
