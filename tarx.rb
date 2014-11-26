#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'
require 'fileutils'

params = Arginine::parse do |a|
  desc "make a folder and untar the file"
  arg :tar, :desc => "archive to unpack"
  opt :dir, :desc => "specify dir name?", :default => nil
end

# get the directory name & make it
tar = File.basename(params[:tar])   # e.g., /path/to/foo.tar.gz -> foo.tar.gz
if params[:dir].nil?
  dir = "tmp_" + tar.gsub(/\.gz$/, '').gsub(/\.tar$/, '') # e.g., foo.tar.gz -> tmp_foo
else
  dir = params[:dir]
end

# make the directory and move the tar there
Dir.mkdir(dir)
tar_dest = File.join([dir, tar])
FileUtils.mv(tar, tar_dest)

# unpack the tar
# this command is designed to work for mac, which needs these environmental
# variables set to not do stupid stuff with the tar extraction
system "COPY_EXTENDED_ATTRIBUTES_DISABLE=true COPYFILE_DISABLE=true cd #{dir} && tar xf #{tar}"
