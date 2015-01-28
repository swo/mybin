#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'
require 'bio'

params = Arginine::parse do
  desc <<-EOF
  look through sequences, comparing to the first one.
  name each sequence by the mismatches
  from the master seq.
  EOF
  argf "fasta"
end

fasta = Bio::FlatFile.auto(ARGF)
master = fasta.next_entry
puts "#{master.definition} = WT"

fasta.each_entry do |e|
  out = ""
  e.naseq.chomp.each_char.zip(master.naseq.chomp.each_char).each_with_index do |chars, i|
    if chars.first.nil?
      out += "#{i}ins{chars.last} "
    elsif chars.last.nil?
      out += "#{i}del#{chars.first} "
    else
      out += "#{i}#{chars.first}>#{chars.last} " if chars.first != chars.last
	end
  end

  out = "WT" if out == ""
  puts "#{e.definition} = #{out}"
end
