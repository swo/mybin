#!/usr/bin/env ruby

# author:: scott w olesen (swo@mit.edu)

require 'arginine'
require 'set'

params = Arginine::parse do 
  opt :separator, :short => "F", :default => "\t"
  opt :words, :desc => "comma-separated column headers", :cast => lambda { |s| s.split(",") }
  opt :file, :desc => "newline-separated column headers"
  opt :comment, :desc => "a comment character?", :default => "#"
  flag :include, :desc => "include headers in output?"
  flag :one, :short => "1", :desc => "include first header?"
  flag :rename, :desc => "rename headers using second field in column headers file?"
  flag :table, :desc => "equivalent to -1 -i"
  argf
end

raise RuntimeError, "need -w or -f" if [:words, :file].all? { |o| params[o].nil? }
raise RuntimeError, "-r require -f" if params[:rename] and params[:file].nil?

if params[:table]
  params[:one] = true
  params[:include] = true
end

# read in headers
unless params[:words].nil?
  headers = params[:words]
  new_headers = headers
else
  lines = open(params[:file]).readlines.map(&:chomp)
  if params[:rename]
    headers = lines.map { |l| l.split[0] }
    new_headers = lines.map { |l| l.split[1] }
  else
    headers = lines
    new_headers = headers
  end
end

# process the first line
line = ARGF.gets
line = ARGF.gets while line.strip.start_with? params[:comment]

fields = line.chomp.split(params[:separator])
missing = headers.to_set - fields.to_set
raise RuntimeError, "not all headers found, missing #{missing.to_a} amongst #{fields}" unless missing.empty?
idx = headers.map { |header| fields.index(header) }

if params[:one]
  idx.unshift 0
  new_headers.unshift fields.first
end

puts new_headers.join(params[:separator]) if params[:include]

ARGF.each do |line|
  fields = line.chomp.split(params[:separator])

  # try to write the line. if the pipe was closed, don't squawk about it.
  begin
    puts fields.values_at(*idx).join(params[:separator])
  rescue Errno::EPIPE => e
      abort
  end
end
