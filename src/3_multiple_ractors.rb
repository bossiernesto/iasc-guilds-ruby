# Create 10 ractors and they send objects to pipe ractor.
# pipe ractor yield received objects

pipe = Ractor.new do
  loop do
    Ractor.yield Ractor.receive
  end
end

RN = 10
rs = RN.times.map{|i|
  Ractor.new pipe, i do |pipe, i|
    pipe << i
  end
}

pp RN.times.map{
  pipe.take
} #=> [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

