#!/usr/bin/env ruby
#
# author: scott w olesen (swo@mit.edu)

require 'arginine'

params = Arginine::parse do
  desc "find lines in a wilfe that have a first field in a list of indices"
  opt :separator, :short => "F", :default => "\t", help: "use 'nil' for whitespace"
  opt :words, :desc => "list of words to grab"
  opt :words_separator, :default => ","
  opt :file, :desc => "file with list of words to grab"
  flag :header, short: 'd', help: 'print the first line of the input?'
  argf "file with lines to be grabbed"
end

raise RuntimeError, "file OR list of indices must be specified" unless params[:words].nil? ^ params[:file].nil?

if params[:separator] == "nil"
  params[:separator] = nil
end

if params[:file]
  indices = open(params[:file]).readlines.map(&:chomp)
elsif params[:words]
  indices = params[:words].split(params[:words_separator])
end

puts ARGF.gets if params[:header]

ARGF.each do |line|
  puts line if indices.include? line.split(params[:separator]).first
end
