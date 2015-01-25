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

# make up the url for lookup
url = "http://www.ncbi.nlm.nih.gov/nlmcatalog/?term=%22#{title}%22&report=Journal&format=text"

# lookup and split into lines
lines = `curl --silent "#{url}"`.split("\n")

# find lines that match the NLM abbrev tag
lines.each do |line|
  m = line.match(/^NLM Title Abbreviation: (.*)/)
  puts m[1] unless m.nil?
end
