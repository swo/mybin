#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'
require 'bio'

$par = Arginine::parse do |a|
  desc "get the fasta entries that match a pattern"
  arg :pattern
  flag :inverse, short: "v", desc: "get entries that don't match instead"
  argf "fasta"
end

def entry_match(entry)
  found = entry.definition.gsub(/;.*/, '').match($par[:pattern])
  found = (not found) if $par[:inverse]
  return found
end

Bio::FlatFile.auto(ARGF).each_entry do |e|
  puts e if entry_match(e)
end
