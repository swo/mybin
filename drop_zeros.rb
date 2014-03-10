#!/usr/bin/env ruby

require 'optparse'

options = {:record_separator => "\t", :header => false, :index => false}
OptionParser.new do |opts|
  opts.banner = "Usage: drop_zeros.rb [options] FILE"

  opts.on("-F", "--separator [SEPARATOR]", "Specify record separator (default tab)") { |rs| options[:record_separator] = rs }
  opts.on("-r", "--header", "Ignore the first/header line (default: off)") { |h| options[:header] = h }
  opts.on("-i", "--index", "Ignore the first/index column (default: off)") { |i| options[:index] = i }
  opts.on("-t", "--table", "Work on a table, equivalent to -r -i (default: off)") do |t| 
    options[:header] = t
    options[:index] = t
  end
end.parse!

ARGF.each do |line|
  fields = line.strip.split(options[:record_separator])

  if $. == 1 and options[:header]
    puts line
    next
  end

  fields.slice!(0) if options[:index]
  puts line unless fields.all? { |x| x == '0' }
end
