#!/usr/bin/env python

# author:: scott olesen (swo@mit.edu)

import argparse, csv

def get_table_data(fh, separator):
    reader = csv.DictReader(f, delimiter=separator)
    index_name = reader.fieldnames[0]
    column_names = reader.fieldnames[1:]

    table_data = {}
    for row in reader:
        row_name = row[index_name]
        table_data[row_name] = {c: row[c] for c in column_names}

    return column_names, table_data

def show_table(column_names, data, index_name, separator, missing_value):
    # show the header
    out = separator.join([index_name] + column_names) + "\n"

    for row_name in data:
        out += separator.join([row_name] + [data[row_name].get(c, missing_value) for c in column_names]) + "\n"

    return out


if __name__ == '__main__':
    p = argparse.ArgumentParser(description="merge two delimited tables", formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    p.add_argument('--separator', '-F', default="\t")
    p.add_argument('--missing_value', '-m', default="0")
    p.add_argument('--index_name', '-i', default='index')
    p.add_argument('tables', nargs='+')
    args = p.parse_args()

    output_column_names = []
    data = {}
    for table in args.tables:
        with open(table) as f:
            column_names, table_data = get_table_data(f, args.separator)
        
        # check that the new column names don't hit any of the old
        bad_names = [c for c in column_names if c in output_column_names]
        if len(bad_names) > 0:
            raise RuntimeError("columns {} specified in more than one table".format(bad_names))

        output_column_names += column_names

        for row_name in table_data:
            if row_name in data:
                data[row_name].update(table_data[row_name])
            else:
                data[row_name] = table_data[row_name]

    print(show_table(output_column_names, data, args.index_name, args.separator, args.missing_value))