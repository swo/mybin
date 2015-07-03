#!/usr/bin/env python
#
# author: scott olesen <swo@mit.edu>

import argparse, fileinput, itertools

def down_to(l):
    '''[1,2,3] becomes [[1], [1,2], [1,2,3]]'''
    return [l[0: i] for i in range(1, len(l) + 1)]

class Lineage():
    standard_ranks = ['domain', 'phylum', 'class', 'order', 'family', 'genus']
    down_to_standard_ranks = down_to(standard_ranks)[1:]
    pretty_dtsr = ["2".join([l[0], l[-1]]) for l in down_to_standard_ranks]

    def __init__(self, assignments, conf=None):
        self.assignments = assignments

        if conf is not None:
            self.conf = conf
            self.assignments = list(itertools.takewhile(lambda x: x[2] >= conf, self.assignments))

        self._taxa_map = {x[1]: x[0] for x in assignments} # e.g., domain => Bacteria
        self.standard_taxa = [self._taxa_map.get(rank, "NA") for rank in self.standard_ranks]
        self.down_to_standard_taxa = self._get_down_to_standard_taxa()
        self.pretty_dtst = [";".join(l) for l in self.down_to_standard_taxa]

    def _get_down_to_standard_taxa(self):
        # drop trailing NAs
        nonna_taxa = list(reversed(list(itertools.dropwhile(lambda x: x == "NA", reversed(self.standard_taxa))))) 

        # replace internal NAs with _, make downto craziness
        out = down_to(["_" if t == "NA" else t for t in nonna_taxa])

        # append enough copies to fill out the end 
        out += out[-1] * (len(self.standard_taxa) - len(out))

        # drop the first one, which is just domain
        out.pop(0)

        return out


def parse_line(line):
    fields = line.rstrip().translate({ord('"'): None}).split("\t")
    entry_id = fields[0].split(";")[0]
    assignments = [[x, y, float(z)] for [x, y, z] in zip(*[iter(fields[2:])] * 3)]
    
    return entry_id, assignments


if __name__ == '__main__':
    p = argparse.ArgumentParser(description="turn RDP fixrank into tabbed format", formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    p.add_argument('--min_confidence', '-m', metavar='CONF', type=float, default=0.8)
    p.add_argument('input', nargs='*', metavar='FILE')
    args = p.parse_args()

    headers = ['id'] + Lineage.standard_ranks + Lineage.pretty_dtsr
    print(*headers, sep="\t")

    for line in fileinput.input(args.input):
        entry_id, assignments = parse_line(line)
        lineage = Lineage(assignments, conf=args.min_confidence)

        out_fields = [entry_id] + lineage.standard_taxa + lineage.pretty_dtst
        print(*out_fields, sep="\t")
