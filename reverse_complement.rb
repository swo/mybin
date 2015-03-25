#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'
require 'bio'

par = Arginine::parse do |a|
  desc "reverse complement the entries"
  argf "fasta"
end

Bio::FlatFile.auto(ARGF).each_entry do |e|
  puts ">#{e.definition}"
  puts Bio::Sequence::NA.new(e.seq).complement.to_s.upcase
end
