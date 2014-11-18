#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'
require 'bibtex'

params = Arginine::parse do |a|
  desc "find bibtex entries in bib2 not in bib1"
  arg :bib1
  arg :bib2
end

bib1 = BibTeX.open(params[:bib1])
bib2 = BibTeX.open(params[:bib2])
bib_out = BibTeX::Bibliography.new

bib2.each_entry do |entry|
  bib_out << entry unless bib1.key? entry.key
end

puts bib_out.to_s
