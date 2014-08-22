#!/usr/bin/env ruby

require 'optparse'

options = {:record_separator => "\t"}
OptionParser.new do |opts|
    opts.banner = "Usage: sum_all_reads.rb [options] FILE"

    opts.on("-F", "--separator [SEPARATOR]", "Specify record separator (default tab)") { |rs| options[:record_separator] = rs }
end.parse!

total = ARGF.readlines.inject(0) do |sum, line|
  fields = line.split(options[:record_separator])
  id = fields.shift
  fields.map!(&:to_i)

  if id.match(/OTU(_| )ID/) 
    sum
  else
    this = fields.inject(0) { |line_sum, value| line_sum + value }
    sum + this
  end
end

puts total
