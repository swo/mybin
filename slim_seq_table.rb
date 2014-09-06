#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>
#
# leave off the sequence at the beginning of each line. replace it with seq1, seq2, etc.

require 'arginine'

params = Arginine::parse do 
  desc "replace actual sequences with seq\#"
  argf "seq table"
end

ARGF.each do |line|
  if $. == 1
    puts line.strip
  else
    puts line.strip.sub(/[A-Z]+/, "seq#{$. - 1}")
  end
end
