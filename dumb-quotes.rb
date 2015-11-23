#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'

par = Arginine::parse do
  desc "convert smart quotes to dumb quotes"
  argf
end

ARGF.each do |line|
    print line.tr('”“', '""').tr("‘’", "''")
end
