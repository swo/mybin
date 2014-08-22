#!/usr/bin/env ruby

# This program lists how many jobs each user has submitted.
#
# Author:: Scott Olesen

require 'optparse'

def summarize_column(qstat_output, name, i)
  entries = qstat_output.split("\n").drop(2).map { |line| line.split[i] }
  uniqs = entries.uniq
  counts = uniqs.map { |x| entries.count(x) }
  dat = uniqs.zip(counts)
  puts name
  puts "-"*name.length
  dat.sort_by { |u, c| c }.reverse.each { |u, c| puts "#{u}: #{c}" }
  puts
end

OptionParser.new do |opts|
  opts.banner = ["usage: qcount.rb", "summarize the output of qstat by user and stats"].join("\n")
end.parse!

raw = `qstat`
summarize_column(raw, "users", 2)
summarize_column(raw, "status", 4)
