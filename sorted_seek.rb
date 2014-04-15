#!/usr/bin/env ruby

class SortedSeek
  def initialize (fn, separator="\t")
    @fn = fn
    @f = File.open(@fn, 'r')
    @separator = separator

    @block_size = 4096
    @n_blocks = (@f.size.to_f / @block_size).ceil
  end

  def seek (target_id)
    # preset the lower and upper bounds
    lb = 0
    ub = @n_blocks
    mid = (ub + lb) / 2

    while ub - lb > 1
      # go to the position, burn until a newline, then read the next full line
      @f.seek(mid * @block_size)
      @f.readline unless mid == 0
      id = @f.readline.split(@separator).first

      # move either the upper or lower bound to this midpoint
      # reset the midpoint to between the bounds
      if id < target_id
        lb = mid
      elsif id > target_id
        ub = mid
      else
        raise RuntimeError
      end
      mid = (ub + lb) / 2
    end

    # now we are in the right block. burn a line unless this is the first block.
    @f.seek(mid * @block_size)
    @f.readline unless mid == 0

    # look through all the lines in this block for the line we want. if we don't find it,
    # return nil
    target_found = false
    while @f.pos < ub * @block_size
      line = @f.readline
      id = line.split(@separator).first
      
      if id == target_id
        target_found = true
        break
      end
    end

    if target_found
      line
    else
      nil
    end
  end

  def close
    @f.close
  end
end

require 'optparse'

options = {:record_separator => "\t", :exclude_headers => false, :new_names => nil}
OptionParser.new do |opts|
    opts.banner = "Usage: sorted_seek.rb FILE IDS [options]\nSearch pre-sorted file for a line beginning with a field that matches each of the IDs. Print those lines."
    opts.on("-F", "--separator [SEPARATOR]", "Specify record separator (default: tab)") { |rs| options[:record_separator] = rs }
end.parse!

fn = ARGV.shift
seeker = SortedSeek.new(fn)

ARGF.each do |id|
  puts seeker.seek(id.chomp)
end
