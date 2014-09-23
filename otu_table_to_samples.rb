#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>
#

require 'arginine'

params = Arginine::parse do
    desc "extract sample names from an otu table"
    argf
end

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
