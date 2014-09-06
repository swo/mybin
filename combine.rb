#!/usr/bin/env ruby

# Author:: Scott W Olesen (swo@mit.edu)

require 'arginine'

params = Arginine.parse do
  desc "combines two files columnwise. output has length of first file."
  opt :separator, :short => "F", :default => "\t"
  arg :fn1
  arg :fn2
end

open(params[:fn1]).each_line.zip(open(params[:fn2]).each_line) do |l1, l2|
  # if the second file has ended, just put in a blank instead
  l2 ||= ''
  puts "#{l1.chomp}#{params[:separator]}#{l2.chomp}"
end
