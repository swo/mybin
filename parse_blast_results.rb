#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'
require 'nokogiri'

params = Arginine::parse do
  desc "parse a blast xml"
  arg :xml
  opt :hits, cast: :to_i, desc: "how many hits to show?", default: 10
end

doc = Nokogiri::XML(open(params[:xml]))

doc.root.xpath("//Iteration").each do |iter|
  # write down the query name
  puts iter.at_xpath("Iteration_query-def").text
  qlen = iter.at_xpath("Iteration_query-len").text.to_i

  # hit down each hit
  iter.at_xpath("Iteration_hits").xpath("Hit").each_with_index do |hit, i|
    break if i >= params[:hits]

    name = hit.at_xpath("Hit_def").text
    acc = hit.at_xpath("Hit_accession").text
    idlen = hit.at_xpath("Hit_hsps/Hsp/Hsp_identity").text.to_i
    id = (idlen.to_f / qlen * 100).round(2)
    puts [id, acc, name].join("\t")
  end

  # blank line
  puts
end
