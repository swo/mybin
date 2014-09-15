#!/usr/bin/env ruby

require 'arginine'

params = Arginine::parse do
  desc "find lines in a wilfe that have a first field in a list of indices"
  opt :separator, :short => "F", :default => "\t"
  opt :words, :desc => "list of words to grab"
  opt :words_separator, :default => ","
  opt :file, :desc => "file with list of words to grab"
  argf "file with lines to be grabbed"
end

raise RuntimeError, "file OR list of indices must be specified" unless params[:words].nil? ^ params[:file].nil?

if params[:file]
  indices = open(params[:file]).readlines.map(&:chomp)
elsif params[:words]
  indices = params[:words].split(params[:words_separator])
end

ARGF.each do |line|
  puts line if indices.include? line.split(params[:separator]).first
end