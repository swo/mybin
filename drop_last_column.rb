#!/usr/bin/env ruby

require 'optparse'

options = {:record_separator => "\t"}
OptionParser.new do |opts|
    opts.banner = "Usage: drop_column.rb FILE [options]"

    opts.on("-F", "--separator [SEPARATOR]", "Specify record separator (default tab)") { |rs|
        options[:record_separator] = rs
    }
end.parse!

ARGF.each do |line|
    fields = line.split(options[:record_separator])
    fields.pop

    puts fields.join(options[:record_separator])
end
