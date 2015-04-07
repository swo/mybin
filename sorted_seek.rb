#!/usr/bin/env ruby

require 'arginine'

class SortedSeek
  def initialize(fn, separator="\t", record_separator="\n", block_size=4096)
    @fn = fn
    @f = File.open(@fn, 'r')
    @separator = separator
    @record_separator = record_separator

    @block_size = block_size
    @n_blocks = (@f.size.to_f / @block_size).ceil
  end

  def readline
    @f.readline(@record_separator).chomp
  end

  def parse_id(line)
    line.split(@separator).first
  end

  def seek(target_id)
    # preset the lower and upper bounds
    lb = 0
    ub = @n_blocks
    mid = (ub + lb) / 2

    # while we have not narrowed down to a single block
    while ub - lb > 1
      # go to the position, burn until a newline, then read the next full line
      @f.seek(mid * @block_size)
      readline unless mid.zero?
      line = readline
      id = parse_id(line)

      # move either the upper or lower bound to this midpoint
      # reset the midpoint to between the bounds
      if id < target_id
        lb = mid
      elsif id > target_id
        ub = mid
      elsif id == target_id
        # we just happened to find it, so stop searching
        return line
      else
        raise RuntimeError, "couldn't find #{id}"
      end
      mid = (ub + lb) / 2
    end

    # now we are in the right block. burn a line unless this is the first block.
    @f.seek(mid * @block_size)
    readline unless mid == 0

    # look through all the lines in this block for the line we want. if we don't find it,
    # return nil
    while @f.pos < ub * @block_size
      line = readline
      id = parse_id(line)
      
      return line if id == target_id
    end

    nil
  end

  def close
    @f.close
  end
end

par = Arginine::parse do
  desc "Search pre-sorted file for a line beginning with a field that matches each of the IDs. Print those lines."
  opt :field_separator, short: "F", default: "\t"
  opt :record_separator, short: "R", default: "\n"
  opt :block_size, default: 4096, cast: :to_i
  arg :db, help: "sorted database file"
  argf "lines to search for"
end

seeker = SortedSeek.new(par[:db], par[:field_separator], par[:record_separator], par[:block_size])

ARGF.each do |id|
  puts seeker.seek(id.chomp)
end