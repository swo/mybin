#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'
require 'bio'

par = Arginine::parse do |a|
  desc "get the fasta entries that match a pattern"
  arg :pattern
  argf "fasta"
end

Bio::FlatFile.auto(ARGF).each_entry do |e|
  puts e if e.definition.gsub(/;.*/, '').match(par[:pattern])
end
