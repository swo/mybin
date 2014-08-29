#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>
#
# leave off the sequence at the beginning of each line. replace it with seq1, seq2, etc.

require 'optparse'

options = {}
OptionParser.new do |opt|
  opt.banner = "usage: #{File.basename(__FILE__)} seq_table"
end.parse!

ARGF.each do |line|
  if $. == 1
    puts line.strip
  else
    puts line.strip.sub(/[A-Z]+/, "seq#{$. - 1}")
  end
end
