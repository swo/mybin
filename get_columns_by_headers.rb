#!/usr/bin/env ruby

# This program reads one file for a list of headers and picks out the corresponding columns
# in the other file.

require 'optparse'
require 'set'

options = {:record_separator => "\t", :exclude_headers => false, :new_names => nil}
OptionParser.new do |opts|
    opts.banner = "Usage: get_columns_by_header.rb HEADERS_FILE TARGET_FILE [options]\nRead a newline-separated list of headers from HEADERS_FILE, then look for those headers in the delimited TARGET_FILE. Print only the columns that match the headers."
    opts.on("-F", "--separator [SEPARATOR]", "Specify record separator (default: tab)") { |rs| options[:record_separator] = rs }
    opts.on("-x", "--exclude_headers", "Do not include headers at the top of output (default: off") { |h| options[:exclude_headers] = h }
    opts.on("-n", "--new_names [file]", "Change the names of the headers to a list from a new file") { |f| options[:new_names] = f }
end.parse!

headers_fn, target_fn = ARGV

# grab the headers
headers = File.readlines(headers_fn).map(&:chomp).reject { |header| header == '' }
new_headers = File.readlines(options[:new_names]).map(&:chomp) unless options[:new_names].nil?

# write out the headers if desired
if options[:new_names]
  puts new_headers.join(options[:record_separator])
elsif options[:exclude_header]
  nil
else
  puts headers.join(options[:record_separator])
end

# open the header, keeping track of the single set of indices for this whole file
idx = Array.new
File.open(target_fn, 'r') do |target_f|
    target_f.each do |line|
        fields = line.chomp.split(options[:record_separator])
        
        if $. == 1 then
          # if it's the first line, look for the important indices
          # first check that they exist!
          missing = headers.to_set - fields.to_set
          raise RuntimeError, "not all headers found, missing #{missing.to_a}" unless missing.empty?
          idx = headers.map { |header| fields.index(header) }
        else
            # otherwise, grab the values!
            puts idx.map { |i| fields[i] }.join(options[:record_separator])
        end
    end
end
