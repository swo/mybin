#!/usr/bin/env ruby

# This program combines two files column-wise.

require 'optparse'

options = {:record_separator => "\t"}
OptionParser.new do |opts|
    opts.banner = "Usage: combine.rb FILE1 FILE2 [options]"

    opts.on("-F", "--separator [SEPARATOR]", "Specify record separator (default tab)") { |rs|
        options[:record_separator] = rs
    }
end.parse!

fn1, fn2 = ARGV

File.open(fn1, 'r') { |f1|
    File.open(fn2, 'r') { |f2|
        e1 = f1.to_enum
        e2 = f2.to_enum

        loop do
            l1 = e1.next.chomp
            l2 = e2.next.chomp
            puts [l1, l2].join(options[:record_separator])
        end
    }
}
