#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'
require 'fileutils'
require 'tempfile'

params = Arginine::parse do |a|
  desc "replace whitespace"
  opt :joiner, :short => "F", :default => "\t"
  opt :in_place, :desc => "edit following file in place"
  argf
end

if params[:in_place]
  tf = Tempfile.new("retab")
  open(params[:in_place]).each { |line| tf.puts line.split.join(params[:joiner]) }
  tf.close
  FileUtils.mv(tf.path, params[:in_place])
else
  # process from argf
  ARGF.each { |line| puts line.split.join(params[:joiner]) }
end