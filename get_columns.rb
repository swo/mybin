#!/usr/bin/env ruby

# author:: scott w olesen (swo@mit.edu)

require 'arginine'
require 'set'

params = Arginine::parse do
  desc "get columns by index"
  opt :separator, :short => "F", :default => "\t"
  arg :idx, :cast => lambda { |x| x.split(",").map(&:to_i) }, :desc => "indices of columns to be kept (comma-separated)"
  argf "lines to be searched"
end

ARGF.each do |line|
  puts line.chomp.split(params[:separator]).values_at(*params[:idx]).join(params[:separator])
end
