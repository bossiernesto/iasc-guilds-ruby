# frozen_string_literal: true

class RactorPipelineExample
  attr_reader :ractor1, :ractor2, :ractor3

  def initialize
    # Ractor.current => returns current Ractor
    @ractor3 = Ractor.new Ractor.current do |current_ractor|
      current_ractor.send "#{Ractor.receive}r3"
    end

    @ractor2 = Ractor.new @ractor3 do |ractor_3|
      ractor_3.send "#{Ractor.receive}r2"
    end

    @ractor1 = Ractor.new @ractor2 do |ractor_2|
      ractor_2.send "#{Ractor.receive}r1"
    end
  end

end




