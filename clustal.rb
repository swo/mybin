#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'
require 'tempfile'

params = Arginine::parse do |a|
  desc "align sequences with clustal"
  flag :align_only, :desc => "show only alignment?"
  argf "fasta"
end

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

# find the length of the longest name, or 27 (whichever is smallest)
long_name = `grep ">" #{params[:fasta]}`.split("\n").map(&:chomp).map(&:length).max
long_name = [long_name, 27].min
name_block_length = long_name + 6

# get the width of the terminal and the number of output columns
# for proper spacing, subtract the length of the longest name and spaces (6)
out_cols = `tput cols`.to_i - name_block_length

# get results from clustalo. drop the first banner line and empty lines.
lines = `clustalo --outfmt=clu --wrap=#{out_cols} -i #{params[:fasta]}`.split("\n")

while lines.first.empty? or lines.first.match("CLUSTAL") 
  lines.shift 
end

# if showing only the alignment
if params[:align_only]
  # get the chunks that are separated by blank lines
  align_groups = lines.chunk { |line| line != "" || nil }.map(&:last)

  # chop off the name block, then tie them together
  alignment = align_groups.map { |g| g.last[(name_block_length - 1)..-1] }.join("")
  puts "~" + alignment + "~"
else
  puts lines.join("\n")
end

# clean up the temporary file
params[:file].unlink if params.key? :file
