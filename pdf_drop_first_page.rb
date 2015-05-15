#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'

par = Arginine::parse do
  desc "drop first page"
  arg :input
  arg :output
end

# get the number of pages
n = `pdftk #{par[:input]} dump_data output - | grep NumberOfPages`.split.last.to_i
`pdftk #{par[:input]} cat 2-#{n-1} output #{par[:output]}`