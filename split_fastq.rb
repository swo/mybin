#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'
require 'fileutils'

params = Arginine::parse do
  desc "split a fastq into n parts"
  arg :n, cast: :to_i
  arg :fastq
end

# figure out if this is a fastq by looking at the first character
raise "file not a fastq" unless open(params[:fastq], &:readline)[0] == "@"

# get the number of entries and lines per entry
nl = `wc -l #{params[:fastq]}`.split.first.to_i
raise "incomplete entries" unless nl % 4 == 0
lpc = ((nl / 4).to_f / params[:n]).ceil * 4

# number of chars to put after the output filenames
nd = params[:n] / 26 + 1

system "split -a #{nd} -l #{lpc} #{params[:fastq]} #{params[:fastq]}."

# move the created files to where they are expected
Dir.glob("#{params[:fastq]}.*").each_with_index do |fn, i|
  FileUtils.move fn, fn.sub(/(?<=\.)[a-z]+$/, i.to_s)
end
