#!/usr/bin/env ruby

# author:: scott w olesen (swo@mit.edu)

require 'arginine'
require 'set'

params = Arginine::parse do
  desc "get columns by index"
  opt :separator, :short => "F", :default => "\t"
  flag :whitespace, :short => "w", :help => "split on whitespace"
  arg :idx, :cast => lambda { |x| x.split(",").map(&:to_i) }, :desc => "indices of columns to be kept (comma-separated)"
  argf "lines to be searched"
end

if params[:whitespace]
  input_separator = nil
else
  input_separator = params[:separator]
end

output_separator = params[:separator]

ARGF.each do |line|
  puts line.chomp.split(input_separator).values_at(*params[:idx]).join(output_separator)
end
