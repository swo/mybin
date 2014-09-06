#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'

params = Arginine::parse do
  desc "get the first field from every line"
  opt "separator", :short => "F", :default => "\t"
end

ARGF.each { |line| puts line.split(params["separator"]).first }