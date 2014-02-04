#!/usr/bin/env ruby

# This program transposes a rectangular table. No ragged edges.

require 'optparse'

options = {:record_separator => "\t"}
OptionParser.new do |opts|
    opts.banner = "Usage: transpose.rb FILE [options]"

    opts.on("-F", "--separator [SEPARATOR]", "Specify record separator (default tab)") { |rs|
        options[:record_separator] = rs
    }
end.parse!

table = []
ARGF.each do |line|
  fields = line.split(options[:record_separator])

  if $. == 1 then
    fields.each { |field| table << [field] }
  else
    fields.each_with_index { |field, i| table[i] << field }
  end
end

table.each { |row| puts row.join(options[:record_separator]) }
