#!/usr/bin/env ruby
#
# author:: scott w olesen <swo@mit.edu>

require 'arginine'

params = Arginine::parse do
  desc "if line X in db file matches pattern, print line X of target file"
  arg :pattern
  arg :db
  arg :target
end

open(params[:db]).zip(open(params[:target])) do |db_line, target_line|
  puts target_line if db_line.match(params[:pattern])
end