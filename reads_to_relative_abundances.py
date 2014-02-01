#!/usr/bin/env python

import survey.process as sp, survey.output as so
import numpy as np
import fileinput

sample_ids, otu_ids, table, metadata = sp.parse_otu_table(fileinput.input(), count_map_f=float)

# convert all the columns to relative abundances
n_cols = table.shape[1]
for i in range(n_cols):
    table[:, i] /= np.sum(table[:, i])

# write out the table
so.write_otu_table(sample_ids, otu_ids, table, metadata)
