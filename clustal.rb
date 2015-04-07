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
  flag :truncate, desc: "ignore starting or ending nts for which one seq has a gap?"
  flag :snp, desc: "only show SNP positions? (i.e., not *)"
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

if name_block_length - 6 != [27, longest_name].min
  raise "clustal label block length (#{name_block_length - 6}) is unexpected (longest name: #{longest_name})" 
end

data_range = name_block_length..-1

# add a fake name for the alignment line, then pad them to the same length
names << ""
names.map! { |name| name.ljust(name_block_length, " ") }

# unwrap the lines
data = names.each_with_index.map { |name, i| groups.map { |ls| ls[i][data_range] }.join("") }

# invert the alignments if desired
data[-1] = data[-1].tr(' .:*', 'xxx ') if params[:invert]

if params[:truncate]
  # ignore the last data line, which is the alignment
  # what's the longest string of dashes starting any one of those lines?
  start_i = data[0..-2].map { |seq| seq.match(/^-*/)[0].length }.max
  end_i = -(data[0..-2].map { |seq| seq.match(/-*$/)[0].length }.max + 1)
  data.map! { |line| line[start_i..end_i] }
end

if params[:snp]
  # ignore any spot that has a * in the alignment
  snp_positions = data[-1].each_char.each_with_index.select { |char, i| char != "*" }.map(&:last)
  data.map! { |line| line.each_char.to_a.values_at(*snp_positions).join("") }
end

if params[:unwrap]
  if params[:align_only]
    puts data.last
  else
    names.zip(data) { |name, datum| puts name + datum }
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
      names.zip(chunk) { |name, datum| puts name + datum }
      puts
    end
  end
end

# clean up the temporary file
params[:file].unlink if params.key? :file
