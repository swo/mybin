#!/usr/bin/env python3
#
# author: Scott Olesen <swo@mit.edu>

import argparse, subprocess, time
import curses

class Timer:
    def reset(self):
        self.time = time.time()

    def elapsed(self):
        return time.time() - self.time

    @staticmethod
    def pretty_elapsed_seconds(seconds):
        if seconds <= 1:
            return "now"
        elif 1 < seconds < 60:
            return "{} seconds ago".format(seconds)
        elif 60 <= seconds < 3600:
            return "{} minutes, {} seconds ago".format(seconds / 60, seconds % 60)

    def pretty_elapsed(self):
        seconds = int(round(self.elapsed()))
        return self.pretty_elapsed_seconds(seconds)

def current_display_time():
    return time.strftime('%H:%M:%S', time.localtime())

def key_loop(stdscr, sleep, command, show_time):
    stdscr.clear()
    stdscr.nodelay(1)
    curses.curs_set(0)

    stdscr_y, stdscr_x = stdscr.getmaxyx()

    refresh_watch = Timer()
    refresh_watch.reset()
    check = True
    previous_output = ""

    status_watch = Timer()
    status_watch.reset()

    while(1):
        c = stdscr.getch()
        if c in range(256):
            if chr(c).lower() == 'q':
                break

        if check:
            output = subprocess.check_output(command, shell=True)

            # only get the lines that will fit on the screen
            output = "\n".join(output.split("\n")[-stdscr_y: -1])

            if output != previous_output:
                stdscr.erase()
                stdscr.addstr(0, 0, output.rstrip())
                stdscr.refresh()
                previous_output = output

                status_watch.reset()

            check = False

        if show_time:
            out = display_time() + "\tlast update: " + status_watch.pretty_elapsed()
            stdscr.addstr(stdscr_y - 1, 0, out)

        if refresh_watch.elapsed() > sleep:
            check = True
            refresh_watch.reset()

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
