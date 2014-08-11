#!/usr/bin/env ruby

'''
Extract sample labels from an otu table
'''

require 'optparse'

options = {:record_separator => "\t"}
OptionParser.new do |opts|
    opts.banner = "Usage: otu_table_to_samples.rb [options] FILE"

    opts.on("-F", "--separator [SEPARATOR]", "Specify record separator (default: tab)") { |rs| options[:record_separator] = rs }
end.parse!

ARGF.each do |line|
    unless line.strip.start_with? '#'
        fields = line.split

        # check on the first field
        id_field = fields.shift
        fail unless ['otu id', 'otu_id', 'sequence'].include? id_field.downcase

        # check on the last field
        fields.pop if ['lineage', 'consensus', 'taxonomy'].include? fields.last.downcase

        puts fields
        exit
    end
end
