#!/usr/bin/env ruby

# author:: scott w olesen <swo@mit.edu>

require 'arginine'
require 'iconv'
require 'fileutils'

params = Arginine.parse do
  desc "convert carriage returns to newline"
  flag :argf, desc: "read from argf?"
  opt :in_place, desc: "work in place"
  opt :bak_ext, desc: "backup extension", default: "bak" 
end

# make sure argf or in-place file specified
raise RuntimeError, "need to use argf or in-place" if !params[:argf] and params[:in_place].nil?

def d2u(s)
  ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
  ic.iconv(s).tr("\r", "\n").rstrip + "\n"
end

if params[:argf]
  ARGF.each { |line| puts d2u(line) }
else
  # move the original file to the backup location
  fn = params[:in_place]
  bak_fn = "#{fn}.#{params[:bak_ext]}"
  FileUtils.mv(fn, bak_fn)

  # write to the original file location
  open(fn, 'w') do |out|
    open(bak_fn).each { |line| out.write(d2u(line)) }
  end
end