#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'

params = Arginine::parse do
  desc "sum values in a column"
  flag :header, desc: "ignore header?"
  flag :index, desc: "ignore first field in row?"
  flag :table, desc: "equivalent to -h -i"
  argf
end

if params[:table]
  params[:header] = true
  params[:index] = true
end

headers = ARGF.gets.split if params[:header]
sums = ARGF.gets.split.map(&:to_i)

if params[:index]
  headers.shift
  sums.shift
end

ARGF.each do |line|
  vals = line.split.map(&:to_i)
  vals.shift if params[:index]
  vals.each_with_index { |x, i| sums[i] += x }
end

if params[:header]
  puts headers.zip(sums).map { |x| x.join("\t") }
else
  puts sums
end
