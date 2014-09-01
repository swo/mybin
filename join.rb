#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'

params = Arginine::parse do |a|
  a.desc "join lines into a single line"
  a.opt "joiner", :short => "F", :default => ","
end

ARGF.each do |line|
  print params["joiner"] unless $. == 1
  print line.strip
end