#!/usr/bin/env python
#
# author: Scott Olesen <swo@mit.edu>

import argparse, subprocess, time
import curses

class Timer:
    def reset(self):
        self.time = time.time()

    def elapsed(self):
        return time.time() - self.time


def key_loop(stdscr, sleep, commands):
    stdscr.clear()
    stdscr.nodelay(1)
    curses.curs_set(0)

    previous_output = ""

    watch = Timer()
    watch.reset()
    check = True

    while(1):
        c = stdscr.getch()
        if c in range(256):
            if chr(c).lower() == 'q':
                break

        if check:
            output = subprocess.check_output(commands)

            if output != previous_output:
                stdscr.erase()
                stdscr.addstr(0, 0, output.rstrip())
                stdscr.refresh()
                previous_output = output

            check = False

        if watch.elapsed() > sleep:
            check = True
            watch.reset()

        curses.napms(50)


if __name__ == '__main__':
    p = argparse.ArgumentParser(help="continously check a command's output")
    p.add_argument('command', type=str, help="command whose output to check")
    p.add_argument('-s', '--sleep', type=float, default=2.0, help="sleep for how many seconds between refresh?")
    args = p.parse_args()

    commands = args.command.split()

    def main(stdscr):
        key_loop(stdscr, sleep=args.sleep, commands=commands)

    curses.wrapper(main)