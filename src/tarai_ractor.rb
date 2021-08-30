# frozen_string_literal: true

require 'benchmark'

def tarai(x, y, z)
  if x <= y
    y
  else
    tarai(tarai(x - 1, y, z),
          tarai(y - 1, z, x),
          tarai(z - 1, x, y))
  end
end

Benchmark.bm do |x|
  # sequential version
  x.report('seq call') { 2.times { tarai(14, 7, 0) } }

  # parallel version using ractors
  x.report('par (Ractor)') do
    2.times.map do
      Ractor.new { tarai(14, 7, 0) }
    end.each(&:take)
  end
end
