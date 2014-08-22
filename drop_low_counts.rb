#!/usr/bin/env ruby

require 'optparse'

options = {:record_separator => "\t", :header => false, :index => false, :min_counts => 1}
OptionParser.new do |opts|
  opts.banner = "Usage: drop_zeros.rb [options] FILE"

  opts.on("-F", "--separator [SEPARATOR]", "Specify record separator (default tab)") { |rs| options[:record_separator] = rs }
  opts.on("-r", "--header", "Ignore the first/header line (default: off)") { |h| options[:header] = h }
  opts.on("-i", "--index", "Ignore the first/index column (default: off)") { |i| options[:index] = i }
  opts.on("-t", "--table", "Work on a table, equivalent to -r -i (default: off)") do |t|
    options[:header] = t
    options[:index] = t
  end
  opts.on("-c", "--min_counts [counts]", "minimium number of counts (default: 1)") { |c| options[:min_counts] = c.to_i }
end.parse!

ARGF.each do |line|
  fields = line.strip.split(options[:record_separator])

  if $. == 1 and options[:header]
    puts line
  else
    fields.shift if options[:index]
    counts = fields.inject(0) { |sum, field| sum + field.to_i }
    puts line if counts > options[:min_counts]
  end
end
