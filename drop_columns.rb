#!/usr/bin/env ruby
#
# This script drops columns from a delimited file. Specifying just one index drops just that
# column. Specifying two indices drops between and including those indices. Negative indices
# are allowed.

require 'optparse'

options = {:record_separator => "\t", :negative => false}
OptionParser.new do |opts|
    opts.banner = "Usage: drop_columns.rb [options] START_INDEX END_INDEX FILE"

    opts.on("-F", "--separator [SEPARATOR]", "Specify record separator (default tab)") { |rs| options[:record_separator] = rs }
    opts.on("-n", "--negative", "Count from the back of the fields (default: false") { |n| options[:negative] = n }
end.parse!

start_index = ARGV.shift.to_i
end_index = ARGV.shift.to_i

if options[:negative] then
  start_index = -start_index
  end_index = -end_index
end

dropped_indices = start_index..end_index

ARGF.each do |line|
    fields = line.split(options[:record_separator])
    fields.slice!(dropped_indices)
    puts fields.join(options[:record_separator])
end
