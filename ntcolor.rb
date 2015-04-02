#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'

par = Arginine::parse do
  desc "colorize nucleotides"
  argf "any text"
end

ARGF.each_char do |c|
  case c
  when 'A'
    print "\033[41mA\033[0m"
  when 'C'
    print "\033[42mC\033[0m"
  when 'G'
    print "\033[43mG\033[0m"
  when 'T'
    print "\033[44mT\033[0m"
  else
    print c
  end
end
