#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'

par = Arginine::parse do
  desc "only keep rows whose sum is at least some minimum"
  arg :min, cast: :to_f
  opt :separator, short: "F", desc: "field separator", default: "\t"
  flag :header, desc: "ignore header?"
  flag :index, desc: "ignore first field in row?"
  flag :table, desc: "equivalent to -h -i"
  argf
end

if par[:table]
  par[:header] = true
  par[:index] = true
end

puts ARGF.gets if par[:header]
ARGF.each do |line|
  line.chomp!
  fields = line.split(par[:separator])
  fields.shift if par[:index]
  sum = fields.map(&:to_f).reduce(&:+)

  puts line unless sum < par[:min]
end
