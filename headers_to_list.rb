#!/usr/bin/env ruby

require 'optparse'

options = {:record_separator => "\t"}
OptionParser.new do |opts|
    opts.banner = "Usage: headers_to_list.rb [options] INPUT\nRead the first line of a delimited file, then output those fields newline-separated"
    opts.on("-F", "--separator [SEPARATOR]", "Specify record separator (default: tab)") { |rs| options[:record_separator] = rs }
end.parse!

puts ARGF.readline.split(options[:record_separator])
