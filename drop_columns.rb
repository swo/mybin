#!/usr/bin/env ruby
#
# This script drops columns from a delimited file. Specifying just one index drops just that
# column. Specifying two indices drops between and including those indices. Negative indices
# are allowed.

require 'arginine'

params = Arginine::parse do
  desc "drop columns in the specified range"
  opt :separator, :short => "F", :default => "\t"
  flag :negative, :desc => "count from end of # columns?"
  arg :start, :cast => :to_i
  opt :end, :cast => :to_i
  argf
end

# set the end to the start if not specified
params[:end] = params[:start] unless params.key? :end

if params[:negative] then
  params[:start] *= -1
  params[:end] *= -1
end

ARGF.each do |line|
    fields = line.split(params[:separator])
    fields.slice!(params[:start]..params[:end])
    puts fields.join(params[:separator])
end
