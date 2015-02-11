#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'

params = Arginine::parse do
  desc "join lines into a single line"
  opt :joiner, short: "F", default: ","
end

puts ARGF.each.to_a.map(&:strip).join(params[:joiner])