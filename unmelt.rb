#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'

par = Arginine::parse do
  desc "group data fields in adjacent fields by the first (id) field"
  opt :separator, short: "F", default: "\t"
  argf
end

line = ARGF.gets.chomp
last_id = line.split(par[:separator]).first
print line

ARGF.each do |line|
  line.chomp!
  fields = line.split(par[:separator])
  id = fields.shift

  if id == last_id
    print par[:separator] + fields.join(par[:separator])
  else
    print "\n" + line
    last_id = id
  end
end

print "\n"
