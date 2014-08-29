#!/usr/bin/env ruby
#
# author:: scott w olesen <swo@mit.edu>
#
# search one file for some lines. if you find a match to the word, print the line from the
# other file

require 'optparse'

options = {}
OptionParser.new do |opt|
  opt.banner = "usage: #{File.basename(__FILE__)} query data target"
end.parse!

query = ARGV.shift
data_fn = ARGV.shift
target_fn = ARGV.shift

File.open(data_fn).zip(File.open(target_fn)) do |data_line, target_line|
	puts target_line if data_line.match(query)
end