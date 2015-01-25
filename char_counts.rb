#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'

params = Arginine::parse do
  desc "count chars"
  argf
end

dat = Hash.new(0)
ARGF.each_char { |c| dat[c] += 1 }
dat = dat.to_a.map(&:reverse).sort.reverse 
dat.each { |c, n| puts "#{c}:\t#{n}" }
puts "---"
puts "total: #{dat.map(&:first).reduce(&:+)}"
