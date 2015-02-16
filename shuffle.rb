#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'

par = Arginine::parse do
  desc "shuffle lines"
  argf
end

lines = ARGF.readlines
puts lines.shuffle