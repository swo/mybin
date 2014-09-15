#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'

params = Arginine::parse do
  desc "get the last field from every line"
  opt "separator", :short => "F", :default => "\t"
  flag "lines", :short => "n", :desc => "show line number?"
  argf
end

ARGF.each do |line|
  field = line.chomp.split(params["separator"]).last
  if params["lines"]
    puts "#{$.}:#{field}"
  else
    puts field
  end
end