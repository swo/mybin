#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'

params = Arginine::parse do |a|
  desc "trim every line to N characters"
  arg :n, :cast => :to_i
  argf
end

ARGF.each do |line|
  puts line[0..params[:n]]
end
