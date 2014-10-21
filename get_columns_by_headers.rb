#!/usr/bin/env ruby

# author:: scott w olesen (swo@mit.edu)

require 'arginine'
require 'set'

params = Arginine::parse do |a|
  a.opt :separator, :short => "F", :default => "\t"
  a.opt :headers, :desc => "comma-separated column headers", :cast => lambda { |s| s.split(",") }
  a.opt :file, :desc => "newline-separated column headers"
end

raise RuntimeError, "need -h or -f" if [:headers, :file].all? { |o| params[o].nil? }

# read in headers
unless params[:headers].nil?
  headers = params[:headers]
else
  headers = open(params[:file]).readlines.map(&:chomp)
end

idx = []
ARGF.each do |line|
  fields = line.chomp.split(params[:separator])
  if $. == 1
    # if it's the first line, look for the important indices
    # first check that they exist!
    missing = headers.to_set - fields.to_set
    raise RuntimeError, "not all headers found, missing #{missing.to_a}" unless missing.empty?
    
    idx = headers.map { |header| fields.index(header) }
  else
    puts fields.values_at(*idx).join(params[:separator])
  end
end