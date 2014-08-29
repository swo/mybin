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
    params[:i].value.each do |line|
      puts line.strip if params[:lines].values.first.include? $.
    end
  end
end
