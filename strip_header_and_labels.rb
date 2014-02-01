#!/usr/bin/env ruby

require 'optparse'

options = {:record_separator => "\t"}
OptionParser.new do |opts|
    opts.banner = "Usage: strip_header_and_labels.rb [options] FILE"

    opts.on("-F", "--separator [SEPARATOR]", "Specify record separator (default tab)") { |rs| options[:record_separator] = rs }
end.parse!

ARGF.each do |line|
    # skip the first line
    next if $. == 1

    # otherwise drop the first field and print that out
    fields = line.split(options[:record_separator])
    print fields.drop(1).join(options[:record_separator])
end
