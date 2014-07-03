#!/usr/bin/env ruby

ARGF.each { |line| puts line.chomp.tr('acgtACGT', 'tgcaTGCA').reverse }
