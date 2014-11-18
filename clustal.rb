#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'
require 'tempfile'

params = Arginine::parse do |a|
  desc "align sequences with clustal"
  opt :size, :desc => "fraction of screen width", :cast => :to_f, :default => 0.80
  flag :align_only, :desc => "show only alignment?"
  argf "fasta"
end

raise RuntimeError unless params[:size] > 0.0

if ARGV.length == 1
  # just run clustalo on this one file
  params[:fasta] = ARGV.first
else
  # concatenate the ARGF into a tmp file
  params[:file] = Tempfile.new("clustalo")
  params[:file].write(ARGF.read)
  params[:file].close
  params[:fasta] = params[:file].path
end

# get the width of the terminal and the number of output columns
n_cols = `tput cols`
out_cols = (n_cols.to_f * params[:size]).floor

# get results from clustalo. drop the first banner line and empty lines.
lines = `clustalo --outfmt=clu --wrap=#{out_cols} -i #{params[:fasta]}`.split("\n")

while lines.first.empty? or lines.first.match("CLUSTAL") 
  lines.shift 
end

# if showing only the alignment
if params[:align_only]
  # get the chunks that are separated by blank lines
  align_groups = lines.chunk { |line| line != "" || nil }.map(&:last)

  # figure out how many characters to chop from the start of each line
  # search backward to find how many non-whitespace chars to keep
  s = align_groups.first.first
  start_i = s.length - s.reverse.match(/\S*/)[0].length

  aligns = align_groups.map { |g| g.last[start_i..-1] }
  puts aligns.join("\n")
else
  puts lines.join("\n")
end

# clean up the temporary file
params[:file].unlink if params.key? :file