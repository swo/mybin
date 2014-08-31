#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>
#
# convert a list of newline separated sequences into a fasta

require 'optparse'

options = {:name => "seq"}
OptionParser.new do |opt|
  opt.banner = "usage: #{File.basename(__FILE__)}"

  opt.on("-n", "--name [name]", "name for sequence (e.g., >name1; default name)") { |name| options[:name] = name }
end.parse!

ARGF.each_with_index { |line, i| puts [">#{options[:name]}#{i}", line.strip] }