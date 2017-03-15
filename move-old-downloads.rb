#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'
require 'shellwords'

par = Arginine::parse do
  opt :base_dir, default: '/Users/scott/Downloads'
  opt :age_limit, default: 14
  flag :dry_run, short: 'z'
end

t = Time.now
cmds = []
Dir.glob(par[:base_dir] + '/*').each do |abs_fn|
  # expect that each file is in the base dir
  fn = File.basename(abs_fn)

  raise unless long_fn = par[:base_dir] + '/' + fn
  next if fn == 'old'

  days_old = (t - File.mtime(abs_fn)) / (60 * 60 * 24)
  periods_old = days_old / par[:age_limit]

  if periods_old > 2
    # this file is too old; it needs to have its date restarted
    cmds << "touch #{abs_fn.shellescape}"
  elsif periods_old > 1
    cmds << "mv #{abs_fn.shellescape} #{(par[:base_dir] + '/old/' + fn).shellescape}"
  end
end

if cmds.empty?
  puts "up to date"
else
  puts cmds

  unless par[:dry_run]
    print "confirm? [yN] "
    line = gets.chomp
    if line.match(/^(y|Y)$/)
      cmds.each { |c| system c }
    else
      puts "not executing"
    end
  end
end
