#!/usr/bin/env ruby

# Author:: Scott W Olesen (swo@mit.edu)

require 'arginine'

params = Arginine.parse do
  desc "drops first N lines from a file"
  opt :n, :default => 1, :cast => :to_i
  argf
end

1.upto(params[:n]).each { |i| ARGF.gets }
ARGF.each_line { |line| puts line.chomp }