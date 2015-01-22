#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'

params = Arginine::parse do
  desc "split a fastq into n parts"
  arg :n, cast: :to_i
  arg :fastq
end

# figure out if this is a fastq by looking at the first character
raise "file not a fastq" unless open(params[:fastq], &:readline)[0] == "@"

# get the number of entries
ne = `wc -l #{params[:fastq]}`.split.first.to_i / 4
base_epc = ne / params[:n]
extra_entries = ne % params[:n]

# number of digits to put after the output filenames
nd = params[:n] / 10 + 1

# entries per chunk
# you might have to add one extra entry because the division isn't even
epc = 1.upto(params[:n]).collect { |i| base_epc + (i <= extra_entries ? 1 : 0) }

# lines per chunk
lpc = epc.map { |e| e * 4 }

# what lines do you stop at?
stops = lpc.inject([]) do |out, l|
  if out.empty?
    out << l
  else
    out << l + out.last
  end
end
stops.pop

# what breaks do you feed to csplit?
breaks = stops.map { |x| x+1 }.join(" ")

exec "csplit -n #{nd} -f #{params[:fastq]}. #{params[:fastq]} #{breaks}"
