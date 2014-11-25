#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'

params = Arginine::parse do
  desc "get lines according to list"
  opt "offset", :short => "o", :default => 0, :cast => :to_i, :desc => "like, how many header lines?"
  flag "numbers", :desc => "show line numbers?"
  arg "lines", :cast => lambda { |x| x.split(",").map(&:to_i) }
end

lines = {}
targets = params["lines"].map { |x| x + params["offset"] }
ARGF.each do |line|
  # store this line if it's a target
  lines[$.] = line.strip if targets.include? $.

  # print out the targets if we have them in order
  while lines.key? targets.first
    if params["numbers"]
      if params["offset"] == 0
        s = targets.first.to_s
      else
        n = targets.first - params["offset"]
        s = n.to_s
        s << sprintf("%+d", params["offset"])
      end

      out = "#{s}:#{lines.delete(targets.shift)}"
    else
      out = lines.delete(targets.shift)
    end
    puts out
  end

  # stop looping if we are done
  break if targets.empty?
end
