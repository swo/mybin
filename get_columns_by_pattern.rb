#!/usr/bin/env ruby

# author:: scott w olesen (swo@mit.edu)

require 'arginine'

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

fields = ARGF.gets.chomp.split(params[:separator])
headers = fields.select { |f| f.match(params[:pattern]) }
raise "no headers match pattern" if headers.empty?
idx = headers.map { |header| fields.index(header) }

if params[:one]
  idx.unshift 0
  headers.unshift fields.first
end

puts headers.join(params[:separator]) if params[:include]

ARGF.each do |line|
  begin
    fields = line.chomp.split(params[:separator])
    puts fields.values_at(*idx).join(params[:separator])
  rescue Errno::EPIPE
    exit
  end
end