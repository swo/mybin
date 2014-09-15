#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'

params = Arginine::parse do |a|
  desc "align sequences with clustal"
  opt :size, :desc => "fraction of screen width", :cast => :to_f, :default => 0.80
  arg :fasta
end

raise RuntimeError unless params[:size].between?(0.0, 1.0)

# get the width of the terminal and the number of output columns
n_cols = `tput cols`
out_cols = (n_cols.to_f * params[:size]).floor

# get results from clustalo. drop the first banner line and empty lines.
lines = `clustalo --outfmt=clu --wrap=#{out_cols} -i #{params[:fasta]}`.split("\n")

while lines.first.empty? or lines.first.match("CLUSTAL") 
  lines.shift 
end

puts lines.join("\n")
