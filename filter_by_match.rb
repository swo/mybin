#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'

params = Arginine::parse do |a|
  desc "get lines that have no more than N instances of a pattern"
  arg :n, :cast => :to_i
  arg :pattern, :cast => lambda { |p| p.tr("'\"", "") }
  argf
end

ARGF.each do |line|
  puts line unless line.scan(params[:pattern]).length > params[:n]
end
