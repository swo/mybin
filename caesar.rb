#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'

params = Arginine::parse do |a|
  desc "caesar's cipher"
  arg :offset, :cast => :to_i
  argf "message"
end

alph = ('a'..'z').to_a
a = alph.join
b = alph.rotate(params[:offset]).join

ARGF.each { |line| puts line.tr(a, b) }
