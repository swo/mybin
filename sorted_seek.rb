#!/usr/bin/env ruby

require 'arginine'

class SortedSeek
  def initialize(fn, separator="\t", record_separator="\n")
    @fn = fn
    @f = File.open(@fn, 'r')
    @separator = separator
    @record_separator = record_separator

    @block_size = 4096
    @n_blocks = (@f.size.to_f / @block_size).ceil
  end

  def seek(target_id)
    # preset the lower and upper bounds
    lb = 0
    ub = @n_blocks
    mid = (ub + lb) / 2

    while ub - lb > 1
      # go to the position, burn until a newline, then read the next full line
      @f.seek(mid * @block_size)
      @f.readline(@record_separator) unless mid.zero?
      id = @f.readline(@record_separator).split(@separator).first

      # move either the upper or lower bound to this midpoint
      # reset the midpoint to between the bounds
      if id < target_id
        lb = mid
      elsif id > target_id
        ub = mid
      elsif id == target_id
        # we just happened to find it, so stop searching
        break
      else
        raise RuntimeError, "couldn't find #{id}"
      end
      mid = (ub + lb) / 2
    end

    # now we are in the right block. burn a line unless this is the first block.
    @f.seek(mid * @block_size)
    @f.readline(@record_separator) unless mid == 0

    # look through all the lines in this block for the line we want. if we don't find it,
    # return nil
    target_found = false
    while @f.pos < ub * @block_size
      line = @f.readline(@record_separator)
      id = line.split(@separator).first
      
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
  arg :db, help: "sorted database file"
  argf "lines to search for"
end

seeker = SortedSeek.new(par[:db], par[:field_separator], par[:record_separator])

ARGF.each do |id|
  puts seeker.seek(id.chomp)
end