#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'
require 'set'

params = Arginine::parse do |a|
  desc "compare files in two directories by hashing"
  arg :dir1
  arg :dir2
end

def digest_hash(fns)
  # create a hash {sha digest => fn}
  h = {}
  fns.each do |fn|
    digest = Digest::SHA1.hexdigest(open(fn).read)
    h[digest] = fn
  end
  h
end

digest1 = digest_hash(Dir.glob("#{params[:dir1]}/*"))
digest2 = digest_hash(Dir.glob("#{params[:dir2]}/*"))

common_digests = Set.new(digest1.keys) & Set.new(digest2.keys)

puts "matched:" unless common_digests.empty?
common_digests.each do |digest|
  puts "#{digest1[digest]}=#{digest2[digest]}"
  digest1.delete(digest)
  digest2.delete(digest)
end

unless digest1.empty? and digest2.empty?
  puts
  puts "unmatched:"
  puts digest1.values
  puts digest2.values
end