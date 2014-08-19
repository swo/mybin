#!/usr/bin/env ruby

require 'optparse'

usage = <<END
usage: get_lines_by_index.rb index_file target_file [options]
finds lines in target that have a first field that matches lines from the index file
END

options = {:record_separator => "\t"}
OptionParser.new do |opts|
    opts.banner = usage
    opts.on("-F", "--separator [SEPARATOR]", "Specify record separator (default tab)") { |rs| options[:record_separator] = rs }
end.parse!

raise RuntimeError, 'script takes two arguments' unless ARGV.length == 2

index_fn = ARGV.shift

indices = File.open(index_fn).readlines.map(&:chomp)

ARGF.each do |line|
  puts line if indices.include? line.split(options[:record_separator]).first
end
