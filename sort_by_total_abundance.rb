#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>
#
# This script reads an OTU table that has a final lineage column. It sorts all the rows
# based on the sum of all the entries in that row.

header = ''
lines = []
ARGF.each do |line|
  if $. == 1
    # this is the header line, just save it
    header = line.chomp
  else
    # for other lines, store the sum of the numeric fields
    fields = line.split
    otu_id = fields.shift
    tax = fields.pop
    sum = fields.map(&:to_f).inject { |s, x| s + x }

    # only keep the line if it's nonzero
    lines << [sum, line] if sum > 0
  end
end

# print out the lines in order
puts header
puts lines.sort { |a, b| b.first <=> a.first }.map(&:last)
