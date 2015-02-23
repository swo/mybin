#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'
require 'csv'

par = Arginine::parse do
  desc "look up values from a table"
  arg :table
  argf "row-column pairs"
end

table = CSV.read(par[:table], col_sep: "\t", headers: true)
table.by_col!
idx = table[0]

ARGF.each do |line|
  row, col = line.split
  puts table[col][idx.index(row)]
end