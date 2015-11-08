#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'

def whitespace_translation(x)
    case x
    when " "
        "<space>"
    when "\t"
        "<tab>"
    when "\n"
        "<newline>"
    else
        x
    end
end

params = Arginine::parse do
  desc "count chars"
  argf
end

dat = Hash.new(0)
ARGF.each_char { |c| dat[c] += 1 }
dat = dat.to_a.map(&:reverse).sort.reverse.map { |c, n| [c, whitespace_translation(n)] }
dat.each { |c, n| puts "#{c}:\t#{n}" }
puts "---"
puts "total: #{dat.map(&:first).reduce(&:+)}"
