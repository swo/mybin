#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'
require 'digest'

params = Arginine::parse do |a|
  desc "checks a website for its md5"
  opt :www, :default => "scottolesen.com"
  opt :hash, :default => ".check_www_hash"
  flag :save, :desc => "save hash rather than comparing?"
end

content = `curl --silent #{params[:www]}`
hash = Digest::MD5.hexdigest(content)

if params[:save]
  open(params[:hash], 'w').write(hash)
else
  # read in the hash file
  saved_hash = open(params[:hash]).read.strip

  if saved_hash == hash
    puts "hashes match"
  else
    puts "#{saved_hash} != #{hash}"
  end
end
