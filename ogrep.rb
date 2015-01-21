#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'

params = Arginine::parse do
  desc <<-EOH
  grep the pattern in one file. get the line numbers that matched that pattern.
  print those lines from another file.

  "header" means that the first line of the print file is printed automatically
  and not counted, so that a match on the Nth line of the grep file means that
  (N+1)th line of the print file will be printed.
  EOH
  arg :pattern
  arg :grep_file
  arg :print_file
  flag :numbers, desc: "print line numbers?"
  flag :header, desc: "treat first line of print file as header?"
end

# read in the lines
lines = `grep -n #{params[:pattern]} #{params[:grep_file]} | cut -d ":" -f 1`.split("\n")

if params[:header]
  lines.map! { |l| l.to_i + 1 }
  lines.unshift 1
end

# create a sed command to print only those lines
sed_program = lines.map { |l| "#{l}p" }.join(";")

if params[:numbers]
  sed_command = "nl -s ':' #{params[:print_file]} | sed -n '#{sed_program}'"
else
  sed_command = "sed -n '#{sed_program}' #{params[:print_file]}"
end

# run the sed command on the print file
system sed_command
