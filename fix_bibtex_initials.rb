#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'

params = Arginine::parse do |a|
  desc "convert a list of names into their initialized forms"
  argf
end

content = ARGF.readlines.map(&:chomp).join(" ")
words = content.split
puts words.chunk { |word| word != "and" || nil }.map { |_, names| [names.first, names.drop(1).map { |w| w[0] }.join("")].join(" ") }.join(" and ")
