#!/usr/bin/env ruby
#
# author: scott w olesen <swo@mit.edu>
#
# align any two strings. naively scan one string against the other, looking for identical
# characters to make the score.

require 'arginine'

class Aligner
  def initialize(a, b)
    @a = a
    @b = b

    @best_offset = ((-@b.length + 1)..(@a.length - 1)).max_by { |offset| score(*alignment(offset)) }
    @best_score = score(*alignment(@best_offset))
  end

  def score(a, b)
    a.each_char.zip(b.each_char).inject(0) { |sum, chars| chars[0] == chars[1] ? sum + 1 : sum }
  end

  def alignment(offset)
    if offset == 0
      x = @a
      y = @b
    elsif offset < 0
      x = '-'*(-offset) + @a
      d = x.length - @b.length
      if d > 0
        y = @b + '-'*d
      else
        x = x + '-'*(-d)
        y = @b
      end
    elsif offset > 0
      y = '-'*offset + @b
      d = y.length - @a.length
      if d > 0
        x = @a + '-'*d
      else
        x = @a
        y = y + '-'*(-d)
      end
    end

    [x, y]
  end

  def alignment_symbol(a, b)
    if a == b
      '*'
    else
      ' '
    end
  end

  def alignment_visual(a, b)
    a.each_char.zip(b.each_char).collect { |c, d| alignment_symbol(c, d) }.join('')
  end

  def show_alignment(offset)
    x, y = alignment(offset)
    puts x
    puts y
    puts alignment_visual(x, y)
  end

  def show_best_alignment
    show_alignment(@best_offset)
  end

  def show_stats
    puts
    puts "a length: #{@a.length}"
    puts "b length: #{@b.length}"
    puts "score: #{@best_score}"
  end
end

params = Arginine::parse do |a|
  a.flag "stats", :desc => "show alignment stats?"
  a.arg "A"
  a.arg "B"
end

aligner = Aligner.new(params["A"], params["B"])
aligner.show_best_alignment
aligner.show_stats if params["stats"]
