#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'main'

Main do
  description "get lines according to command line"
  argument :lines do
    desc "lines in the file to grab, comma-separated"
    cast :list_of_integer
  end
  input :i do
    desc "input file, or - for stdin"
  end
  
  def run
    lines = Hash.new
    targets = params[:lines].values.first
    params[:i].value.each do |line|
      # put this line in the hash if it's a target
      lines[$.] = line.strip if targets.include? $.

      # print out the targets if we have them in order
      while lines.key? targets.first
        puts lines.delete(targets.shift)
      end

      # stop looping if we are done with the file
      break if targets.empty?
    end
  end
end