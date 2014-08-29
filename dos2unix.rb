#!/usr/bin/env ruby

# author:: scott w olesen <swo@mit.edu>

require 'optparse'

OptionParser.new do |opts|
    opts.banner = ["usage: dos2unix.rb _file_", "convert carriage returns to newline"].join("\n")
end.parse!

ARGF.each { |line| puts line.tr("\r", "\n") }
