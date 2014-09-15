#!/usr/bin/env ruby

# author:: scott w olesen (swo@mit.edu)

require 'arginine'

params = Arginine::parse do |a|
  a.opt "separator", :short => "F", :default => "\t"
  a.arg "column", :desc => "column header"
end

idx = nil
ARGF.each do |line|
  fields = line.chomp.split(params["separator"])
  if $. == 1
    idx = fields.index(params["column"])
    raise "column #{params['column']} not found" if idx.nil?
  else
    puts fields[idx]
  end
end