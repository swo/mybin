#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>
#
# script

require 'optparse'

def write_wrapped_lines(lines, width)
  while lines.any? { |line| line.length > 0 }
    lines.each { |line| puts line.slice!(0, width) }
    puts
  end
end

options = {:width => 92}
OptionParser.new do |opt|
  opt.banner = "usage: #{File.basename(__FILE__)}"

  opt.on("-w", "--width [w]", "width of output (default: 92)") { |x| options[:wrap] = x.to_i }
end.parse!

write_wrapped_lines(ARGF.readlines, options[:width])
