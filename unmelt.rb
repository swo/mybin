#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'

par = Arginine::parse do
  desc "group data fields by the first (id) field"
  opt :separator, short: "F", default: "\t"
  argf
end

ids = []
values = Hash.new { |h, k| h[k] = [] }

ARGF.each do |line|
  fields = line.chomp.split(par[:separator])
  id = fields.shift
  ids << id unless ids.include? id
  values[id] += fields
end

ids.each do |id|
  puts ([id] + values[id].sort).join(par[:separator])
end
