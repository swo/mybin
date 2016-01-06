#!/usr/bin/env python3
#
# author: scott olesen <swo@mit.edu>

import argparse, os.path, os, re, subprocess, tempfile, re, shutil

if __name__ == '__main__':
    p = argparse.ArgumentParser(description="move files to a tmp folder with the same name before making the tar", formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    p.add_argument('tar')
    p.add_argument('files', nargs='+')
    p.add_argument('--dir', '-d', help='specify dir name?', dest='direc')
    p.add_argument('--command', '-c', help='tar command', default='tar')
    p.add_argument('--verbose', '-v', action='store_true')
    args = p.parse_args()

    # get the base name of the directory from the tar name,
    # unless the --dir option was specific
    if args.direc is None:
        m = re.search("^(.*)\.(tar\.gz|tar\.bz2|tgz)", args.tar)

        if m is None:
            raise RuntimeError("could not infer directory name from tar name '{}'".format(args.tar))

        args.direc = m.groups()[0]

    # open a temporary directory to make the tar in
    with tempfile.TemporaryDirectory() as tmp_dir:
        if args.verbose:
            print("made temporary directory:", tmp_dir)

        # make a subfolder 
        subdir = os.path.join(tmp_dir, args.direc)
        os.mkdir(subdir)

        if args.verbose:
            print("made temporary subdirectory:", subdir)

        # prepare the name of the tar that will be made there
        tmp_tar_fn = os.path.join(tmp_dir, args.tar)

        # copy all the files to that subdir
        for f in args.files:
            x = shutil.copy2(f, subdir)

            if args.verbose:
                print("copied", f, "to", x)

        # make relative names for the new files
        new_target_fns = [os.path.join(args.direc, f) for f in args.files]

        if args.verbose:
            print("relative member names:", *new_target_fns)

        # make a tar
        command = [args.command, 'cvaf', tmp_tar_fn, '-C', tmp_dir] + new_target_fns

        if args.verbose:
            print("executing:", *command, sep=" ")

        subprocess.call(command)

        # move that tar back here
        shutil.move(tmp_tar_fn, os.getcwd())
