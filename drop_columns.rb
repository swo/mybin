#!/usr/bin/env ruby

require 'optparse'

options = {:record_separator => "\t"}
OptionParser.new do |opts|
    opts.banner = "Usage: drop_columns.rb [options] START_INDEX END_INDEX FILE"

    opts.on("-F", "--separator [SEPARATOR]", "Specify record separator (default tab)") { |rs|
        options[:record_separator] = rs
    }
end.parse!

start_index = ARGV.shift.to_i
end_index = ARGV.shift.to_i

dropped_indices = start_index..end_index

ARGF.each do |line|
    fields = line.split(options[:record_separator])
    fields = fields.each_with_index.reject { |value, i| dropped_indices.include? i }.map(&:first)

    puts fields.join(options[:record_separator])
end
