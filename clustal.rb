#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>

require 'arginine'
require 'tempfile'

params = Arginine::parse do |a|
  desc "align sequences with clustal"
  flag :align_only, desc: "show only alignment?"
  flag :invert, desc: "mark only unmatched positions?"
  flag :unwrap, desc: "show one line per sequence/alignment?"
  argf "fasta"
end

if ARGV.length == 1
  # just run clustalo on this one file
  params[:fasta] = ARGV.first
else
  # concatenate the ARGF into a tmp file
  params[:file] = Tempfile.new("clustalo")
  params[:file].write(ARGF.read)
  params[:file].close
  params[:fasta] = params[:file].path
end


# get the number of sequences
n_seq = `grep -c ">" #{params[:fasta]}`.to_i

# get results from clustalo. drop the first banner line and empty lines.
# throw a blank line at the end to help the math
lines = `clustalo --outfmt=clu -i #{params[:fasta]}`.split("\n").drop_while { |line| line.empty? or line.match("CLUSTAL") }
lines << "\n"

# get the groups (there are seq lines, align line, and blank line = seq+2)
# drop the blank line
groups = lines.each_slice(n_seq + 2).map { |x| x[0..-2] }

# grab the sequence names (ignoring the align line)
names = groups.first[0..-2].map { |line| line.split.first }

# find the size of the label block
name_block_length = groups.first.first.strip.match(/.*\s+/)[0].length
longest_name = names.map(&:length).max
raise "clustal label block length is unexpected" if name_block_length - 6 != [27, longest_name].min
data_range = name_block_length..-1

# add a fake name for the alignment line, then pad them to the same length
names << ""
names.map! { |name| name.ljust(name_block_length, " ") }

# unwrap the lines
data = names.each_with_index.map { |name, i| groups.map { |lines| lines[i][data_range] }.join("") }

# invert the alignments if desired
data[-1] = data[-1].tr(' .:*', 'xxx ') if params[:invert]

if params[:unwrap]
  if params[:align_only]
    puts data.last
  else
    names.zip(data) { |name, data| puts name + data }
  end
else
  # break up the data into chunks [[seq1 chunk1, seq2 chunk1, ...], [s1c2, s2c2, ...]]
  cols = `tput cols`.to_i
  data_block_length = cols - name_block_length

  if params[:align_only]
    puts data.last.scan(/.{1,#{cols}}/)
  else
    data_chunks = data.map { |s| s.scan(/.{1,#{data_block_length}}/) }.transpose

    data_chunks.each do |chunk|
      names.zip(chunk) { |name, data| puts name + data }
      puts
    end
  end
end

# clean up the temporary file
params[:file].unlink if params.key? :file
