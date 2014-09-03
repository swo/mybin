#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'

params = Arginine::parse do |a|
  a.desc "get lines according to list"
  a.opt "offset", :short => "o", :default => 0, :cast => :to_i, :desc => "like, how many header lines?"
  a.flag "numbers", :desc => "show line numbers?"
  a.arg "lines", :cast => lambda { |x| x.split(",").map(&:to_i) }
end

lines = {}
targets = params["lines"].map { |x| x + params["offset"] }
ARGF.each do |line|
  # store this line if it's a target
  lines[$.] = line.strip if targets.include? $.

  # print out the targets if we have them in order
  while lines.key? targets.first
    if params["numbers"]
      n = targets.first - params["offset"]
      out = "#{n}:#{lines.delete(targets.shift)}"
    else
      out = lines.delete(targets.shift)
    end
    puts out
  end

  # stop looping if we are done
  break if targets.empty?
end