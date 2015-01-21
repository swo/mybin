#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'

params = Arginine::parse do
  desc "sum values in a row"
  flag :header, desc: "ignore header?"
  flag :index, desc: "ignore first field in row?"
  flag :table, desc: "equivalent to -h -i"
  argf
end

if params[:table]
  params[:header] = true
  params[:index] = true
end

ARGF.each do |line|
  if params[:header] and $. == 1
    puts line
  else
    fields = line.split
    index = fields.shift if params[:index]
    sum = fields.map(&:to_i).reduce(&:+)

    if params[:index]
      puts "#{index}\t#{sum}"
    else
      puts sum
    end
  end
end
