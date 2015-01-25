#!/usr/bin/env ruby

# author:: scott w olesen (swo@mit.edu)

require 'arginine'
require 'set'

params = Arginine::parse do 
  opt :separator, :short => "F", :default => "\t"
  arg :pattern
  flag :include, :desc => "include headers in output?"
  flag :one, :short => "1", :desc => "include first header?"
  flag :table, desc: "equivalent to -1 -i"
  argf
end

if params[:table]
  params[:one] = true
  params[:include] = true
end

idx = []
ARGF.lineno = 0
ARGF.each do |line|
  fields = line.chomp.split(params[:separator])
  if $. == 1
    headers = fields.select { |f| f.match(params[:pattern]) }
    raise "no headers match pattern" if headers.empty?
    
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
