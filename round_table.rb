#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'

par = Arginine::parse do |a|
  desc "round table entries"
  opt :digits, default: 3
  argf
end

puts ARGF.gets # write the header
ARGF.each do |line|
  fields = line.split
  id = fields.shift
  fields.map! { |x| x.to_f.round(par[:digits]) }
  puts [[id] + fields].join("\t")
end