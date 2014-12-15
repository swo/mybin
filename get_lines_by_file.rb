#!/usr/bin/env ruby
#
# author: scott w olesen (swo@mit.edu)

require 'arginine'

params = Arginine::parse do
  desc "if X is in db file, print line X in target file"
  opt :offset, desc: "offset lines in target file?", cast: :to_i, default: 0
  flag :numbers, desc: "print line numbers?"
  arg :db
  arg :target
end

idx0 = open(params[:db]).readlines.map(&:to_i)
idx = idx0.map { |x| x - params[:offset] }

open(params[:target]).each_with_index do |line, i|
  if idx.include? i
    if params[:numbers]
      puts "#{i}\t#{line.chomp}"
    else
      puts line
    end
  end
end