#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>
#
# look through sequences, comparing to the first one. name each sequence by the mismatches
# from the master seq.

require 'optparse'

options = {}
OptionParser.new do |opt|
  opt.banner = "usage: #{File.basename(__FILE__)}"
end.parse!

master = ""
ARGF.each do |line|
	master = line if $. == 1
	
	out = ""
	line.strip.each_char.zip(master.each_char).each_with_index do |chars, i|
		if chars.first.nil?
			out += "#{i}ins{chars.last} "
		elsif chars.last.nil?
			out += "#{i}del#{chars.first} "
		else
			out += "#{i}#{chars.first}>#{chars.last} " if chars.first != chars.last
		end
	end
	out = "WT" if out == ""

	puts out
end