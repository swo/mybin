#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'

par = Arginine::parse do
  desc "get specific positions along each line"
  arg :start, cast: :to_i
  arg :end, cast: :to_i
  opt :index, cast: :to_i, default: 1, desc: "index of first position?"
  argf "lines to be searched"
end

range = (par[:start] - par[:index])..(par[:end] - par[:index])
ARGF.each { |l| puts l[range] }
