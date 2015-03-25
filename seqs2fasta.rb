#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'

params = Arginine::parse do
  desc "convert newline-separated sequences into a fasta"
  opt :numbers, :desc => "pick your own comma-separated X,Y to make >seqX, >seqY", :default => :nil, :cast => lambda { |s| s.split(",") }
  argf "sequences"
end

if params[:numbers].nil?
  ARGF.each_with_index { |line, i| puts [">seq#{i}", line.strip] }
else
  ARGF.each do |line|
    raise RuntimeError, "ran out of numbers" if params[:numbers].empty?
    puts [">seq#{params[:numbers].shift}", line.strip]
  end
end
