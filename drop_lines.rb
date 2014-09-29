#!/usr/bin/env ruby

# Author:: Scott W Olesen (swo@mit.edu)

require 'arginine'

params = Arginine.parse do
  desc "drops first N lines from a file"
  opt :drop, :short => "N", :default => 1, :cast => :to_i
  argf
end

ARGF.each { |line| puts line.chomp if $. > params[:drop] }
