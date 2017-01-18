#!/usr/bin/env python3
#
# author: scott olesen <swo@mit.edu>

import argparse, subprocess

apps = {'photoshop': '/Applications/Adobe Photoshop CC 2015.5/Adobe Photoshop CC 2015.5.app',
        'illustrator': '/Applications/Adobe Illustrator CC 2015.3/Adobe Illustrator.app',
        'word': '/Applications/Microsoft Word.app',
        'excel': '/Applications/Microsoft Excel.app',
        'vlc': '/Applications/VLC.app',
        'affinity': '/Applications/Affinity Designer.app'
        }

def prefix_for(prefix):
    keys = list(apps.keys())
    matching_keys = [key for key in keys if key.startswith(prefix)]

    if len(matching_keys) == 0:
        raise RuntimeError("prefix '{}' doesn't match any of {}".format(prefix, keys))
    elif len(matching_keys) > 1:
        raise RuntimeError("prefix '{}' matches multiple keys: {}".format(prefix, matching_keys))
    elif len(matching_keys) == 1:
        return matching_keys[0]
    else:
        raise RuntimeError

if __name__ == '__main__':
    p = argparse.ArgumentParser(description="", formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    p.add_argument('app', help='any (prefix) of: {}'.format(', '.join(apps.keys())))
    p.add_argument('file')
    args = p.parse_args()

    key = prefix_for(args.app)
    subprocess.run(['open', '-a', apps[key], args.file])
