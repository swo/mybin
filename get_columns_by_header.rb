#!/usr/bin/env ruby

# This program reads one file for a list of headers and picks out the corresponding columns
# in the other file.

require 'optparse'

options = {:record_separator => "\t"}
OptionParser.new do |opts|
    opts.banner = "Usage: get_columns_by_header.rb HEADERS_FILE TARGET_FILE [options]"

    opts.on("-F", "--separator [SEPARATOR]", "Specify record separator (default tab)") { |rs|
        options[:record_separator] = rs
    }
end.parse!

headers_fn, target_fn = ARGV

# grab the headers
headers = File.readlines(headers_fn).map(&:chomp)

# open the header, keeping track of the single set of indices for this whole file
File.open(target_fn, 'r') do |target_f; idx|
    target_f.each do |line|
        fields = line.chomp.split(options[:record_separator])
        
        if $. == 1 then
            # if it's the first line, look for the important indices
            idx = headers.map { |header| fields.index(header) }
        else
            # otherwise, grab the values!
            puts idx.map { |i| fields[i] }.join(options[:record_separator])
        end
    end
end
