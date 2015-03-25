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

def display_time(last_update=None):
    out = time.strftime('%H:%M:%S', time.localtime())

    if last_update is not None:
        out += "\tlast change: " + last_update

    return out

def key_loop(stdscr, sleep, commands, show_time):
    stdscr.clear()
    stdscr.nodelay(1)
    curses.curs_set(0)

    stdscr_y, stdscr_x = stdscr.getmaxyx()

    watch = Timer()
    watch.reset()
    check = True
    previous_output = ""

    if show_time:
        last_update = display_time()
    else:
        last_update = None

    while(1):
        c = stdscr.getch()
        if c in range(256):
            if chr(c).lower() == 'q':
                break

        if show_time:
            stdscr.addstr(stdscr_y - 1, 0, display_time(last_update))

        if check:
            output = subprocess.check_output(commands)

            # only get the lines that will fit on the screen
            output = "\n".join(output.split("\n")[-stdscr_y: -1])

            if output != previous_output:
                stdscr.erase()
                stdscr.addstr(0, 0, output.rstrip())
                stdscr.refresh()
                previous_output = output

                if show_time:
                    last_update = display_time()

            check = False

        if watch.elapsed() > sleep:
            check = True
            watch.reset()

        curses.napms(50)


if __name__ == '__main__':
    p = argparse.ArgumentParser(description="continously check a command's output")
    p.add_argument('command', type=str, help="command whose output to check")
    p.add_argument('-s', '--sleep', type=float, default=2.0, help="sleep for how many seconds between refresh?")
    p.add_argument('-t', '--time', action='store_true', help="show the time?")
    args = p.parse_args()

    commands = args.command.split()

    def main(stdscr):
        key_loop(stdscr, sleep=args.sleep, commands=commands, show_time=args.time)

    curses.wrapper(main)
