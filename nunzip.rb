#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'
require 'fileutils'

params = Arginine::parse do |a|
  desc "make a folder and unzip the zip file in there"
  arg :zip, :desc => "archive to unpack"
  opt :dir, :desc => "specify dir name?", :default => nil
end

# get the directory name & make it
zip = File.basename(params[:zip])   # e.g., /path/to/foo.zip -> foo.zip
if params[:dir].nil?
  dir = "tmp_" + zip.gsub(/\.zip$/, '') # e.g., foo.zip -> tmp_foo
else
  dir = params[:dir]
end

# make the directory and unpack the zip
Dir.mkdir(dir)
system "unzip #{zip} -d #{dir}"
