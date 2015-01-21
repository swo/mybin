#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'

params = Arginine::parse do
  desc "grep the pattern in one file.\nget the line numbers that matched that pattern.\nprint those lines from another file.\n"
  arg :pattern
  arg :grep_file
  arg :print_file
  flag :numbers, desc: "print line numbers?"
end

# read in the lines
lines = `grep -n #{params[:pattern]} #{params[:grep_file]} | cut -d ":" -f 1`.split("\n")

# create a sed command to print only those lines
sed_program = lines.map { |l| "#{l}p" }.join(";")

if params[:numbers]
  sed_command = "nl -s ':' #{params[:print_file]} | sed -n '#{sed_program}'"
else
  sed_command = "sed -n '#{sed_program}' #{params[:print_file]}"
end

# run the sed command on the print file
system sed_command
