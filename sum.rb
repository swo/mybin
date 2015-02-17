#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'

par = Arginine::parse do
  desc "sum lines"
  opt :cast, default: "i", desc: "i=integer, f=float"
end

raise RuntimeError, "cast type #{par[:cast]} not recognized" unless %w{i f}.include? par[:cast]

par[:cast] = "to_#{par[:cast]}".to_sym

puts ARGF.inject(0) { |sum, line| sum += line.send(par[:cast]) }
