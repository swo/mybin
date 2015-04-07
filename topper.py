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

def display_time():
    return time.strftime('%H:%M:%S', time.localtime())

def key_loop(stdscr, sleep, command, show_time):
    stdscr.clear()
    stdscr.nodelay(1)
    curses.curs_set(0)

    stdscr_y, stdscr_x = stdscr.getmaxyx()

    watch = Timer()
    watch.reset()
    check = True
    previous_output = ""

    last_update = display_time()

    while(1):
        c = stdscr.getch()
        if c in range(256):
            if chr(c).lower() == 'q':
                break

        now = display_time()

        if check:
            output = subprocess.check_output(command, shell=True)

            # only get the lines that will fit on the screen
            output = "\n".join(output.split("\n")[-stdscr_y: -1])

            if output != previous_output:
                stdscr.erase()
                stdscr.addstr(0, 0, output.rstrip())
                stdscr.refresh()
                previous_output = output

                last_update = now

            check = False

        if show_time:
            if last_update == now:
                out = now + "\tlast update: now"
            else:
                out = now + "\tlast update: {}".format(last_update)

            stdscr.addstr(stdscr_y - 1, 0, out)

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

    def main(stdscr):
        key_loop(stdscr, sleep=args.sleep, command=args.command, show_time=args.time)

    curses.wrapper(main)
