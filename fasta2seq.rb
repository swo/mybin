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
  flag :quiet, :desc => "ignore error warnings?"
  argf "fasta"
end

headers = []
if File.exists? params[:headers]
  headers = open(params[:headers]).each_line.collect { |line| line.split.first }
  headers.shift if params[:table]
else
  headers = params[:headers].split(params[:separator])
end

# get all the entries
entries = {}
Bio::FlatFile.auto(ARGF).each_entry do |e|
  label = e.definition.match(/^[^;]+/)[0]
  entries[label] = e.entry if headers.include? label
  break if entries.size == headers.size
end

# unless the quiet flag is on, complain about missing entries
unless params[:quiet]
  if entries.size < headers.size
    puts "could not find entries:"
    puts headers.reject { |h| entries.include? h }
    puts
  end
end

# return the entries in order
headers.each { |h| puts entries[h] if entries.key? h }
