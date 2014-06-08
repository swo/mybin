#!/usr/bin/env ruby

class SortedSeek
  def initialize (fn, separator="\t", record_separator="\n")
    @fn = fn
    @f = File.open(@fn, 'r')
    @separator = separator
    @record_separator = record_separator

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
      @f.readline(@record_separator) unless mid == 0
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

options = {:field_separator => "\t", :record_separator => "\n"}
OptionParser.new do |opts|
    opts.banner = "Usage: sorted_seek.rb FILE IDS [options]\nSearch pre-sorted file for a line beginning with a field that matches each of the IDs. Print those lines."
    opts.on("-F", "--field_separator [SEPARATOR]", "Specify field separator (default: tab)") { |rs| options[:field_separator] = rs }
    opts.on("-R", "--record_separator [SEPARATOR]", "Specify record separator (default: \\n)") { |rs| options[:record_separator] = rs }
end.parse!

fn = ARGV.shift
seeker = SortedSeek.new(fn, options[:field_separator], options[:record_separator])

ARGF.each do |id|
  puts seeker.seek(id.chomp)
end
