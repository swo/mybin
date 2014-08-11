#!/usr/bin/env ruby

require 'optparse'

usage = <<END
Usage: get_lines_by_index.rb index_file target_file [options]
Finds lines in target that have a first field that matches lines from the index file
END

options = {:record_separator => "\t", :offset => 0, :included_words => []}
OptionParser.new do |opts|
    opts.banner = usage

    opts.on("-F", "--separator [SEPARATOR]", "Specify record separator (default tab)") { |rs| options[:record_separator] = rs }
    opts.on("-i", "--include [WORDS]", "Comma-separated list of indices to include (default nothing)") { |words| options[:included_words] = words.split(',') }
end.parse!

raise RuntimeError, 'script takes two arguments' unless ARGV.length == 2

index_fn = ARGV.shift

indices = File.open(index_fn).readlines.map(&:chomp)
indices.concat(options[:included_words])

ARGF.each do |line|
  puts line if indices.include? line.split(options[:record_separator]).first
end
