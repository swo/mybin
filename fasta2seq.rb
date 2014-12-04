#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'
require 'bio'

params = Arginine::parse do |a|
  desc "get the fasta entry with these header(s)"
  arg :headers, :desc => "comma-separated list or filename"
  opt :separator, :short => "F", :default => ","
  flag :table, :desc => "does the header file have a header line?"
  argf "fasta"
end

headers = []
if File.exists? params[:headers]
  headers = open(params[:headers]).each_line.collect { |line| line.split.first }
  headers.shift if params[:table]
else
  headers = params[:headers].split(params[:separator])
end

Bio::FlatFile.auto(ARGF).each_entry do |e|
  puts e.entry if headers.include? e.definition
end
