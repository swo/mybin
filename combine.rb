#!/usr/bin/env ruby

# This program combines two files column-wise. The length of the output is equal to the length
# of the first file.

require 'optparse'

options = {:record_separator => "\t"}
OptionParser.new do |opts|
    opts.banner = "Usage: combine.rb FILE1 FILE2 [options]"

    opts.on("-F", "--separator [SEPARATOR]", "Specify record separator (default tab)") do |rs|
        options[:record_separator] = rs
    end
end.parse!

fn1, fn2 = ARGV

File.open(fn1, 'r') do |f1|
  File.open(fn2, 'r') do |f2|
    f1.zip(f2) do |l1, l2|
      # if the second file has ended, just put in a blank instead
      l2 ||= ''
      puts "#{l1.chomp}#{options[:record_separator]}#{l2.chomp}"
    end
  end
end
