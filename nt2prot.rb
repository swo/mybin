#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'
require 'Bio'

par = Arginine::parse do
  desc "translate DNA to protein"
  argf "fasta"
end

Bio::FastaFormat.foreach(ARGF) do |entry|
  aa = Bio::Sequence::AA.new(Bio::Sequence::NA.new(entry.data).translate)
  puts aa.to_fasta(entry.definition)
end
