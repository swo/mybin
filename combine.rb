#!/usr/bin/env ruby

# This program combines two files column-wise. The length of the output is equal to the length
# of the first file.

require 'arginine'

params = Arginine.parse do |a|
  a.opt "separator", :short => "F", :default => "\t"
  a.arg "fn1"
  a.arg "fn2"
end

File.open(params["fn1"]).each_line.zip(File.open(params["fn2"]).each_line) do |l1, l2|
  # if the second file has ended, just put in a blank instead
  l2 ||= ''
  puts "#{l1.chomp}#{options[:record_separator]}#{l2.chomp}"
end
