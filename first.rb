#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'

params = Arginine::parse do |a|
  a.desc "get the first field from every line"
  a.opt "separator", :short => "F", :default => "\t"
end

ARGF.each { |line| puts line.split(params["separator"]).first }