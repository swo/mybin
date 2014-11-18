#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'
require 'bio'

params = Arginine::parse do |a|
  desc "get the fasta entry with these header(s)"
  arg :headers
  opt :separator, :short => "F", :default => ","
  argf "fasta"
end

params[:headers] = params[:headers].split(params[:separator])

Bio::FlatFile.auto(ARGF).each_entry do |e|
  puts e.entry if params[:headers].include? e.definition
end