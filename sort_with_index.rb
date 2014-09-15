#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'

params = Arginine::parse do |a|
  a.desc "sort entries numerically, also showing index"
  a.opt "separator", :short => "F", :default => ":", :desc => "output separator"
  a.opt "offset", :default => 1, :cast => :to_i, :desc => "like, 1 to get line no; 2 if there's a header"
  a.opt "n", :default => 10, :cast => :to_i
  a.flag "header", :short => "d", :desc => "skip header line?"
end

ARGF.readline if params["header"]
entries = ARGF.each_with_index.map { |line, i| [line.to_f, i + params["offset"]] }
puts entries.sort.reverse.first(params["n"]).map { |e| "#{e.last}:#{e.first}" }