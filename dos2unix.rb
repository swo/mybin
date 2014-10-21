#!/usr/bin/env ruby

# author:: scott w olesen <swo@mit.edu>

require 'arginine'
require 'iconv'

params = Arginine.parse do
  desc "convert carriage returns to newline"
  argf
end

ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')

ARGF.each do |line| 
  valid_line = ic.iconv(line)
  puts valid_line.tr("\r", "\n") 
end

