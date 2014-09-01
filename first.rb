#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'main'

Main do
  description "get the first field"
  option :separator=, "F" do
    argument_required
    default "\t"
  end
  input :input
  
  def run
    input.each { |line| puts line.split(params[:separator].values.first).first }
  end
end
