#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'
require 'bio'

par = Arginine::parse do
  desc "return sequences grouped by length"
  argf "fasta"
end

lengths = Hash.new { |h, k| h[k] = [] }
Bio::FlatFile.foreach(ARGF) do |entry|
  seq = entry.data.strip
  lengths[seq.length] << seq
end

lengths.keys.reject(&:zero?).sort.reverse.each do |len|
  puts len
  puts lengths[len].sort
  puts
end
