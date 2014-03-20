#!/usr/bin/env ruby

require 'optparse'

options = {:record_separator => "\t", :offset => 0}
OptionParser.new do |opts|
    opts.banner = "Usage: get_lines_by_file.rb LINES_FILE TARGET_FILE [options]"

    opts.on("-F", "--separator [SEPARATOR]", "Specify record separator (default tab)") { |rs| options[:record_separator] = rs }
    opts.on("-l", "--lines", "Use line numbers rather than 0-start indices") { options[:offset] = -1 }
    opts.on("-i", "--print-index", "Print the index of the output line") { options[:show_index] = true }
    opts.on("-p", "--print-line", "Print the line number of the output line") { options[:show_line] = true }
end.parse!

raise RuntimeError, 'script takes two arguments' unless ARGV.length == 2

lines_fn, target_fn = ARGV

line_numbers = File.open(lines_fn).readlines.map(&:to_i)
target_lines = File.open(target_fn).readlines.map(&:chomp)

line_numbers.each.with_index do |line_number, i|
  print "#{i}: " if options[:show_index] 
  print "#{line_number}: " if options[:show_line]
  puts "#{target_lines[line_number + options[:offset]]}"
end
