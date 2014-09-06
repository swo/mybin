#!/usr/bin/env ruby

# author:: scott w olesen <swo@mit.edu>

require 'arginine'

params = Arginine.parse do
  desc "convert carriage returns to newline"
  argf
end

ARGF.each { |line| puts line.tr("\r", "\n") }
