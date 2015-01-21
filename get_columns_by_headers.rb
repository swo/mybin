#!/usr/bin/env ruby

# author:: scott w olesen (swo@mit.edu)

require 'arginine'
require 'set'

params = Arginine::parse do
  opt :separator, :short => "F", :default => "\t"
  opt :words, :desc => "comma-separated column headers", :cast => lambda { |s| s.split(",") }
  opt :file, :desc => "newline-separated column headers"
  flag :include, :desc => "include headers in output?"
  flag :one, :short => "1", :desc => "include first header?"
  argf
end

raise RuntimeError, "need -w or -f" if [:words, :file].all? { |o| params[o].nil? }

# read in headers
unless params[:words].nil?
  headers = params[:words]
else
  headers = open(params[:file]).readlines.map(&:chomp)
end

idx = []
ARGF.lineno = 0
ARGF.each do |line|
  fields = line.chomp.split(params[:separator])
  if $. == 1
    # if it's the first line, look for the important indices
    # first check that they exist!
    missing = headers.to_set - fields.to_set
    raise RuntimeError, "not all headers found, missing #{missing.to_a}" unless missing.empty?
    
    idx = headers.map { |header| fields.index(header) }

    if params[:one]
      idx.unshift 0
      headers.unshift fields.first
    end

    puts headers.join(params[:separator]) if params[:include]
  else
    puts fields.values_at(*idx).join(params[:separator])
  end
end
