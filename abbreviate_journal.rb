#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'

params = Arginine::parse do
  desc "look up the NLM abbreviation of a journal title"
  arg :title
end

# convert spaces to +
title = params[:title].gsub(/ /, "+")

puts title

# make up the url for lookup
url = "http://www.ncbi.nlm.nih.gov/nlmcatalog/?term=#{title}&report=Journal&format=text"

puts "search url: " + url

# lookup and split into lines
lines = `curl -A "Mozilla/5.0" --silent "#{url}"`.split("\n")

puts lines

# find lines that match the NLM abbrev tag
lines.each do |line|
  m = line.match(/^NLM Title Abbreviation: (.*)/)
  puts m[1] unless m.nil?
end
